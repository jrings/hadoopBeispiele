#!/usr/bin/python

import sys

def read():
    for line in sys.stdin:
        yield line.strip().split()

def main():
    for pp in read():
        nodeId = int(pp[0])
        nodeValue = float(pp[1])
        nodeAdjaList = [int(p) for p in pp[2:]]

        print("%i 0"% nodeId)

        if len(nodeAdjaList)>0:
            wD = nodeValue/float(len(nodeAdjaList))
            for idn in nodeAdjaList:
                print("%i  %8.4g" % (idn, wD))
        else:
            print("-9999 %8.4g" % nodeValue)

if __name__ == '__main__':
    main()
