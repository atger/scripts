library(Gviz)
library(Rsamtools)

indexBam("accepted_hits.bam")
file <-system.file("extdata","accepted-hits.bam",package="Gviz")

alTrack <- AlignmentsTrack("accepted_hits.bam")
bmt <- BiomartGeneRegionTrack(genome = "hg19", chromosome = "chr12",start = afrom, end = ato, filter = list(with_ox_refseq_mrna = TRUE), stacking = "dense")
afrom <- 1
ato <- 30000
plotTracks(alTrack, from = afrom, to = ato,chromosome = "12")
