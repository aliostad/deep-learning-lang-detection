import netkit
from pandas import DataFrame
import pandas as pd


def run_netkit_on_single_relation(path, n_runs=10, save_to=None):

    inferencemethod='relaxlabel'

    res_wvrn, pred  = netkit.run(path, classifier='wvrn',
            inferencemethod=inferencemethod, cv_folds=n_runs, verbose=False)
    res_wvrn.columns = ['wvrn_acc', 'wvrn_std', 'ratio']

    res_nlb, pred  = netkit.run(path, classifier='nLB',
            inferencemethod=inferencemethod, cv_folds=n_runs, verbose=False)
    res_nlb.columns = ['nlb_acc', 'nlb_std', 'ratio']

    res_all = pd.merge(res_wvrn, res_nlb, on='ratio')

    if save_to is not None:
        res_all.to_csv('../results/' + save_to + '/netkit.csv', index=False)


def run_single_relation_experiments():

    path = 'citeseer/citeseer'
    save_to = 'citeseer'
    run_netkit_on_single_relation(path, save_to=save_to)

    path = 'cora/cora'
    save_to = 'cora'
    run_netkit_on_single_relation(path, save_to=save_to)

    path = 'imdb_all/imdb_all'
    save_to = 'imdb'
    run_netkit_on_single_relation(path, save_to=save_to)

run_single_relation_experiments()
