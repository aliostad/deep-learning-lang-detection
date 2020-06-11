__author__ = 'watson'
'''
Python has known at least three different MRO algorithms:
classic,
Python 2.2 new-style, and
Python 2.3 new-style (a.k.a. C3).
Only the latter survives in Python 3.

The computation of the MRO was officially documented as using
a depth-first left-to-right traversal of the classes as before.
If any class was duplicated in this search, all but the last occurrence
would be deleted from the MRO list.

'''

class A(object):
    def save(self):
        print "save inside class A : "

class B(A):
    def save(self):
        print "save inside class B : "

class C(A):
    def save(self):
        print "save inside class C : "

class D(B, C):
    def save(self):
        print "save inside class D : "

x_inst = D()
print "x_inst method : ", x_inst.save()