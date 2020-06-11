#!/usr/bin/python
# -*- coding: utf-8 -*-

from scipy.signal.ltisys import lti, lsim
from matplotlib.pylab import save, randn
from Numeric import sqrt, array, arange

n = 128
Q=1.
R=1.
w = 0.3 * sqrt(Q)*randn(n)
v = 0.2 * sqrt(R)*randn(n)
ureq = array([[-1.743] * n])

t = arange(0, 0.9999, 1./128)
#Generator().generateSin(n, 3, 33) #-0.37727


u = ureq + w

#A, B, C, D = [[-6.,-25.], [1.,0.]], [[1.],[0.]], [[0., 1.]], [[0.]]
#sys=lti(A, B, C, D)
#y = lsim(sys, u, t)
yv = u + v

##save('Q.txt', Q)
##save('R.txt', R)
save('w.txt', w)
save('v.txt', v)
save('yv.txt', yv)
save('u.txt', u)
save('ureq.txt', ureq)
