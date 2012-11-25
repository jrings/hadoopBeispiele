#!/usr/bin/python

import sys

def mapper():
    for line in sys.stdin:
        pp = line.strip().split()
        for p in pp:
            print p, 1

if __name__ == '__main__':
    mapper()
