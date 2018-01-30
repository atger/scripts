def extract_sequence(file):
    """ Read fasta file and returns
    sequence in a variable"""
    with open(file) as f:
        rawfile = f.read()
        s = rawfile.split("\n\n")
        seq = [''.join(i.split("\n")[1:]) for i in s]
    return seq

def filter(sequence):
    """Filter sequence based on length"""
    fseq = list()
    for x in sequence:
        if(len(x) >= 300):
            fseq.append(x)
    return fseq

