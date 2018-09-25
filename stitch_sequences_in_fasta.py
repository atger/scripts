import sys
from Bio import SeqIO

# enter filename and number of sequences after stitching

if len(sys.argv) < 3:
    print("Usage: python stich.py <filename> <number>")
else:
    df = []
    for record in SeqIO.parse(sys.argv[1], "fasta"):
        df.append(str(record.seq))
    div = int(sys.argv[2])
    skip = len(df)/div + 1 
    lm = []
    count = 1
    for i in range(0,len(df),skip):
        lm.append([">chr"+str(count),df[i:i+9991]])
        count+=1
    for i in lm:
        print(i[0])
        print("".join(i[1]))
