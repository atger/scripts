from optparse import OptionParser

class sample:
    def __init__(self):
        self.base = self.first = self.second = self.third = self.fourth = []
    def read(self,line):
        field = [i.split(',') for i in line.split('\t')]
        self.base = field[:5]
        self.first = field[5:9]
        self.second = field[9:13]
        self.third = field[13:17]
        self.fourth = field[17:21]
    def common(self,fs,ss):
        common = [[],[],[],[]]
        common[0].append(fs[0][0])
        for i in ss[1]:
            if i in fs[1]:
                x = fs[1].index(i)
                common[1].append(fs[1][x])
                common[2].append(fs[2][x])
                common[3].append(fs[3][x])
        return common
    def remove(self,fs,c):
        for i in c[1]:
            if i in fs[1]:
                x = fs[1].index(i)
                fs[1].remove(i)
                fs[2].remove(fs[2][x])
                fs[3].remove(fs[3][x])
    def clear(self):
        self.base = self.first = self.second = self.third = self.fourth = []



def remove(fs,c):
    d = [[],[],[],[]]
    for i in c[1]:
        if i in fs[1]:
            d[0].append(fs[0][0])
            x = fs[1].index(i)
            d[1].append(fs[1][x])
            d[2].append(fs[2][x])
            d[3].append(fs[3][x])
            return d


def execute_3sample(filename):
    s = sample()
    with open(filename) as f:
        for line in f:
            s.read(line)
            c = s.common(s.first,s.second)
            s.remove(s.first,c)
            s.remove(s.second,c)
            s.remove(s.third,c)
            sk = [s.base,s.first,s.second,s.third]
            sk = [i for j in sk for i in j]
            [i.append('-') for i in sk if len(i) == 0]
            l = [''.join(i) for i in sk]
            print('\t'.join(l))

def execute_4sample(filename):
    s = sample()
    with open(filename) as f:
        for line in f:
            s.read(line)
            c = s.common(s.first,s.second)
            s.remove(s.first,c)
            s.remove(s.second,c)
            s.remove(s.third,c)
            s.remove(s.fourth,c)
            sk = [s.base,s.first,s.second,s.third,s.fourth]
            sk = [i for j in sk for i in j]
            [i.append('-') for i in sk if len(i) == 0]
            l = [''.join(i) for i in sk]
            print('\t'.join(l))




def main():
    parser = OptionParser(usage="usage: %prog [-s sample_count] filename",
                          version="%prog 1.0")
    parser.add_option("-s", "--sample",
                      dest="sample",
                      help="process number of sample")
    (options, args) = parser.parse_args()

    if len(args) != 1:
        parser.error("wrong number of arguments")

    if int(options.sample) == 3:
        execute_3sample(args[0])
    elif int(options.sample) == 4:
        execute_4sample(args[0])

if __name__ == '__main__':
    main()

