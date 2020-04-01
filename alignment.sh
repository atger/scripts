#source $1
SC=$1
Project_Folder=../../../Projects/8000-8999/SO_8498
Raw_Reads=/mnt/ngs/data/rawdata/8000-8999/SO_8498/rawdata/
#Project_Folder=$1
#Raw_Data=$2
#Reference=$3

# Create Directories
mkdir -pv $Project_Folder/Analysis/{Primary_Analysis,Support}
mkdir -pv $Project_Folder/Reports/{Standard_Reports,Support_Reports}
mkdir -pv $Project_Folder/{Project_Plan,Reads/{Raw_Reads,Processed_Reads,QC},Logs}

# Commonly used variables
Processed_Reads=$Project_Folder/Reads/Processed_Reads
Reference=$Project_Folder/Analysis/References
Alignment_Folder=$Project_Folder/Analysis/Alignment
Variant_Folder=$Project_Folder/Analysis/Variant_Analysis

# New folders
mkdir -pv $Reference
mkdir -pv $Alignment_Folder
mkdir -pv $Variant_Folder

#==========================================================================================================================#

# Copying data
#cp -v $Raw_Data/*gz $Project_Folder/Reads/Processed_Reads


if ls $Reference/*.fasta &>/dev/null && ls $Reference/*.gff &>/dev/null;
then

ls -1 $Reference
read -p "Select Reference to use : " ref
refseq=$(echo $ref| sed 's/.fasta//')
echo $refseq

samples=$(ls -1 $Raw_Reads|grep -o ".*${SC}.*.gz"|sed 's/\(.*\)_R[1|2]\(.*\)/\1/'|sort|uniq)
ext=$(ls -1 $Raw_Reads|grep -o ".*${SC}.*.gz"|sed 's/.*_R[1|2]\(.*\)/\1/'|sort|uniq)

for sample in $samples
do
<<END
/data1/ngs/programs/trim_galore \
-q 30 --length 20 --paired \
-o $Processed_Reads \
$Raw_Reads/${sample}_R1$ext \
$Raw_Reads/${sample}_R2$ext

/data1/ngs/programs/bowtie2-2.2.5/bowtie2-build $Reference/${refseq}.fasta $Reference/${refseq}.fasta

pext=$(ls -1 $Processed_Reads|grep -o ".*${SC}.*.gz$"|sed 's/.*_R[1|2]\(.*\)[1|2].fq.gz/\1/'|sort|uniq)
echo "pext : "$pext
/data1/ngs/programs/bowtie2-2.2.5/bowtie2 \
-x $Reference/${refseq}.fasta \
-1 $Processed_Reads/${sample}_R1${pext}1.fq.gz \
-2 $Processed_Reads/${sample}_R2${pext}2.fq.gz \
-S $Alignment_Folder/${sample}.sam \
-p 20

samtools flagstat $Alignment_Folder/${sample}.sam > $Alignment_Folder/${sample}_alignment_statistics.txt

samtools view -S -b $Alignment_Folder/${sample}.sam > $Alignment_Folder/${sample}.bam

samtools sort $Alignment_Folder/${sample}.bam > $Alignment_Folder/${sample}_sorted.bam

samtools index $Alignment_Folder/${sample}_sorted.bam

# mpileup generation
/data1/ngs/programs/samtools-1.3/samtools mpileup -d 250 -f $Reference/${refseq}.fasta $Alignment_Folder/${sample}_sorted.bam \
> $Alignment_Folder/${sample}_mpileup.txt

# Generate alignment depth analysis table , give genome size as last argument
sh AlignmentQC.sh $Alignment_Folder/${sample}_mpileup.txt $Alignment_Folder/${sample}.sam \
$(cat $Reference/${refseq}.fasta|grep -v ">"|paste -sd ''|wc -c) > $Alignment_Folder/${sample}_coverage.txt

# Generate bcf
samtools mpileup -d 250 -L 250 -u -f $Reference/${refseq}.fasta $Alignment_Folder/${sample}_sorted.bam > $Variant_Folder/${sample}.bcf
echo "Generated bcf"

# Call variant
bcftools call -Avc $Variant_Folder/${sample}.bcf -O v -o $Variant_Folder/${sample}.vcf
echo "Generated vcf"

# Filter with quality and depth
vcfutils.pl varFilter -Q 30 -d 20 $Variant_Folder/${sample}.vcf  > $Variant_Folder/${sample}_depth_qual.vcf

# preparing snpEff folder
refname=$(echo $Reference/${refseq}.fasta |sed 's/.*\/\(.*\)/\1/'| sed 's/.fasta//')
mkdir -pv /data1/ngs/programs/snpEff/data/$refname
cp -nv $Reference/${refseq}.fasta /data1/ngs/programs/snpEff/data/$refname/sequences.fa
cp -nv $Reference/${refseq}.gff /data1/ngs/programs/snpEff/data/$refname/genes.gff
echo -e "# Genome $refname \n ${refname}.genome : $refname" >> /data1/ngs/programs/snpEff/snpEff.config

# Edit Config file and put sequences.fa and genes.gff file in snpEff data folder
java -jar /data1/ngs/programs/snpEff/snpEff.jar build -gff3 -c /data1/ngs/programs/snpEff/snpEff.config $refname

cd $Variant_Folder

# run snpEff to annotate variants
java -jar /data1/ngs/programs/snpEff/snpEff.jar eff -minQ 30 -minC 20 -no-downstream -no-upstream -c /data1/ngs/programs/snpEff/snpEff.config \
$refname ${sample}_depth_qual.vcf -o txt > ${sample}_depth_qual_anno.vcf

cd -

echo "Annotation finished"
# generate excel from snpEff result
perl snpEff_parser.pl $Variant_Folder/${sample}_depth_qual_anno.vcf $Variant_Folder/${sample}_depth_qual_anno
END
# Consensus Generation

#bcftools mpileup -Ou -f $Reference/${refseq}.fasta $Alignment_Folder/${sample}_sorted.bam | bcftools call -mv -Oz -o $Variant_Folder/${sample}_calls.vcf.gz
bgzip -c $Variant_Folder/${sample}_depth_qual.vcf > $Variant_Folder/${sample}_depth_qual.vcf.gz
bcftools index $Variant_Folder/${sample}_depth_qual.vcf.gz
cat $Reference/${refseq}.fasta | bcftools consensus $Variant_Folder/${sample}_depth_qual.vcf.gz > $Variant_Folder/${sample}_consensus.fa

done

else
echo "Download and put references and gff in $Project_Folder/Analysis/References folder."
read -p "Type \"done\" to continue : " ans
exec bash "$0" "$@"

fi

