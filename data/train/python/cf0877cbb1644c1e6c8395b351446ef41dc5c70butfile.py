'''
Created on 30.05.2012

@author: picasso
'''

import settings
import os

FIXTURE_ROOT = os.path.join(settings.SITE_ROOT, 'estatebase', 'fixtures')

'''

./manage.py dumpdata estatebase.estatetypecategory estatebase.estatetype > estatebase/fixtures/temp.json
./manage.py loaddata init_dict.json

./manage.py schemamigration estatebase --auto
./manage.py migrate estatebase
'''

fixtures = ('temp.json',)

try:
    for fix in fixtures:
        fixfile = os.path.join(FIXTURE_ROOT, fix)
        utf_content = open(fixfile, 'rb').read().decode("unicode_escape").encode("utf8")
        open(fixfile, 'wb').write(utf_content)
finally:
    print 'Done!'