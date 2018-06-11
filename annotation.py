import sys
import openpyxl as px
from lxml import etree

xmlfile = sys.argv[1]
annotationfile = sys.argv[2]
outputfile = sys.argv[3]

def fetch_cell(sheet):
    s = {}
    for row in sheet:
        s.update({row[0].value:row[1].value})
    return s

# annotation file processing

w = px.load_workbook(annotationfile)
sheet = w['Sheet1']
annotation = fetch_cell(sheet)

# xml file processing

doc = etree.parse(xmlfile)
root = doc.getroot()
reporters = root.getchildren()[0].getchildren()
for reporter in reporters[:-25]:
    if(reporter.attrib['name'] in annotation.keys()):
        gene = reporter.getchildren()[1]
        if("description" in gene.attrib.keys()):
            gene.attrib['description'] = annotation.get(reporter.attrib['name'])

doc.write(outputfile)
