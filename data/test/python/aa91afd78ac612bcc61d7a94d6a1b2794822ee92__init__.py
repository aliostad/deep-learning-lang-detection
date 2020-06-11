# Get all individual unit tests together.
# Do it by hand for now;
# should we need something automatic, see here: http://djangosnippets.org/snippets/1972/

# Yes, pylint, we want wildcard imports here.
# pylint: disable-msg=W0401
from metashare.repository.tests.test_editor import *
from metashare.repository.tests.test_view import *
from metashare.repository.tests.test_search import *
from metashare.repository.tests.test_email import *
from metashare.repository.tests.test_model import *
from metashare.repository.tests.test_import import *
from metashare.repository.tests.test_status_workflow import *
from metashare.repository.tests.test_persistence import *
from metashare.repository.tests.test_special_queries import *
from metashare.repository.tests.test_seo import *
if 'METASHARE_NIGHTLY_BUILD' in os.environ.keys() \
  and os.environ['METASHARE_NIGHTLY_BUILD'] == 'true':
    from metashare.repository.tests.test_nightly import *
