#!/usr/bin/python2.6
# coding: gbk
#Filename: post_train_lsa_wrapper.py
from ctm_train_model import *
import os.path
c_p = os.path.dirname(os.getcwd())+"/"

'''------------一些必要设置的选项-----------------'''
save_main_path = c_p+"model/im_info/10.19_33000/" #模型保存的主路径
filename  = c_p+"model/im_info/10.19_33000/trainset.train"
indexs = [6,7,8,9,10]
stopword_filename = c_p+"model/im_info/10.19_33000/stopwords.txt"
'''------------一些可选设置的选项-----------------'''
dic_name="dic.key"  #保存的词典名称
model_name="im.model"
train_name = "svm.train"
param_name = "svm.param"
ratio=0.4 #特征选择的比例，即top 40%的词作为新的词典
delete=True
str_splitTag="^"
tc_splitTag="\t"


'''------------------------分步训练时需要的设置的选项'''

# step 1 :构造SVM训练的样本，内容以及其他的特征。
#filename,indexs,dic_path,glo_aff_path,sample_save_path,delete
dic_path =save_main_path+"model/" +dic_name
#dic_path = c_p+"Dictionary/im_info/Dic_select_0928.key"
sample_save_path = save_main_path+"temp/"+"svm.train"
# step 2 :训练模型
#sample_save_path,param,model_save_path
svm_model_save_path = save_main_path+"model/" +model_name
svm_param='-c 2.82842712475 -g 1.0' 

# step 3 :3为生成初始分类得分
#test_path,m,for_lsa_train_save_path 
test_path = sample_save_path 
for_lsa_train_save_path =  save_main_path+"temp/" +"for_lsa.train"

#step 4 :
#M,N,n,k,for_lsa_train_save_path,train_save_path,lsa_model_save_path

threhold= 1.0 #threhold indicates the initial score.  top n documents for local SVD
k = 500
lsa_train_save_path =  save_main_path+"temp/"  +"lsa_"+str(k)+".train"
lsa_save_path = save_main_path+"temp/"  + "lsa_"+str(k)

#step 5:
lsa_svm_param  = '-c 2.0 -g 1.0'
lsa_svm_model_save_path  = save_main_path + "LSA_title_content"+str(k)+".model"
#step 6 
extra_filename = save_main_path+".extra"

#step 7:


print "欢迎使用旺旺聊天欺诈监控系统，LSA模型训练系统"
choice = int(raw_input("0为自动生成模型，1为构造SVM训练的样本； 2为训练模型;3为LSA模型生成训练文本格式；4为构造LSA模型；5为训练LSA生成的模型；6为用原模型计算内容得分提取其他特征;7为向原模型中增加原先误判的样本；7为向LSA模型中增加原先误判样本。-1为退出模型"))
while choice!=-1:
    if choice==0:
        ctm_train(filename,indexs,save_main_path,stopword_filename)
    if choice==1:
        cons_train_sample_for_cla(filename,indexs,dic_path,sample_save_path,delete,str_splitTag)
    if choice==2:
      m=ctm_train_model(sample_save_path,svm_param,svm_model_save_path) 
    if choice==3:
        save_train_for_lsa(test_path,svm_model_save_path,for_lsa_train_save_path)
    if choice==4:
        M = len(read_dic(dic_path))
        ctm_lsa(M,threhold,k,for_lsa_train_save_path,lsa_train_save_path,lsa_save_path)
    if choice ==5:
        ctm_train_model(lsa_train_save_path,lsa_svm_param,lsa_svm_model_save_path)
    if choice ==6:
      add_sample_to_model(extra_filename,indexs,dic_path,sample_save_path,delete,str_splitTag)  
    choice = int(raw_input("0为自动生成模型，1为构造SVM训练的样本； 2为训练模型；3为生成初始分类得分；4为构造LSA模型；5为训练LSA生成的模型;6为向原模型中增加原先误判的样本；7为向LSA模型中增加原先误判样本。-1为退出模型"))


