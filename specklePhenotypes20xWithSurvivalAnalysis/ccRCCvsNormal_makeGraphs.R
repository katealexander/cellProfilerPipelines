library(ggplot2)
library(viridis)
library(dplyr)
library(ggpubr)

setwd("~/Documents/cellProfilerPipelines/specklePhenotypes20xWithSurvivalAnalysis")
C <- read.table("~/Documents/cellProfilerPipelines/specklePhenotypes20xWithSurvivalAnalysis/survivalAndMeasurements.txt", sep="\t", header=T)
my_comparisons <- list( c("clear cell carcinoma", "NAT"))
C <- as.data.frame(C)

## Graph grade for specific variables
my_specific_comparisons <- list( c("G1","G3"), c("", "G1"))
p = ggplot(C, aes(x=Grade, y=RadialDistribution_FracAtD_CorrectedA647_4of4, fill=factor(Grade))) + 
  geom_violin(col="black", size=1) + 
  geom_jitter(color="grey20", size=1, alpha= .7) + 
  theme_classic() + 
  scale_fill_viridis(discrete = TRUE, alpha=0.6, option = "A") + 
  theme(legend.position="none") +
  stat_compare_means(comparisons = my_specific_comparisons, method = "wilcox.test", size = 4, tip.length = 0.02)
file_name = paste("grade_RadialDistribution_FracAtD_CorrectedA647_4of4", ".pdf", sep="")
pdf(file_name, width = 6, height = 6)
print(p)
dev.off()

my_specific_comparisons <- list( c("G1","G3"), c("", "G1"))
p = ggplot(C, aes(x=Grade, y=RadialDistribution_FracAtD_CorrectedA647_1of4, fill=factor(Grade))) + 
  geom_violin(col="black", size=1) + 
  geom_jitter(color="grey20", size=1, alpha= .7) + 
  theme_classic() + 
  scale_fill_viridis(discrete = TRUE, alpha=0.6, option = "A") + 
  theme(legend.position="none") +
  stat_compare_means(comparisons = my_specific_comparisons, method = "wilcox.test", size = 4, tip.length = 0.02)
file_name = paste("grade_RadialDistribution_FracAtD_CorrectedA647_1of4", ".pdf", sep="")
pdf(file_name, width = 6, height = 6)
print(p)
dev.off()

#make a list of columns to loop through
var_list = names(C)[15:338]

# create a directory for the plots 
if (!dir.exists("tumorVsNAT")){
  dir.create("tumorVsNAT")
}

#make plots
plotList = list()
for (i in 1:length(var_list)) { 
  p = ggplot(C, aes(x=Pathology.diagnosis, y=C[[var_list[i]]], fill=factor(Pathology.diagnosis))) + 
    geom_violin(col="black", size=1) + 
    geom_jitter(color="grey20", size=0.3, alpha= .7) + 
    theme_classic() + 
    scale_fill_viridis(discrete = TRUE, alpha=0.6) + 
    theme(legend.position="none") + 
    stat_compare_means(comparisons = my_comparisons, method = "wilcox.test", size = 4, tip.length = 0.02) +
    ylab(var_list[i])
  
  file_name = paste("tumorVsNAT/tumorVsNormal_", var_list[i], ".pdf", sep="")
  pdf(file_name, width = 3, height = 6)
  print(p)
  dev.off()
}




