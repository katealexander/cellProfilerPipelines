#!/usr/bin/python

## this needs to be run from folder above the "results" cell profiler folder (the folder with all the max projection subfolders for each well)

import sys, re, numpy as np

def main(args):
    if len(args) != 2: sys.exit("USAGE: python addMediansToWellCodes.py wellCodes > outFile.txt")
    
    index = 0
    wellsToExlude = ["G5", "F7", "F17", "B1"]

    ## Go through each line of well codes, make the well the key, and make values a list of well info + medians from CellProfiler output
    f = open(args[1])
    line = f.readline()[:-1]
    header = line.strip()
    headerList = header.split("\t")
    line = f.readline()[:-1]
    gHead = False
    while line != "":
        line = line.strip()
        items = line.split("\t")
        wellDict = {}
        well = items[0]
        if well in wellsToExlude:
            line = f.readline()[:-1]
            continue
        wellDict[well] = items[1:]
        intensityFileName = "result/" + well + "/" + well + "_intensityMeasurementsnuclei.txt"
        g = open("result/" + well + "/" + well + "_intensityMeasurementsnuclei.txt")
        gline = g.readline()[:-1]
        if not gHead: ## add to header only on the first well
            gheader = gline.strip()
            headerList = headerList + gheader.split("\t")[2:] ## starts at 2 to exlude image number and object number, because doesn't make sense to get medians of these
            gline = g.readline()[:-1]
            gHead = True
            print "\t".join(headerList)
        else:
            gline = g.readline()[:-1]
        measurementLists = [] #list of lists for all the measurements
        i = 0
        while gline != "":
            gline = gline.strip()
            items = gline.split("\t")[2:]
            j = 0
            for item in items:
                if i == 0:
                    measurementLists.append([float(item)])
                else:
                    measurementLists[j].append(float(item))
                j += 1
            i += 1
            gline = g.readline()[:-1]
        g.close()
        for measurement in measurementLists: ## calculate medians and add to well dictionary
            M = np.array(measurement)
            median = np.median(M)
            wellDict[well].append(str(median))
        print well + "\t" + "\t".join(wellDict[well])
        line = f.readline()[:-1]
    f.close()
    
        

    
    
if __name__ == "__main__": main(sys.argv)

