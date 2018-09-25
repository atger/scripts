#### Trimming the raw data using cutadapt ###

for sample in SO_8161_2712_BHI_E1_Rerun_S15 SO_8161_4162_BHI_E1_Rerun_S14 SO_8161_4987_T_BHI_E1_Rerun_S13

do echo -en ${sample} "\n";

	/data1/ngs/programs/cutadapt-1.8.3/bin/cutadapt -a CTGTCTCTTGATCACA -A CTGTCTCTTGATCACA -o ${sample}_R1.fastq -p ${sample}_R2.fastq -m 20 ../Raw_Reads/${sample}_R1_001.fastq.gz ../Raw_Reads/${sample}_R2_001.fastq.gz -q 30

done;
