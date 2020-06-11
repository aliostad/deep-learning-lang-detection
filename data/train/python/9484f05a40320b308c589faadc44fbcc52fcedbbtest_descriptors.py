from nose.tools import eq_
from inform.descriptors import controller


def test_controller_call():
    @controller
    def func(x, y):
        return x + y
    eq_(func(1, 2), 3)

    

def test_controller_apply_multidict():
    args = {'x': 1, 'y': 2}
    @controller
    def func(x, y=1):
        return x + y
    eq_(func.apply_multidict(args), 3)
    

def test_controller_apply_multidict_missing_arg():
    args = {}
    @controller
    def func(x):
        return x + 1
    eq_(func.apply_multidict(args), 3)
    
    