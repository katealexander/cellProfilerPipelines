#!/usr/bin/python

import sys, os, re

def main(args):
    if not len(args) == 2: sys.exit("USAGE: python formatForSurvivalAnalysis.py survivalAndMeasurmentFile > output.txt")

    f = open(args[1]);
    line = f.readline()[:-1] ## header
    header = line.strip()
    header = header + "\tstatus"
    print header
    line = f.readline()[:-1]
    while line != "":
        line = line.strip()
        items = line.split("\t")
        pathology = items[5]
        months = items[12]
        survival = items[10]
        if pathology == "clear cell carcinoma" and months != "":
            if survival == "survival":
                print line + "\t0"
            elif survival == "deceased":
                print line + "\t1"
        line = f.readline()[:-1]
    f.close()



if __name__ == "__main__": main(sys.argv)

