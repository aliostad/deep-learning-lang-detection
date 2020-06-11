"""
Tests for file_read.py
"""
import file_read

def test_manage_line() :
    # A good reason for manage_line to have a return value is to make sure
    # that the function does what you think it should do when you give it
    # a known argument
    assert(file_read.manage_line('Matthew 34234 934') != None)
    assert(file_read.manage_line('Camille 2 435') == None)
    assert(file_read.manage_line('Person 34 0') == 'Person 34 0')
    assert(file_read.manage_line('Person 0 0') == None)

def test_pass() :
    pass
