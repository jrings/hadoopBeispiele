#!/usr/bin/python

import sys
import os

def read():
    for line in sys.stdin:
        yield line.strip().split()

def main():
    currentNode = None
    currentWeight = 0

    for pp in read():
        nodeId = int(pp[0])
        nodeAdd = float(pp[1])

        if nodeId == currentNode:
            currentWeight += nodeAdd
        else:
            if currentNode:
                print("%i  %8.4g" % (currentNode, currentWeight))
            currentNode = nodeId
            currentWeight = nodeAdd

    if currentNode:
        print("%i  %8.4g" % (currentNode, currentWeight))


if __name__ == '__main__':
    main()
