clear
echo -e "Count number of records(unmapped reads + each aligned location per mapped read) in a bam file: "
samtools view -c $1
echo -e "\nCount with flagstat for additional information:"
samtools flagstat $1
echo -e "\nCount the number of alignments (reads mapping to multiple locations counted multiple times)"
samtools view -F 0x04 -c $1
echo -e "\nCount number of mapped reads (not mapped locations) for left and right mate in read pairs"
samtools view -F 0x40 $1 | cut -f1 | sort | uniq | wc -l
samtools view -f 0x40 -F 0x4 $1 | cut -f1 | sort | uniq | wc -l #left mate
samtools view -f 0x80 -F 0x4 $1 | cut -f1 | sort | uniq  | wc -l #right mate
echo -e "\nCount UNmapped reads:"
samtools view -f4 -c $1
