setwd("~/Documents/cellProfilerPipelines/specklePhenotypes60x/")

library(ggplot2)
library(ggpubr)
library(viridis)
A <- read.table("nucleiData.txt", sep="\t", header=T)

# number of speckles
my_specific_comparisons <- list(c("1_NTC", "2_ALYkd5"), c("1_NTC", "3_ALYkd8"))
p = ggplot(A, aes(x=wellCode, y=numSpeckles, fill=factor(wellCode))) +
  geom_boxplot(col="black", size=1, outlier.size = 0) +
  stat_compare_means(comparisons = my_specific_comparisons, method = "wilcox.test", size = 4, tip.length = 0.015, step.increase = 0.08, label = "p.signif", vjust = .6, hide.ns = T, label.y = 60) +
  geom_jitter(color="grey20", size=.01, alpha= .5) +
  theme_classic() +
  theme(legend.position="none") +
  ylim(0,90)  +
  scale_fill_manual(values = c("#BCBEC0", "#D7BFDC", "#B284BE"))
filename = "numSpecklesPerNucleus_boxplot.pdf"
pdf(filename, width = 2, height = 2, onefile=FALSE)
print(p)
dev.off()

# area of speckle per cell
p = ggplot(A, aes(x=wellCode, y=totalSpeckleArea/AreaShape_Area, fill=factor(wellCode))) +
  geom_boxplot(col="black", size=1, outlier.size = 0) +
  geom_jitter(color="grey20", size=.01, alpha= .5) +
  theme_classic() +
  theme(legend.position="none") +
  ylim(0,0.3) +
  scale_fill_manual(values = c("#BCBEC0", "#D7BFDC", "#B284BE"))
filename = "speckleAreaPerNucleus_boxplot.pdf"
pdf(filename, width = 2, height = 2, onefile=FALSE)
print(p)
dev.off()

# area non extra large speckles per nucleus
p = ggplot(A[(A$areaMediumSpeckles != 0) | (A$areaLargeSpeckles != 0),], aes(x=wellCode, y=areaMediumSpeckles/totalSpeckleArea+areaLargeSpeckles/totalSpeckleArea, fill=factor(wellCode))) +
  geom_boxplot(col="black", size=1, outlier.size = 0) +
  stat_compare_means(comparisons = my_specific_comparisons, method = "wilcox.test", size = 4, tip.length = 0.01, step.increase = 0.07, label = "p.signif", vjust = .6, hide.ns = T, label.y = 1) +
  geom_jitter(color="grey20", size=.01, alpha= .5) +
  theme_classic() +
  theme(legend.position="none") +
  ylim(0,1.19) +
  scale_fill_manual(values = c("#BCBEC0", "#D7BFDC", "#B284BE"))
filename = "areaNonXLPerSpeckleArea_boxplot.pdf"
pdf(filename, width = 2, height = 2, onefile=FALSE)
print(p)
dev.off()

# area extra large speckles per nucleus
p = ggplot(A[A$areaExtraLargeSpeckles != 0,], aes(x=wellCode, y=areaExtraLargeSpeckles/totalSpeckleArea, fill=factor(wellCode))) +
  geom_boxplot(col="black", size=1, outlier.size = 0) +
  stat_compare_means(comparisons = my_specific_comparisons, method = "wilcox.test", size = 4, tip.length = 0.01, step.increase = 0.07, label = "p.signif", vjust = .6, hide.ns = T, label.y = 1) +
  geom_jitter(color="grey20", size=.01, alpha= .5) +
  theme_classic() +
  theme(legend.position="none") +
  ylim(0,1.19)  +
  scale_fill_manual(values = c("#BCBEC0", "#D7BFDC", "#B284BE"))
filename = "areaXLPerSpeckleArea_boxplot.pdf"
pdf(filename, width = 2, height = 2, onefile=FALSE)
print(p)
dev.off()

# fraction SON in nucleus periphery
p = ggplot(A, aes(x=wellCode, y=RadialDistribution_FracAtD_SONMasked_4of4, fill=factor(wellCode))) +
  geom_boxplot(col="black", size=1, outlier.size = 0) +
  stat_compare_means(comparisons = my_specific_comparisons, method = "wilcox.test", size = 4, tip.length = 0.015, step.increase = 0.08, label = "p.signif", vjust = .6, hide.ns = T, ) +
  geom_jitter(color="grey20", size=.01, alpha= .5) +
  theme_classic() +
  theme(legend.position="none") +
  ylim(0,NA)  +
  scale_fill_manual(values = c("#BCBEC0", "#D7BFDC", "#B284BE"))
filename = "frac4SON_boxplot.pdf"
pdf(filename, width = 2, height = 2, onefile=FALSE)
print(p)
dev.off()

# p = ggplot(A, aes(x=wellCode, y=RadialDistribution_FracAtD_SONMasked_1of4, fill=factor(wellCode))) +
#   geom_boxplot(col="black", size=1, outlier.size = 0) +
#   stat_compare_means(comparisons = my_specific_comparisons, method = "wilcox.test", size = 4, tip.length = 0.015, step.increase = 0.08, label = "p.signif", vjust = .6, hide.ns = T, ) +
#   geom_jitter(color="grey20", size=.01, alpha= .5) +
#   theme_classic() +
#   theme(legend.position="none") +
#   ylim(0,NA)  +
#   scale_fill_manual(values = c("#BCBEC0", "#D7BFDC", "#B284BE"))
# filename = "frac1SON_boxplot.pdf"
# pdf(filename, width = 2, height = 2, onefile=FALSE)
# print(p)
# dev.off()
# 
# p = ggplot(A, aes(x=wellCode, y=RadialDistribution_FracAtD_SONMasked_2of4, fill=factor(wellCode))) +
#   geom_boxplot(col="black", size=1, outlier.size = 0) +
#   stat_compare_means(comparisons = my_specific_comparisons, method = "wilcox.test", size = 4, tip.length = 0.015, step.increase = 0.08, label = "p.signif", vjust = .6, hide.ns = T, ) +
#   geom_jitter(color="grey20", size=.01, alpha= .5) +
#   theme_classic() +
#   theme(legend.position="none") +
#   ylim(0,NA)  +
#   scale_fill_manual(values = c("#BCBEC0", "#D7BFDC", "#B284BE"))
# filename = "frac2SON_boxplot.pdf"
# pdf(filename, width = 2, height = 2, onefile=FALSE)
# print(p)
# dev.off()
# 
# p = ggplot(A, aes(x=wellCode, y=RadialDistribution_FracAtD_SONMasked_3of4, fill=factor(wellCode))) +
#   geom_boxplot(col="black", size=1, outlier.size = 0) +
#   stat_compare_means(comparisons = my_specific_comparisons, method = "wilcox.test", size = 4, tip.length = 0.015, step.increase = 0.08, label = "p.signif", vjust = .6, hide.ns = T, ) +
#   geom_jitter(color="grey20", size=.01, alpha= .5) +
#   theme_classic() +
#   theme(legend.position="none") +
#   ylim(0,NA)  +
#   scale_fill_manual(values = c("#BCBEC0", "#D7BFDC", "#B284BE"))
# filename = "frac3SON_boxplot.pdf"
# pdf(filename, width = 2, height = 2, onefile=FALSE)
# print(p)
# dev.off()
# 
# 
# 
