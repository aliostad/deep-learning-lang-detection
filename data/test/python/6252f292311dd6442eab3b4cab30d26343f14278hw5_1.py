from preliminaries import *
import random, scipy.special, scipy.interpolate, math, numpy
import itertools as itt
from sys import stdout
norm = numpy.linalg.norm
dot = numpy.dot
array = numpy.array
import pickle

class save_class:
    pass

save = save_class()


save.n = 10
save.p_degree = 3
save.n_samples = 10000

def mi_itt(length, degree):
    prod = itt.product(range(degree+1), repeat=length)
    return ( i for i in prod if sum(i) <= degree )

def mi_pow(x, i):
    y = 1.0
    for j in range(len(x)):
        y *= x[j]**i[j]
    return y

def mpoly_eval(coeff, x, degree):
    return sum( coeff[j]*mi_pow(x, i) for j,i in enumerate(mi_itt(len(x), degree)) )

def xsample(N, mean, sig):
    xsamps = numpy.zeros((N, len(mean)) )
    for j in range(len(mean)):
        xsamps[:,j] = numpy.random.normal(mean[j], sig[j], N)
    return xsamps

print "drawig coefficients..."
save.coefficients = numpy.array( \
    [random.normalvariate(0,1) for j in mi_itt(save.n, save.p_degree)] )

print "drawing x samples:", save.n_samples
save.means = array([random.normalvariate(0,1) for j in range(save.n) ])
save.sigs = 0.5*abs(save.means)
save.xsamples = xsample(save.n_samples, save.means, save.sigs)

print "building poly matrix..."
save.X_poly = numpy.array( [[mi_pow(x, i) for x in save.xsamples ] for i in mi_itt(save.n, save.p_degree)] ).transpose()
print "shape of X_poly:", numpy.shape(save.X_poly)

print "building  distance squared matrix... "

MM = dot(save.xsamples, save.xsamples.transpose())
save.distancesq_matrix = numpy.zeros((save.n_samples, save.n_samples), dtype=numpy.float64)
for i,j in itt.product(range(save.n_samples), range(save.n_samples)):
    save.distancesq_matrix[i,j] = MM[i,i] + MM[j,j] - 2*MM[i,j]

save_file = open("/home/nmaxwell/save.pickle", 'w')
pickle.dump(save, save_file, pickle.HIGHEST_PROTOCOL)



