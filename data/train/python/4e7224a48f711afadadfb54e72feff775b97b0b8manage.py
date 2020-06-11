from __future__ import (
        absolute_import, division, print_function, unicode_literals)

import os
from bottle import Bottle
from bottle_manage import Manage
import app.main as main

manage = Manage(main.application)

def run_command(command):
    """ We frequently inspect the return result of a command so this is just
        a utility function to do this. Generally we call this as:
        return run_command ('command_name args')
    """
    result = os.system(command)
    return 0 if result == 0 else 1

@manage.command
def coffeelint():
    return run_command('coffeelint app/coffee')

@manage.command
def coffeebuild():
    return run_command('coffee -c -o app/static/generated/ app/coffee')

@manage.command
def test_all():
    return run_command("python -m unittest app.main")

@manage.command
def test():
    """ Eventually this could become a convenience command for calling the
        other test commands quickly with just test -x.
    """
    return test_all()

@manage.command
def test_casper(name=None):
    """Run the specified single CasperJS test, or all if not given"""
    coffeebuild()
    from app.test_phantom import PhantomTest
    phantom_test = PhantomTest('test_run')
    phantom_test.set_single(name)
    result = phantom_test.test_run()
    return (0 if result == 0 else 1)


@manage.command
def coverage():
    rcpath = os.path.abspath('.coveragerc')

    full_command = 'test_all'
    manage_command = full_command

    if os.path.exists('.coverage'):
        os.remove('.coverage')
    os.system((
            "COVERAGE_PROCESS_START='{0}' "
            "coverage run manage.py {1}"
            ).format(rcpath, manage_command))
    os.system("coverage combine")
    os.system("coverage report -m")
    os.system("coverage html")

@manage.command
def runserver(reloader=False, debug=False, port=5000):
    """ Run the application. """
    main.application.run(reloader=reloader, debug=debug, port=port)

if __name__ == '__main__':
    manage()
