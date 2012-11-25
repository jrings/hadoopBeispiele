#!/usr/bin/python

import sys

def read():
    for line in sys.stdin:
        yield line.strip().split()

def main():
    dat = open("data_.txt").readlines()
    alpha = float(dat[0].strip())
    sizeGraph = int(dat[1].strip())
    hangingWeight = float(dat[2].strip())
    for pp in read():
        node = pp[0]
        if node>-9999:
            value = float(pp[1])
            newValue = alpha/float(sizeGraph) + (1-alpha) * (value+(hangingWeight/float(sizeGraph)))
            print("%s %8.4g" %(node, newValue))

if __name__ == '__main__':
    main()

