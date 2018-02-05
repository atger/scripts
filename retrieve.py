from lxml import etree

# parse file in etree structure
doc = etree.parse("LOCATE_mouse_v6_20081121.xml")
root = doc.getroot()

# get root element in l
l = root.xpath('LOCATE_protein')

# extract protein function element with value secretome
ls = [i for i in l if i.getchildren()[0].getchildren()[1].text == 'secretome']

# create new file
f = open("fileout","w")

# extract accid for protein element with mgi_symbol
for x in ls:
    ps = x.getchildren()[0].getchildren()[2].text
    xs = x.xpath('xrefs/xref/source')
    acc = [i.getchildren()[1].text for i in xs if i.getchildren()[0].text == 'MGI Symbol']
    acc.append(ps)
    f.write(str(acc)+"\n")
