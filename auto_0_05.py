from Bio import SeqIO
import sys,os,re,gzip,shutil

class read_stats:
    count_A = 0
    count_T = 0
    count_G = 0
    count_C = 0
    count_N = 0
    count = 0
    read_count = 0
    sample_number = ''
    sample_name = ''
    def __init__(self,file):
        with gzip.open(file,'rt') as fastq:
            for record in SeqIO.parse(fastq,'fastq'):
                self.count_A += record.seq.count('A')
                self.count_T += record.seq.count('T')
                self.count_G += record.seq.count('G')
                self.count_C += record.seq.count('C')
                self.count_N += record.seq.count('N')
                self.read_count += 1
    def AT_percentage(self):
        return round((self.count_A+self.count_T)/(self.count_A + self.count_T + self.count_G + self.count_C)*100)
    def GC_percentage(self):
        return round((self.count_G + self.count_C)/(self.count_A + self.count_T + self.count_G + self.count_C)*100)
    def total_base_count(self):
        return self.count_A + self.count_C + self.count_G + self.count_T

def check_arg():
    if len(sys.argv) < 2:
        print('Usage: '+sys.argv[0]+' directory name where fastq.gz file reside')
    else:
        return True

def check_folder(x):
    for i in os.listdir(x):
        if not re.match(r'.*\.R[1:2]\.fastq\.gz',i):
            print('Only put fastq.gz file in this directory, remove everything else')
            return False

def extract_dirname():
    dirname = []
    cdf = os.listdir()
    m = re.compile('(SO_...\d).*')
    for i in cdf:
        dirname.append(m.sub(r'\g<1>',i))
    return list(set(dirname))

def make_dir(x):
    for dirname in x:
        os.makedirs(os.path.join(dirname,'FastQC'),exist_ok=True)

def move_file(filenames,dirnames):
    for i in dirnames:
        for j in filenames:
            if(bool(re.match(re.escape(i),j))):
                shutil.move(j,i)

def generate_stats():
    flist = os.listdir()
    dirs = [re.match(r'SO.*',i).group() for i in flist if re.match(r'SO.*',i)]
    for i in dirs:
        os.system('zgrep -P "^@.*\s" -c '+i+'/*.gz > '+i+'/count.csv')   
        os.system('/data/ngs/programs/FastQC/fastqc '+i+'/*.gz -t 8 -o '+i+'/FastQC')
        os.system('touch '+i+'/Sample_Statistics.csv')

if check_arg():
    dirname = sys.argv[1]
    os.chdir(dirname)
    dirs = os.listdir()
    p = re.compile(r'(SO_...\d).*\.gz')
    filename = [re.match(p,i).group() for i in dirs if re.match(p,i)]
    dirname = set([p.sub(r'\g<1>',i) for i in dirs if re.match(p,i)])
    ndir = extract_dirname()
    make_dir(ndir)
    move_file(filename,dirname)
    generate_stats()
    for i in dirname:
        os.chdir(i)
        fl = os.listdir()
        ft = [re.match(r'SO_.*',i).group() for i in fl if re.match(r'SO',i)]
        f = open('Sample_Statistics.csv','a')
        f.write('Table 1: Read Statistic\n\n')
        f.write('Sample Name,File Size,Read Count,Total Nucleotide Count,Count of A,Count of T,Count of G,Count of C,Count of N,AT (%),GC (%)\n')
        for j in ft:
            stats = read_stats(j)
            f.write(str(j)+','+str(os.path.getsize(j))+','+str(stats.read_count)+','+str(stats.total_base_count())+','+str(stats.count_A)+','+ str(stats.count_T)+','+str(stats.count_G)+','+str(stats.count_C)+','+str(stats.count_N)+','+str(stats.AT_percentage())+','+str(stats.GC_percentage())+'\n')
        f.close()
        os.chdir('../')

