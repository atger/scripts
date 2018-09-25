#  Work on file structure :
# chr position reference sample_al sample_freq .. ..
# column 1-3 and last 9 columns are excluded while processing

import sys
import re


def addcolumn(z):
    freq=last=[]
    basecount = {}
    count = 0
    for i in range(3,len(z)-9,2):
        if z[i] != "NA":
            count += 1
            for j in z[i].split(","):
                if j in basecount:
                    basecount[j] += 1
                else:
                    basecount[j] = 1
    for key,value in basecount.items():
        last.append(str(key)+"="+str(round(value/float(sum(basecount.values()))*100,2)))
    freq = ','.join(last)
    result = [z[0:3],[str(count),freq],z[3:len(z)]]
    result = [i for j in result for i in j]
    return result


# add chromosome sizes
def add_size(line,fs):
    if line[0] in fs.keys():
        result = [[line[0],fs.get(line[0])],line[1:len(line)]]
        result = [i for j in result for i in j]
        return result
    else:
        return []



def removezero(d):
    dl = []
    for i in d:
        if re.match(r'.\(0\)',i):
            dl.append(re.sub(r'.\(0\),',"",i))
        else:
            dl.append(i)
    return dl

if __name__ == "__main__":

    fs = {}
    with open("sizes") as f:
        for i in f:
            a = i.strip().split("\t")
            fs[a[0]] = a[1]

    with open(sys.argv[1]) as f:
        head = f.readline().strip().split("\t")
        headlast = [re.sub("_sorted.mpileup_filtered_RC_PARSED.txt","",i) for i in head[3:]]
        header = [[head[0],"size",head[1],head[2],"sample_count","allele_freq"],headlast]
        header = [i for j in header for i in j]
        print("\t".join(header))
        for i in f:
            l = removezero(i.strip().split("\t"))
            lc = addcolumn(l)
            lcs = add_size(lc,fs)
            print("\t".join(lcs))

