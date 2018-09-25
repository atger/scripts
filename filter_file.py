import sys

def filter_5(ef):
    sf = [i.split(',') for i in ef]
    ix = []                          
    for i in range(0,len(sf[1])):
        if sf[1][i] != 'NA':
            if int(sf[1][i]) > 5:
                ix.append(i)
    fg = [[],[],[]]
    for i in ix:
        fg[0].append(sf[0][i])
        fg[1].append(sf[1][i])
        fg[2].append(sf[2][i])
    return [','.join(i) for i in fg]

def apply_filter(ef):
    fl = [ef[0:6],filter_5(ef[6:9]),ef[9],filter_5(ef[10:13]),ef[13],filter_5(ef[14:17])]
    return [i for j in fl for i in j]

with open(sys.argv[1]) as f:
    for line in f:
        print('\t'.join(apply_filter(line.split('\t'))))
