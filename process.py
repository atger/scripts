# processing xml file

# First xml file is uploaded as tree from etree.parse command 
# and then using xpath attribute is copied from one element to other element attribute.

from lxml import etree
# load xml file
doc = etree.parse("Human_084822_revised.xml")  
root = doc.getroot()

# fetch reporter element
p = root.xpath('//reporter')

# fetch reporter children element
g = [p[i].getchildren()[1] for i in range(0,len(p))]
o = [p[i].getchildren()[2] for i in range(0,len(p))]

# extracting attribute value
s = [g[i].attrib.get('systematic_name') for i in range(0,len(g))] 

# copying attribute value to another element attribute
[o[i].set('value',s[i]) for i in range(0,len(o))]

# writing modified xml to file
doc.write("output.xml")
