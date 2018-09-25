
PROCESSED_READS=/data2/manish/2018/8.August/SO_8161/Reads/Processed_Reads
PLASMID_BOWTIE_INDEX=/data1/ngs/projects/abhi/projects/7000-7999/SO_7385/Alignment/plas_bow2_db
BOWTIE_PATH=/data1/ngs/programs/bowtie2-2.2.5/
ASSEMBLY_PATH=/data2/manish/2018/8.August/SO_8161/Analysis/Primary_Analysis/3.Assembly
MAPPED_READS=/data2/manish/2018/8.August/SO_8161/Analysis/Primary_Analysis/3.Assembly/Mapped_Reads
PLASMID_SPADES=/data1/ngs/programs/SPAdes-3.9.1-Linux/bin/

SAMPLES=$(ls -l $PROCESSED_READS |awk '{print $9}'|sed 's/_R[1|2].fastq//'|sort|uniq|tr '\n' ' ')

mkdir -p $ASSEMBLY_PATH
mkdir -p $MAPPED_READS

for sample in $SAMPLES

do

echo "\n$sample\n"
echo "Step 1: Alignment with bowtie\n"

$BOWTIE_PATH/bowtie2 -x $PLASMID_BOWTIE_INDEX -1 $PROCESSED_READS/${sample}_R1.fastq -2 $PROCESSED_READS/${sample}_R2.fastq -S $ASSEMBLY_PATH/${sample}.sam -p 18

#######--------> For getting the R1 reads

cat $ASSEMBLY_PATH/${sample}.sam | awk -F "\t" '{if($0 !~/^@/ && $3 != "*" && NR %2 == 0 ){print "@"$1"\n"$10"\n+\n"$11}}' > $MAPPED_READS/${sample}_R1.fastq

#######---------> For getting the R2 reads

cat $ASSEMBLY_PATH/${sample}.sam | awk -F "\t" '{if($0 !~/^@/ && $3 != "*" && NR %2 == 1 ){print "@"$1"\n"$10"\n+\n"$11}}'  > $MAPPED_READS/${sample}_R2.fastq

$PLASMID_SPADES/plasmidspades.py -o $ASSEMBLY_PATH/$sample -1 $MAPPED_READS/${sample}_R1.fastq -2 $MAPPED_READS/${sample}_R2.fastq --only-assembler --careful -t 25

done
