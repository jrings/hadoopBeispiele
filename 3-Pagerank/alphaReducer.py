#!/usr/bin/python

import sys

def read():
    for line in sys.stdin:
        yield line

def main():
    for line in read():
        if line.strip().split()[0] != '-9999':
            print line.strip()

if __name__ == '__main__':
    main()
