-- This file is normally run from "setup.py test".
-- Run manually like this: psql -d postgres -v langname=plpython2u < run_test_plpydbapi_dbapi20.sql

-- This script sets sys.path in the server to include the directory
-- for plpydbapi.py.  It also needs dbapi20.py, so either copy that,
-- or adjust sys.path, or set the environment variable PYTHONPATH for
-- the PostgreSQL server process.

-- Choose plpython2u or plpython3u here, if not set on the psql command line.
--\set langname plpython2u

-- turn off most unnecessary output decoration
\set ON_ERROR_STOP 1
\set QUIET 1
\set VERBOSITY terse
\timing off
SET client_min_messages = warning;

-- set up test database
DROP DATABASE IF EXISTS plpydbapi_test;
CREATE DATABASE plpydbapi_test;
\connect plpydbapi_test
CREATE OR REPLACE LANGUAGE :langname;

-- adjust sys.path
\set pwd `pwd`
\set cmd 'import sys; sys.path.insert(0, \'' :pwd '\'); sys.path.append(\'' :pwd '/dbapi-compliance\')'
DO LANGUAGE :langname :'cmd';

-- run unittest
DO LANGUAGE :langname
$$
try:
    # unittest2 is only needed for Python 2.6
    import unittest2 as unittest
except ImportError:
    import unittest
import test.test_plpydbapi_dbapi20
import test.plpy_test_runner
import sys

# unittest and argparse assume that sys.argv always exists, so fake it
sys.argv = ["plpython"]

try:
    unittest.main(module='test.test_plpydbapi_dbapi20', testRunner=test.plpy_test_runner.PlpyTestRunner)
except SystemExit as e:
    # propagate exit status via psql, instead of killing the server process
    if e.args[0] != 0:
        plpy.error("test suite failed, exit status %d" % e.args[0])
$$;
