## View bam files and modify third column with awk
samtools view 41_FAM3C.bam| awk '{$3 = "chr"$3; print}' | less -S

## View bam files, modify third column with awk and maintain field seprator
samtools view 41_FAM3C.bam| awk '{$3 = "chr"$3; print}'| awk -v OFS="\t" '$1=$1'>lst.sam

## View bam header files, modify header with sed and write to sam
samtools view -H 41_FAM3C.bam | sed -e 's/SN:1/SN:chr1/' -e 's/SN:2/SN:chr2/'>header.sam

## For each bam file create index using samtools
for i in `ls *.bam`; do echo $i; samtools index $i; done

## View file after line 6, capture pattern and write columns to file 
tail -n +6 Gallus_gallus.gtf |grep 'gene'|awk '{print "chr"$1"\t"$4"\t"$5"\t"$7"\t"$3}'>gallus.txt
