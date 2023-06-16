import re, sys
def main(args):
    if len(args) < 2: sys.exit("USAGE: python catNucleiData.py wellNames > outfile")
    
    resultsDir = "/Users/kaalexa/Documents/cellProfilerPipelines/specklePhenotypes60x"
    wells = args[1:]
    
    well = wells[0]
    fileName = resultsDir + "/" + well + "/" + well + "_nuclei_withAddedSpeckleInfo.txt"
    toAdd = "1_" + well
    f = open(fileName)
    line = f.readline()[:-1]
    line = line.strip()
    print line + "\twellCode"
    line = f.readline()[:-1]
    while line != "":
        line = line.strip()
        print line + "\t" + toAdd
        line = f.readline()[:-1]
    f.close()
    
    n = 2
    for well in wells[1:]:
        fileName = resultsDir + "/" + well + "/" + well + "_nuclei_withAddedSpeckleInfo.txt"
        toAdd = str(n) + "_" + well
        f = open(fileName)
        line = f.readline()[:-1]
        line = f.readline()[:-1]
        while line != "":
            line = line.strip()
            print line + "\t" + toAdd
            line = f.readline()[:-1]
        f.close()
        n += 1

if __name__ == "__main__": main(sys.argv)


