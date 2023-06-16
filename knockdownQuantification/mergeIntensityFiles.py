
## Joins files from HTSeq2 to make a table for DESeq
## Need to enter HTSeq output file into tableList

import re, sys
def main(args):
    if len(args) < 2: sys.exit("USAGE: python mergeIntensityFiles.py exampleMaxProjections/result/*/*intensityMeasurementsnuclei.txt > intensityAllSamples [each intensity file is in it's separate well folder]")

    ## include header for first file
    f = open(args[1])
    line = f.readline()[:-1]
    line = line.strip()
    header = line + "\tWell"
    print header
    line = f.readline()[:-1]
    well = args[1].split("/")[2]
    while line != "":
        line = line.strip()
        print line + "\t" + well
        line = f.readline()[:-1]
    f.close()

    for file in sys.argv[2:]:
        f = open(file)
        line = f.readline()[:-1] #don't print header
        line = f.readline()[:-1]
        well = file.split("/")[2]
        while line != "":
            line = line.strip()
            print line + "\t" + well
            line = f.readline()[:-1]
        f.close()

        
if __name__ == "__main__": main(sys.argv)

