# Speckle phenotypes at 60x
This pipeline describes how I assessed speckle phenotypes in 60x imaging data with non-targeting control (NTC) or ALYREF knockdown. Because I wanted to be sure to get accurate radial distribution measurements of speckles, I manually checked the nuclei segmentation and made adjustments for nuclei where the outlines were inaccurate. For this reason, this pipeline must be run in the cellProfiler GUI.

# cellProfiler pipelines
The cellProfiler projects "speckleAnalysisOneChannel_1.0" segment nuclei and speckles of the respective max projections and output image files showing how nuclei and speckles were called. Here nuclei are in the "DAPI" channel and speckles are in the "YFP" channel. The image files will output into the default cellProfiler folder, and will need to be moved to their respective folders. 

# Post processing
I used Python 2.7 to calculate per-nucleus speckle measurments. This included setting speckle size bins and assessing the area/nucleus of different speckle sizes.

```for dir in *_*; do python addSpeckleDetailsToNuclei.py $dir > $dir/$dir"_nuclei_withAddedSpeckleInfo.txt"; done```

Then I concatenated the different samples:

```python catNucleiData.py 1_NTC 2_ALYkd5 3_ALYkd8 > nucleiData_subset.txt```

This creates a file ready for making graphs in R. Here, I included the subset of test data, called "nucleiData_subset.txt", as well as the full dataset, called "nucleiData.txt"

# Graph in R
The following R script takes the speckle measurements of interest and graphs boxplots where each dot is a nuclei and each box is a different condition.

```Rscript specklePlots.R```

The above script will output:
- areaNonXLPerSpeckleArea_boxplot.pdf - the area of non extra large speckles per total speckle area
- areaXLPerSpeckleArea_boxplot.pdf - the area of extra large speckles per total speckle area
- frac4SON_boxplot.pdf - the fraction of SON signal in the nuclear periphery
- numSpecklesPerNucleus_boxplot.pdf - the number of speckles per nucleus
- speckleAreaPerNucleus_boxplot.pdf - the fraction of the nuclear area occupied by speckles


