from __future__ import unicode_literals
from __future__ import print_function
from __future__ import division
from __future__ import absolute_import
from future import standard_library
standard_library.install_aliases()
import unittest

from mri import MriServer
from mri.dispatch import MriServerDispatch


class TestMriServer(unittest.TestCase):
    def test_new_dispatch(self):
        server = MriServer("http://www.httpbin.com", "testuser", "testpass")
        task = {"title": "TEST", "id": "000112233"}
        dispatch = server.new_dispatch(task)
        test_against = MriServerDispatch(task, "http://www.httpbin.com", "testuser", "testpass")
        self.assertEqual(dispatch, test_against)


if __name__ == '__main__':
    unittest.main()
