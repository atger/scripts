## script for serching uniprot
## run as : python search.py

import urllib,urllib2
url = 'http://www.uniprot.org/uniprot/'

# query building
sep = '+AND+'
term = 'cancer'
status = 'reviewed:no'
organism = 'organism:9606'
query = organism+sep+term+sep+status
print query

# encode in url
params = {
    'query':query,
    'format':'fasta',
    'columns':'sequence,reviewed',
    'include':'yes',
    'compress':'yes',
    }
data = urllib.urlencode(params)
request = urllib2.Request(url,data)
response = urllib2.urlopen(request)

# writing output to file named sequence.fa.gz
f = open("sequence.fa.gz","w")
f.write(response.read())
f.close()
