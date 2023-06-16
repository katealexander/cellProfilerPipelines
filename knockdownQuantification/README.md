# Knockdown quantification
This pipeline describes how I assessed nuclear intensities at 20x magnification to quantify the knockdown efficiency of ALYREF knockdown. This analysis begins after max projection file generation. 

# Measuring nuclear intensity of signals
The cellProfiler pipeline, "MeasureIntensityNucleus_noCorrelationMeasure.cppipe", takes max projections images as inputs and outputs intensity measurements as well as files showing how nuclei were segmented in the analysis

# Running cell profiler in Terminal
The following shell script runs the cell profiler pipeline. It relies on max projection images being stored in individual folders within another folder (here called "exampleMaxProjections").

```./runCellProfiler.sh```

This script will call to cellProfiler in Terminal and run through the pipeline for each sample folder within "exampleMaxProjections". The resulting images and data will be stored in the folder called "result".

# Combining samples for graphing in R
I used this Python script (in Python 2.7) to combine the intensity files, which will next be used for graphing in R.

```python mergeIntensityFiles.py exampleMaxProjections/result/*/*intensityMeasurementsnuclei.txt > intensityAllSamples.txt```

# Graphing intensity in R
After combining intensity files for the different samples, I graphed the per nucleus intensity distributions of ALYREF, which was in the A647 imaging channel, in R.

```Rscript graphMaking.R```

