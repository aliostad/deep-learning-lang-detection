from msmbuilder.featurizer import DihedralFeaturizer
from msmbuilder.dataset import dataset
import numpy as np
from matplotlib import pyplot as plt
import mdtraj as md
import os,sys
import msmbuilder.utils
from msmbuilder.utils import load
from msmbuilder.cluster import KMeans
from msmbuilder.cluster import KCenters
from msmbuilder.cluster import KMedoids
from msmbuilder.cluster import MiniBatchKMeans
from msmbuilder.msm import implied_timescales
from msmbuilder.msm import ContinuousTimeMSM, MarkovStateModel
from itertools import combinations
from msmbuilder.featurizer import AtomPairsFeaturizer
from msmbuilder.decomposition import tICA
from sklearn.pipeline import Pipeline
from msmbuilder.example_datasets import fetch_met_enkephalin
from matplotlib import pyplot as plt
from sklearn.externals import joblib

#Featurization
t = md.load('conf.gro')
trajs = md.load('traj0.xtc',top='conf.gro')
#Ind = t.topology.select("(backbone and protein)or name 'CB'")
#trajs1=trajs.atom_slice(Ind)
print "Preparation done, now begin clustering..."
#Cluster
kcenters=KCenters(n_clusters=25,metric='rmsd').fit(trajs)
traj2=kcenters.cluster_centers_
traj2.save_pdb('Gens_total.pdb')
sys.exit()
traj2[0].save_pdb('Gens0.pdb')
traj2[1].save_pdb('Gens1.pdb')
traj2[2].save_pdb('Gens2.pdb')
traj2[3].save_pdb('Gens3.pdb')
traj2[4].save_pdb('Gens4.pdb')
traj2[5].save_pdb('Gens5.pdb')
traj2[6].save_pdb('Gens6.pdb')
traj2[7].save_pdb('Gens7.pdb')
traj2[8].save_pdb('Gens8.pdb')
traj2[9].save_pdb('Gens9.pdb')
traj2[10].save_pdb('Gens10.pdb')
traj2[11].save_pdb('Gens11.pdb')
traj2[12].save_pdb('Gens12.pdb')
traj2[13].save_pdb('Gens13.pdb')
traj2[14].save_pdb('Gens14.pdb')
traj2[15].save_pdb('Gens15.pdb')
traj2[16].save_pdb('Gens16.pdb')
traj2[17].save_pdb('Gens17.pdb')
traj2[18].save_pdb('Gens18.pdb')
traj2[19].save_pdb('Gens19.pdb')
traj2[20].save_pdb('Gens20.pdb')
traj2[21].save_pdb('Gens21.pdb')
traj2[22].save_pdb('Gens22.pdb')
traj2[23].save_pdb('Gens23.pdb')
traj2[24].save_pdb('Gens24.pdb')
