source activate mypython3
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-19.0.1.jdk/Contents/Home
#start at master foler (like maxp folder).note file list will have to contain absolute path.
#change arguments here Cellprofiler.sh $maxpHomeDir $resultHomeDir $pipeline
maxpHome=$(echo "/Users/kaalexa/Documents/cellProfilerPipelines/knockdownQuantification/exampleMaxProjections")
resultHome=$(echo "/Users/kaalexa/Documents/cellProfilerPipelines/knockdownQuantification/exampleMaxProjections/result")
pipe=$(echo "/Users/kaalexa/Documents/cellProfilerPipelines/knockdownQuantification/MeasureIntensityNucleus_noCorrelationMeasure.cppipe")
cd "$maxpHome"
for d in */
  do
  name=$(basename $d)
  echo $name
  echo "$resultHome"/"$d"
  cd $d
  #create a file list
  realpath *.tiff > file_list.txt
  #run
  #/Applications/CellProfiler.app/Contents/MacOS/cp -c -r -p $pipe -i "$maxpHome"/"$d" -o "$resultHome"/"$d" --file-list=./file_list.txt --conserve-memory=true
  /Applications/CellProfiler.app/Contents/MacOS/cp -c -r -p $pipe -i "$maxpHome"/"$d" -o "$resultHome"/"$d" --file-list=./file_list.txt
  #change filename for post processing
  cd "$resultHome"/"$d"
    for f in *.txt
    do
    mv "$f" "$name"_"$f"
    done
  cd "$maxpHome"
done

conda deactivate
