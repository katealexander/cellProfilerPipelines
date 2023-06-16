library(ggplot2)
library(viridis)
library(dplyr)
library(ggpubr)


setwd("~/Documents/cellProfilerPipelines/knockdownQuantification/")

B <- read.table("intensityAllSamples.txt", header=T, sep="\t")

## check knockdown of ALYREF
C <- B[B$Well == "NTC" | B$Well == "ALYkd5" | B$Well == "ALYkd8",] # just the ALYREF and NTC samples
C$Well <- factor(C$Well, levels=c("NTC", "ALYkd5", "ALYkd8")) # sorting so that NTC is first
my_specific_comparisons <- list(c("NTC", "ALYkd5"), c("NTC", "ALYkd8"))
p = ggplot(C, aes(x=Well, y=Intensity_MedianIntensity_A647, fill=factor(Well))) + 
  geom_violin(col="black", linewidth=1) + 
  theme_classic() + 
  scale_fill_manual(values = c("#BCBEC0", "#D7BFDC", "#B284BE"))+
  stat_compare_means(comparisons = my_specific_comparisons, method = "wilcox.test", size = 4, tip.length = 0.01, step.increase = 0.06, label = "p.signif", vjust = .6, hide.ns = T)
filename = "ALYREF_intensity.pdf"
pdf(filename, width = 3, height = 2, onefile=FALSE)
print(p)
dev.off()
