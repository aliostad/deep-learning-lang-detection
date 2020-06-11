__author__ = 'mars'
import sys,subprocess,os

if len(sys.argv) != 3:
    print('wrong arg')
    exit(1)

data_path=sys.argv[1]
save_path=sys.argv[2]



NR_THREAD=2

#3idiots的方案

#-----------------------------------gbdt------------------------

cmd = 'feature_engineering/converters/add_dummy_label.py {data}test.csv {data}test.tmp.csv'.format(data=data_path)
subprocess.call(cmd, shell=True)
print('dummy label to test.csv added!\n')


cmd = 'feature_engineering/converters/parallelizer-a.py -s {nr_thread} feature_engineering/converters/pre-a.py {data}train.csv {save}tr.gbdt.dense {save}tr.gbdt.sparse'.format(nr_thread=NR_THREAD,data=data_path,save=save_path)
subprocess.call(cmd, shell=True)
print('train set to dense and sparse format completed!\n')

cmd = 'feature_engineering/converters/parallelizer-a.py -s {nr_thread} feature_engineering/converters/pre-a.py {data}test.tmp.csv {save}te.gbdt.dense {save}te.gbdt.sparse'.format(nr_thread=NR_THREAD,data=data_path,save=save_path)
subprocess.call(cmd, shell=True)
print('test set to dense and sparse format completed!\n')

cmd = 'feature_engineering/converters/gbdt -t 30 -s {nr_thread} {save}te.gbdt.dense {save}te.gbdt.sparse {save}tr.gbdt.dense {save}tr.gbdt.sparse {save}te.gbdt.out {save}tr.gbdt.out'.format(nr_thread=NR_THREAD,save=save_path)
subprocess.call(cmd, shell=True)
print('gbdt features generated!\n')

cmd = 'rm -f {path}te.gbdt.dense {path}te.gbdt.sparse {path}tr.gbdt.dense {path}tr.gbdt.sparse'.format(path=save_path)
subprocess.call(cmd, shell=True)

#tr.csv原始特征，tr.gbdt.out增强（gbdt）特征
cmd = 'feature_engineering/converters/parallelizer-b.py -s {nr_thread} feature_engineering/converters/pre-b.py {data}train.csv {save}tr.gbdt.out {save}tr.sp'.format(nr_thread=NR_THREAD,data=data_path,save=save_path)
subprocess.call(cmd, shell=True)

print('gbdt features added to train dataSet\n')

cmd = 'feature_engineering/converters/parallelizer-b.py -s {nr_thread} feature_engineering/converters/pre-b.py {data}test.tmp.csv {save}te.gbdt.out {save}te.sp'.format(nr_thread=NR_THREAD,data=data_path,save=save_path)
subprocess.call(cmd, shell=True)
print('gbdt features added to test dataSet\n')


#-----------------------------------gbdt------------------------

print('gbdt process completed!')



#trian&test

cmd = './ffm -k 4 -t 11 -s {nr_thread} {save}te.sp {save}tr.sp'.format(nr_thread=NR_THREAD,save=save_path)
subprocess.call(cmd, shell=True)
cmd = './make_ffm_submission.py {save}te.sp.out {save}submission.csv'.format(nr_thread=NR_THREAD,save=save_path)
subprocess.call(cmd, shell=True)


