from functions import *
import config
import shutil

try:
  shutil.rmtree(config.outputFolder)
except Exception,e:
  pass

def saveTaxonomies():
  taxonomy = saveResource("taxonomy_vocabulary")
  for vocabulary in taxonomy:
    d = {
      "vid":vocabulary["vid"],
      "key":"vid"
      }
    term = saveResource("taxonomy_vocabulary/getTree", d)


def saveNodes():
  nodes = saveResource("node.json?pagesize=10000")
  for node in nodes:
    d = saveResource("node" + "/" + node["nid"])

saveTaxonomies()
saveNodes()
