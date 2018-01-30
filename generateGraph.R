packages <- c("Gviz","refGenome","Rsamtools")
package.check <- lapply(packages,FUN = function(x){
			if(!require(x,character.only=TRUE)){
				install.packages(x,dependencies=TRUE)
				library(x,character.only=TRUE)
				}
			})

generateGraph <- function(bam,gtf,chr,pdf){
	ens<-ensemblGenome()
	read.gtf(ens,gtf)
	gtffile <- getGtf(ens)
	geneModel <- gtffile[,c('seqid','start','end','strand','feature','gene_id','exon_id','transcript_id','gene_name')]
	geneModel["width"] <- geneModel$end-geneModel$start
	names(geneModel) <- c('chromosome','start','end','strand','feature','gene','exon','transcript','symbol','width')
	model <- geneModel[geneModel$feature != 'transcript',]
	trmodel <- geneModel[geneModel$feature == 'transcript',]
	chrmodel <- model[model$chromosome == chr,]
	grtrack <- GeneRegionTrack(chrmodel, genome = 'galGal4',chromosome = chr, name = "Gene Model")
	gtrack <- GenomeAxisTrack()
	altrack <- AlignmentsTrack(bam)
	bamfile <- scanBam(bam)[[1]]
	ah <- head(bamfile$pos,n=1)-5000
	ab <- tail(bamfile$pos,n=1)+5000
	geneloc <- getGenePositions(ens)
	gene_pos <- geneloc[geneloc$start > ah,]
	pdf(file = pdf, width = 6.25, height = 4, family = "Times", pointsize = 12, onefile = TRUE)
	plotTracks(list(gtrack,altrack,grtrack),from=ah,to=ab,chromosome=chr,transcriptAnnotation="symbol",type="coverage")
	dev.off()
	return(dir("./",pattern="*.pdf"))
}
