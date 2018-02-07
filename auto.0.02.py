import os
import re
import sys
import shutil

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
    m = re.compile('(.*)\.R[1:2]\.fastq\.gz')
    for i in cdf:
        dirname.append(m.sub(r'\g<1>',i))
    return list(set(dirname))

def make_dir(x):
    os.chdir('../')
    for dirname in x:
        os.makedirs(os.path.join(dirname,'fastqc'),exist_ok=True)

def move_file(filenames,dirnames):
    for i in dirnames:
        for j in filenames:
            if(bool(re.match(re.escape(i),j))):
                shutil.copy(j,'../'+i)

if check_arg():
    dirname = sys.argv[1]
    os.chdir(dirname)
    cdf = os.listdir()
    ndir = extract_dirname()
    make_dir(ndir)
    os.chdir(dirname)
    move_file(cdf,ndir)

