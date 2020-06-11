import numpy as n
import numpy.random as r
import bayes

if __name__ == '__main__':
    x = n.transpose([map(float, line.strip().split(',')) for line in open('../../flow2/data/3FITC-4PE.004.csv').readlines()[1:]])

    nit = 0
    nmc = 101
    n = x.shape[1]
    p = x.shape[0]
    k = 3
    record = 1
    
    b = bayes.Bayes()
    b.init(x, n, p, k)
    b.mcmc(nit, nmc, ".bayes.out", record)
    print "pi", b.get_pi()
    print "mu", b.get_mu()
    print "Omega", b.get_Omega()
    print "z", b.get_z()

    print "save_pi", b.get_save_pi()
    print "save_mu", b.get_save_mu()
    print "save_Omega", b.get_save_Omega()
    print "save_z", b.get_save_z()
