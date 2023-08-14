# Speckle phenotypes with survival analysis

# Getting speckle measurments
Because this dataset was at 20x, speckle objects were not called, but rather intensity measurments of the SON speckle marker was used to evaluate speckle phenotypes. In this pipeline, the correlation measurments in cellProfiler take the most time. Hence this could be removed from the analysis to speed things up.

From an ND2 file containing the 20x imaging data of every tissue sample (thought of as a "well" in image analysis), I used CellProfiler to generate maximum projections. From here, the well image start number was recorded for each sample, and imaging files were sorting according to array position using the script: ```python moveWells.py wellCodes```

After sorting images into subdirectories, I ran the cellProfiler pipeline in terminal:

```./runCellProfilerX.sh A```

This shell script loops through all the wells that begin with "A" and runs the cellProfiler pipeline "MeasureIntensityNucleus.cppipe". I ran this shell script for A-J in parallel, which took 4 days to complete a total of ~180 wells (it would be much faster if correlation measurments were removed).

# Getting median measurments
Upon completion of the cellProfiler pipeline, each well gets a file that contains intensity measurments for SON in every nucleus detected from that sample. To get per-sample measurments, I calculated the median value of each measurment per sample using the following Python script:

```python addMediansToWellCodes.py wellCodes > survivalAndMeasurements.txt```

The wellCodes text file here also contains survival data for each ccRCC tumor sample.

# Calculating survival
To calculate survival for each measurment, I first formated the data, adding a status column of 0 or 1 for whether the individual was alive or deceased.

```python formatForSurvivalAnalysis.py survivalAndMeasurements.txt > formatedSurvivalAndMeasurments.txt```

I then loaded this file into R and calculated survival statistics by splitting each variable into the top and bottom 50%. 

```Rscript survivalAnalysis.R```

The above Rscript outputs the "survival" directory with Kaplan Meier curves for each variable.

# Assessing differences in normal adjacent tissue versus tumor or based on tumor grade
The tissue array I used had tumor grade information as well as matched normal adjacent tissue. In the following Rscript, I use this information to compare ccRCC tumor to normal, and to assess changes with tumor grade.

```Rscript ccRCCvsNormal_makeGraphs.R```

The above script generates files for SON radial distribution, called "grade_RadialDistribution_FracAtD_CorrectedA647_1of4.pdf" and "grade_radialDistribution_FracAtD_CorrectedA647_4of4.pdf", as well as a folder of tumor versus normal (called "NAT") for all measurements made.

