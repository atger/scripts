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
    gene = []
    for j in ds:
        if i[0] == j[0] and i[1]>=j[1] and i[1]<=j[2]:
            if j[3] not in gene:
                gene.append(j[3])
    result = [a for b in [i,[','.join(gene)]] for a in b]
    print("\t".join(result))
