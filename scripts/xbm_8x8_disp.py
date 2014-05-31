#!/usr/bin/python

import sys

try:
    path = sys.argv[1]
    fp = open(path)
except:
    print("Whoops")
    exit()

width = fp.readline()
height = fp.readline()
name = fp.readline()
img = fp.readline().rstrip(" };\n").split(',')
print(" ")
for hex in img:
    h = int(hex.lstrip(), 16)
    print(" {0:08b} ".format(h).replace('1','██').replace('0','  '))
print(" ")
