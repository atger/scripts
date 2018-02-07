from urllib.request import urlopen
from lxml import etree

idlist = []
with open("now.txt") as f:
    idis = f.read()
    idlist = idis.split('\n')

for ids in idlist:
    page = urlopen("https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=Taxonomy&id="+str(ids)+"&rettype=fasta&retmode=xml")
    xml = page.read()
    root = etree.fromstring(xml)
    taxon = root.getchildren()[0]
    TaxId = taxon.xpath('TaxId')[0].text
    ScientificName = taxon.xpath('ScientificName')[0].text
    kingdom = ''.join([i.getchildren()[1].text for i in taxon.xpath('LineageEx/Taxon') if i.getchildren()[2].text == "kingdom"])
    phylum = ''.join([i.getchildren()[1].text for i in taxon.xpath('LineageEx/Taxon') if i.getchildren()[2].text == "phylum"])
    clas = ''.join([i.getchildren()[1].text for i in taxon.xpath('LineageEx/Taxon') if i.getchildren()[2].text == "class"])
    order = ''.join([i.getchildren()[1].text for i in taxon.xpath('LineageEx/Taxon') if i.getchildren()[2].text == "order"])
    family = ''.join([i.getchildren()[1].text for i in taxon.xpath('LineageEx/Taxon') if i.getchildren()[2].text == "family"])
    genus = ''.join([i.getchildren()[1].text for i in taxon.xpath('LineageEx/Taxon') if i.getchildren()[2].text == "genus"])
    superkingdom = ''.join([i.getchildren()[1].text for i in taxon.xpath('LineageEx/Taxon') if i.getchildren()[2].text == "superkingdom"])
#    cname = taxon.xpath('OtherNames/GenbankCommonName')[0].text
    rows = [TaxId,ScientificName,superkingdom,kingdom,phylum,clas,order,family,genus]
    print('\t'.join(rows))
