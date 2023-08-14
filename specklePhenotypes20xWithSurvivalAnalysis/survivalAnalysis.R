library(dplyr)
library(survival)
library(survminer)
library(stringr)

S <- read.table("~/Documents/cellProfilerPipelines/specklePhenotypes20xWithSurvivalAnalysis/formatedSurvivalAndMeasurments.txt", sep="\t", header=T)
S <- as.data.frame(S)
setwd("~/Documents/cellProfilerPipelines/specklePhenotypes20xWithSurvivalAnalysis")


#make a list of columns to loop through
var_list = names(S)[15:338]

# create a directory for the plots 
if (!dir.exists("survival")){
  dir.create("survival")
}

#make survival plots splitting into top and bottom 50% of data for each variable
for (i in 1:length(var_list)) {
  if (str_detect(pattern = "A647", string = var_list[i])){
    S[[var_list[i]]] <- as.numeric(S[[var_list[i]]])
    newColName = paste(var_list[i], "_ntile", sep="")
    S$newColName <- as.factor(ntile(S[[var_list[i]]], 2))
    sfit <- survfit(Surv(survival.months, status)~newColName, data = S)
    p = ggsurvplot(sfit, conf.int=TRUE, pval=TRUE, legend.labs=c("1", "2"), legend.title=var_list[i],  palette = c("darkorchid4", "darkslategray3"))
    
    
    file_name = paste("survival/topBottomHalves_", var_list[i], ".pdf", sep="")
    pdf(file_name, width = 5, height = 5, onefile=FALSE)
    print(p)
    dev.off()
  }
}

## testing survival effects of radial distribution of SON signal in just the early grade ccRCC (G1 or G1-G2 -- there are 40 of these)
S$RadialDistribution_FracAtD_CorrectedA647_1of4_ntile <- as.factor(ntile(S$RadialDistribution_FracAtD_CorrectedA647_1of4, 2))
k <- S[(S$Grade == "G1" | S$Grade == "G1-G2" | S$Grade == "G2"),]
kfit <- survfit(Surv(survival.months, status)~RadialDistribution_FracAtD_CorrectedA647_1of4_ntile, data = k)
file_name = paste("survival/1_G1andG2_RadialDistribution_FracAtD_CorrectedA647_1of4_ntile", ".pdf", sep="")
pdf(file_name, width = 5, height = 5, onefile=FALSE)
p = ggsurvplot(kfit, conf.int=TRUE, pval=TRUE, legend.labs=c("1", "2"), legend.title="RadialDistribution_FracAtD_CorrectedA647_1of4",  palette = c("darkorchid4", "darkslategray3"))
print(p)
dev.off()

S$RadialDistribution_FracAtD_CorrectedA647_4of4_ntile <- as.factor(ntile(S$RadialDistribution_FracAtD_CorrectedA647_4of4, 2))
k <- S[(S$Grade == "G1" | S$Grade == "G1-G2" | S$Grade == "G2"),]
kfit <- survfit(Surv(survival.months, status)~RadialDistribution_FracAtD_CorrectedA647_4of4_ntile, data = k)
file_name = paste("survival/1_G1andG1G2_RadialDistribution_FracAtD_CorrectedA647_1of4_ntile", ".pdf", sep="")
pdf(file_name, width = 5, height = 5, onefile=FALSE)
p = ggsurvplot(kfit, conf.int=TRUE, pval=TRUE, legend.labs=c("1", "2"), legend.title="RadialDistribution_FracAtD_CorrectedA647_4of4",  palette = c("darkorchid4", "darkslategray3"))
print(p)
dev.off()

