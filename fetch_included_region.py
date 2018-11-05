# match column and merge file

import sys

if len(sys.argv) < 3:
    print(argv[0]+" <file1> <file2>")

df = []
with open(sys.argv[1]) as f:
    for i in f: 
        df.append(i.strip().split("\t"))



ds = []
with open(sys.argv[2]) as f:
    for i in f:
        ds.append(i.strip().split("\t"))



for i in df:
    gene = set()
    for j in ds:
        if i[0] == j[0] and int(i[1])>=int(j[1]) and int(i[1])<=int(j[2]):
            gene.add(j[3])
    result = [a for b in [i,[','.join(gene)]] for a in b]
    print("\t".join(result))
