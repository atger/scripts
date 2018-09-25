#!/usr/bin/env python3
# fetch sequences from fasta file according to regular expression


import re
import sys
from Bio import SeqIO


if len(sys.argv) < 3:
    print("Usage: ./fetch.py <filename> <regular expression>")
else:
    for record in SeqIO.parse(sys.argv[1],"fasta"):
        if re.match(sys.argv[2],record.id):
            print(record.id)
            print(record.seq)
