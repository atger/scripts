from lxml import etree

doc = etree.parse("Human_084822_revised.xml")  
doc.xpath('//reporter') 
rep = doc.xpath('//reporter')
root = doc.getroot()
p = root.xpath('//reporter')
g = [p[i].getchildren()[1] for i in range(0,len(p))]
o = [p[i].getchildren()[2] for i in range(0,len(p))]   
s = [g[i].attrib.get('systematic_name') for i in range(0,len(g))] 
[o[i].set('value',s[i]) for i in range(0,len(o))]
doc.write("output.xml")
