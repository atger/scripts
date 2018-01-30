# final R script

packages <- c("Gviz","refGenome","Rsamtools")
package.check <- lapply(packages,FUN = function(x){
			if(!require(x,character.only=TRUE)){
				install.packages(x,dependencies=TRUE)
				library(x,character.only=TRUE)
				}
			})

gtffile <- "gallus.gtf"
bamfile <-  list.files("./",pattern="*.bam$")
generateTrack <- function(bam){
	gtrack <- GenomeAxisTrack()
	altrack <- AlignmentsTrack(bam)
	return(list(gtrack,altrack))
}
tracks <- lapply(bamfile,generateTrack)
ens<-ensemblGenome()
read.gtf(ens,gtffile)
genes <- getGenePositions(ens)
geneModel <- wholefile[,c('seqid','start','end','strand','feature','gene_id','exon_id','transcript_id','gene_name')]
geneModel["width"] <- geneModel$end-geneModel$start
names(geneModel) <- c('chromosome','start','end','strand','feature','gene','exon','transcript','symbol','width')
chr1Model <-geneModel[geneModel$chromosome == 'chr1',]
grtrack <- GeneRegionTrack(genes, genome = 'galGal4',chromosome ="chr1", name = "Gene Model")

plotTracks(generateTrack(),from=1735,to=16308,chromosome='chr1',type="coverage")
