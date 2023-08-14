#!/usr/bin/python



import sys, os, re, math

def main(args):
    if len(args) != 2: sys.exit("USAGE: python addSpeckleDetailsToNuclei.py wellName > outFile")
    
    wellName = args[1]
    
    ## cutoffs for speckle sizes; adjust based on calculated speckle size distributions
    small = 33
    medium = 174
    large = 441
    
    ## file locations and names
    resultsLocation = "/Users/kaalexa/Documents/cellProfilerPipelines/specklePhenotypes60x/"
    nucleiFileName = resultsLocation + wellName + "/" + "nuclei.txt"
    speckleFileName = resultsLocation + wellName + "/" + "SONspeckles.txt"
    
    ## getting indexes of variables of interest
    n = open(nucleiFileName)
    nheader = n.readline()[:-1]
    nheader = nheader.strip()
    nItems = nheader.split("\t")
    nXindex = nItems.index("Location_Center_X")
    nYindex = nItems.index("Location_Center_Y")
    nAreaIndex = nItems.index("AreaShape_Area")
    nNumSpecklesIndex = nItems.index("Children_SONspeckles_Count")
    nheader = nheader + "\tnumSpeckles\ttotalSpeckleArea\tnumSmallSpeckles\tnumMediumSpeckles\tnumLargeSpeckles\tnumExtraLargeSpeckles\tareaSmallSpeckles\tareaMediumSpeckles\tareaLargeSpeckles\tareaExtraLargeSpeckles\tareaLargestSpeckle\tareaMediumSpecklePerNucleusArea\tareaLargeSpecklePerNucleusArea\tareaExtraLargeSpecklePerNucleusARea\tareaLargestSpecklePerNucleusArea\tareaMediumSpecklePerSpeckleArea\tareaLargeSpecklePerSpeckleArea\tareaExtraLargeSpecklePerSpeckleArea\tareaLargestSpecklePerSpeckleArea"
    print nheader

    s = open(speckleFileName)
    sheader = s.readline()[:-1]
    sheader = sheader.strip()
    sItems = sheader.split("\t")
    sXindex = sItems.index("Location_Center_X")
    sYindex = sItems.index("Location_Center_Y")
    sAreaIndex = sItems.index("AreaShape_Area")
    
    nline = n.readline()[:-1]
    nline = nline.strip()
    sline = s.readline()[:-1]
    sline = sline.strip()
    ndict = {} # nuclei dict will get refreshed for every image. Object number will be the key. Value will be a list with [x, y, "line", [areaSpeckle1, areaSpeckle2]]
    Nimage = 1
    while nline != "":
        currentImage = int(nline.split("\t")[0])
        if currentImage == Nimage: # add to the dictionary of the image
            if nline.split("\t")[nNumSpecklesIndex] == "0":
                nline = n.readline()[:-1]
                nline = nline.strip()
                continue
            objectID = nline.split("\t")[1]
            nX = float(nline.split("\t")[nXindex])
            nY = float(nline.split("\t")[nYindex])
            ndict[objectID] = [nX, nY, nline, []]
        else: # nucleus dict for Nimage is complete, assign speckles to nuclei
            sImage = int(sline.split("\t")[0])
            while sImage == Nimage:
                sX = float(sline.split("\t")[sXindex])
                sY = float(sline.split("\t")[sYindex])
                sArea = int(sline.split("\t")[sAreaIndex])
                ## find closes nucleus
                shortestDist = 9999999999
                for nucleus in ndict.keys():
                    nX= ndict[nucleus][0]
                    nY = ndict[nucleus][1]
                    dist = math.sqrt((nX - sX)**2 + (nY - sY)**2) #calculate distance
                    if float(shortestDist) > dist:
                        closest = nucleus
                        shortestDist = dist
                ## add speckle area to closest nucleus
                ndict[closest][3].append(sArea)
                sline = s.readline()[:-1]
                sline = sline.strip()
                sImage = int(sline.split("\t")[0])
            ## now we're done adding speckles to the nuclei, time for some speckle calculations and printing of nuclei
            for nucleus in ndict.keys():
                if ndict[nucleus][3] != [] and len(ndict[nucleus][3]) >= 5:
                    nArea = float(ndict[nucleus][2].split("\t")[nAreaIndex])
                    nSpeckles = len(ndict[nucleus][3])
                    totalSpeckleArea = sum(ndict[nucleus][3])
                    nSspeckles = len([i for i in ndict[nucleus][3] if i <= small])
                    nMspeckles = len([i for i in ndict[nucleus][3] if small < i <= medium])
                    nLspeckles = len([i for i in ndict[nucleus][3] if medium < i <= large])
                    nXLspeckles = len([i for i in ndict[nucleus][3] if i > large])
                    aSspeckles = sum([i for i in ndict[nucleus][3] if i <= small])
                    aMspeckles = sum([i for i in ndict[nucleus][3] if small < i <= medium])
                    aLspeckles = sum([i for i in ndict[nucleus][3] if medium < i <= large])
                    aXLspeckles = sum([i for i in ndict[nucleus][3] if i > large])
                    sizeLargest = max(ndict[nucleus][3])
                    medPerNuc = float(aMspeckles)/nArea
                    lPerNuc = float(aLspeckles)/nArea
                    xlPerNuc = float(aXLspeckles)/nArea
                    largestPerNuc = float(sizeLargest)/nArea
                    medPerSpeckleA = float(aMspeckles)/float(totalSpeckleArea)
                    lPerSpeckleA = float(aLspeckles)/float(totalSpeckleArea)
                    xlPerSpeckleA = float(aXLspeckles)/float(totalSpeckleArea)
                    largestPerSpeckleA = float(sizeLargest)/float(totalSpeckleArea)
                    print ndict[nucleus][2] + "\t" + str(nSpeckles) + "\t" + str(totalSpeckleArea) + "\t" + str(nSspeckles) + "\t" + str(nMspeckles) + "\t" + str(nLspeckles) + "\t" + str(nXLspeckles) + "\t" + str(aSspeckles) + "\t" + str(aMspeckles) + "\t" + str(aLspeckles) + "\t" + str(aXLspeckles) + "\t" + str(sizeLargest) + "\t" + str(medPerNuc) + "\t" + str(lPerNuc) + "\t" + str(xlPerNuc) + "\t" + str(largestPerNuc) + "\t" + str(medPerSpeckleA) + "\t" + str(lPerSpeckleA) + "\t" + str(xlPerSpeckleA) + "\t" + str(largestPerSpeckleA)
            ndict = {} #new nucleus dictionary for the next image
            if nline.split("\t")[nNumSpecklesIndex] == "0":
                nline = n.readline()[:-1]
                nline = nline.strip()
                continue
            objectID = nline.split("\t")[1]
            nX = float(nline.split("\t")[nXindex])
            nY = float(nline.split("\t")[nYindex])
            ndict[objectID] = [nX, nY, nline, []]
            Nimage += 1
        nline = n.readline()[:-1]
        nline = nline.strip()
    n.close()
    
    ## after everything is done, process speckles for final image
    while sline != "":
        sX = float(sline.split("\t")[sXindex])
        sY = float(sline.split("\t")[sYindex])
        sArea = int(sline.split("\t")[sAreaIndex])
        ## find closes nucleus
        shortestDist = 9999999999
        for nucleus in ndict.keys():
            nX= ndict[nucleus][0]
            nY = ndict[nucleus][1]
            dist = math.sqrt((nX - sX)**2 + (nY - sY)**2) #calculate distance
            if float(shortestDist) > dist:
                closest = nucleus
                shortestDist = dist
        ## add speckle area to closest nucleus
        ndict[closest][3].append(sArea)
        sline = s.readline()[:-1]
        sline = sline.strip()
    s.close()
    
    for nucleus in ndict.keys():
        if ndict[nucleus][3] != [] and len(ndict[nucleus][3]) >= 5:
            nArea = float(ndict[nucleus][2].split("\t")[nAreaIndex])
            nSpeckles = len(ndict[nucleus][3])
            totalSpeckleArea = sum(ndict[nucleus][3])
            nSspeckles = len([i for i in ndict[nucleus][3] if i <= 100])
            nMspeckles = len([i for i in ndict[nucleus][3] if 101 < i <= 200])
            nLspeckles = len([i for i in ndict[nucleus][3] if 201 < i <= 300])
            nXLspeckles = len([i for i in ndict[nucleus][3] if i > 300])
            aSspeckles = sum([i for i in ndict[nucleus][3] if i <= 100])
            aMspeckles = sum([i for i in ndict[nucleus][3] if 101 < i <= 200])
            aLspeckles = sum([i for i in ndict[nucleus][3] if 201 < i <= 300])
            aXLspeckles = sum([i for i in ndict[nucleus][3] if i > 300])
            sizeLargest = max(ndict[nucleus][3])
            medPerNuc = float(aMspeckles)/nArea
            lPerNuc = float(aLspeckles)/nArea
            xlPerNuc = float(aXLspeckles)/nArea
            largestPerNuc = float(sizeLargest)/nArea
            medPerSpeckleA = float(aMspeckles)/float(totalSpeckleArea)
            lPerSpeckleA = float(aLspeckles)/float(totalSpeckleArea)
            xlPerSpeckleA = float(aXLspeckles)/float(totalSpeckleArea)
            largestPerSpeckleA = float(sizeLargest)/float(totalSpeckleArea)
            print ndict[nucleus][2] + "\t" + str(nSpeckles) + "\t" + str(totalSpeckleArea) + "\t" + str(nSspeckles) + "\t" + str(nMspeckles) + "\t" + str(nLspeckles) + "\t" + str(nXLspeckles) + "\t" + str(aSspeckles) + "\t" + str(aMspeckles) + "\t" + str(aLspeckles) + "\t" + str(aXLspeckles) + "\t" + str(sizeLargest) + "\t" + str(medPerNuc) + "\t" + str(lPerNuc) + "\t" + str(xlPerNuc) + "\t" + str(largestPerNuc) + "\t" + str(medPerSpeckleA) + "\t" + str(lPerSpeckleA) + "\t" + str(xlPerSpeckleA) + "\t" + str(largestPerSpeckleA)
if __name__ == "__main__": main(sys.argv)
