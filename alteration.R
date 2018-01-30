for(i in 1:length(trmodel$id)){
jpeg(filename=paste("myplot_", i, ".jpg", sep = ""))
plotTracks(list(gtrack,altrack,grtrack),from=trmodel$start[i],to=trmodel$end[i],chromosome=chr,transcriptAnnotation="symbol",type="coverage")
dev.off()
}

genes <- getGenePositions(ens)
for (i in seq(1,20))
	{
	plotTracks(list(gtrack,altrack,grtrack),from=gene_pos$start[i],to=gene_pos$end[i],chromosome=chr,transcriptAnnotation="symbol",type="coverage")
	}
