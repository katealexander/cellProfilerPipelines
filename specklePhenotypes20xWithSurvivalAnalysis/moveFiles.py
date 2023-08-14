#!/usr/bin/python

import sys, os, re

def main(args):
    if not len(args) == 2: sys.exit("USAGE: python moveFiles.py wellCode")

    f = open(args[1]);
    line = f.readline()[:-1]
    line = f.readline()[:-1]
    while line != "":
        well = line.split("\t")[0]
        startImage = line.split("\t")[13]
        command1 = "mkdir " + well
        os.system(command1)
        for i in range(int(startImage), int(startImage) + 9):
            command2 = "mv *max_" + str(i) + ".tiff " + well
            os.system(command2)
        line = f.readline()[:-1]
    f.close()



if __name__ == "__main__": main(sys.argv)

