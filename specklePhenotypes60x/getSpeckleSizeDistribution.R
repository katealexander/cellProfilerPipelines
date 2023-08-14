setwd("~/Documents/cellProfilerPipelines/specklePhenotypes60x/")
library(dplyr)

speckleData <- read.table("1_NTC/SONspeckles.txt", sep = "\t", header = T)
speckleData$ntile <- ntile(speckleData$AreaShape_Area, 50)

min(speckleData$AreaShape_Area[speckleData$ntile == "50"]) # extra large bigger than this top 2%
min(speckleData$AreaShape_Area[speckleData$ntile == "45"]) # large bigger than this top 10%
min(speckleData$AreaShape_Area[speckleData$ntile == "25"]) # medium bigger than this top 50%

