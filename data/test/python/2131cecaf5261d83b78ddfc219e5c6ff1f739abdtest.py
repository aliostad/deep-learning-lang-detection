"""
Needs to be run with python2.5 (because django is installed only on that version, because of google app engine compatibility).
"""

#
# @tag hack: transform path as if the website was a python module
#

import sys
sys.path.append('../..')

#

def test_manage_webentries():
  import manage_webentries
  manage_webentries.getWebEntries()
  manage_webentries.getWebEntriesAsDictOfCategories()
  dTagsEntries = manage_webentries.getWebEntriesAsDictOfTags()
  dTagsImp = manage_webentries.getDictTagImportance()
  print(dTagsImp)
  
def test_web_entries_list():
  import manage_webentries

  entries = manage_webentries.getWebEntries()
  print('Blog titles:')
  for blogEntry in entries:
    title = blogEntry.getTitle()
    html = blogEntry.toHtml()
    print ('\t' + title)

def test_metada():
  import manage_webentries
  entries = manage_webentries.getWebEntries()
  
  gtd_entry = None
  for entry in entries:
    if entry.getEntrySubUrl() == 'GettingThingsDone':
      gtd_entry = entry
  
  #assert gtd_entry is not None
  #print( gtd_entry.getDate() )

def test_module():
  #test_web_entries_list()
  #test_metada()
  test_manage_webentries()
    
if __name__ == '__main__':
  test_module()
  