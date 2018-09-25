######## Assembly check using the recycler tool

PROCESSED_READS=/data2/manish/2018/8.August/SO_8161/Reads/Processed_Reads
ASSEMBLY_PATH=/data2/manish/2018/8.August/SO_8161/Analysis/Primary_Analysis/1.Assembly
PLASMID_BLAST_DATABASE=/data2/manish/DB/Plasmid_DB/Plamsid_Bacillus_NCBI_20112017.fasta/data2/manish/DB/Plasmid_DB/Plamsid_Bacillus_NCBI_20112017.fasta
RECYCLER=/data2/manish/2018/8.August/SO_8161/Analysis/Primary_Analysis/2.Recycler
RECYCLER_PATH=/data2/manish/2018/8.August/SO_8161/Recycler-v0.7/Recycler-0.7/bin
BWA_PATH=/data1/ngs/programs/bwa-0.7.17
BLAST_PATH=/data1/ngs/programs/ncbi-blast-2.2.29+/bin
SPADES_PATH=/data1/ngs/projects/nagu/software/SPAdes-3.7.1-Linux/bin

SAMPLES=$(ls -l $PROCESSED_READS |awk '{print $9}'|sed 's/_R[1|2]_001_ablt.fastq//'| tr '\t' ' '|sort|uniq)

for sample in $SAMPLES

do

echo "\n<--- "$sample" --->\n"

mkdir $RECYCLER_PATH/$sample

echo "Step 1: Assembly of Processed Reads Started ...\n"
$SPADES_PATH/spades.py -o $ASSEMBLY_PATH/${sample} -1 $PROCESSED_READS/${sample}_R1.fastq -2 $PROCESSED_READS/${sample}_R2.fastq --only-assembler --careful -t 15

echo "Step 2: Recycler: Making fasta from fastg ...\n"
python $RECYCLER/make_fasta_from_fastg.py -g $ASSEMBLY_PATH/${sample}/assembly_graph.fastg -o $RECYCLER_PATH/$sample/assembly_graph.nodes.fasta

echo "Step 3: Creating index for fasta file ...\n"
$BWA_PATH/bwa index $RECYCLER_PATH/$sample/assembly_graph.nodes.fasta

echo "Step 4: Creating Alignment against fasta file ...\n"
$BWA_PATH/bwa mem -t 20 $RECYCLER_PATH/$sample/assembly_graph.nodes.fasta $PROCESSED_READS/${sample}_R1.fastq $PROCESSED_READS/${sample}_R2.fastq| samtools view -buS > $RECYCLER_PATH/$sample/reads_pe.bam

echo "Step 5\n"
samtools view -bF 0x0800 $RECYCLER_PATH/$sample/reads_pe.bam > $RECYCLER_PATH/$sample/reads_pe_primary.bam

echo "Step 6\n"
samtools sort $RECYCLER_PATH/$sample/reads_pe_primary.bam > $RECYCLER_PATH/$sample/reads_pe_primary.sort.bam

echo "Step 7\n"
samtools index $RECYCLER_PATH/$sample/reads_pe_primary.sort.bam

echo "Step 8\n"
python $RECYCLER/recycle.py -g $ASSEMBLY_PATH/${sample}/assembly_graph.fastg -k 77 -b $RECYCLER_PATH/$sample/reads_pe_primary.sort.bam -i True -o $RECYCLER_PATH/$sample

echo "Step 9 : Blast against plasmid database\n"
$BLAST_PATH/blastn -db $PLASMID_BLAST_DATABASE -query $RECYCLER_PATH/$sample/assembly_graph.cycs.fasta -outfmt 6 -max_target_seqs 10 -num_threads 10 -out $RECYCLER_PATH/$sample/plasmid_org_blast.out|cat plasmid_org_blast.out;


done
