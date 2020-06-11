#!/usr/bin/python2.6
# coding: gbk
#Filename: ctm_train_model_config.py
import os.path
c_p = os.path.dirname(os.getcwd())+"/"

'''------------model_0829_dic1------------------
save_main_path = c_p+"model/model_0829_dic1/0901/"
dic_main_path = c_p+"Dictionary/ctm/"
# step 1 :构造SVM训练的样本
#filename,indexs,dic_path,glo_aff_path,sample_save_path,delete
filename  = save_main_path+"train_set.txt"

##----------------------title------------------------
#indexs = [1]
#dic_path =dic_main_path+"Dic1_title.key"
#glo_aff_path  = dic_main_path+"Dic1_title.glo"
#M=895 # the size of dictionary
#sample_save_path = save_main_path+"title.train"
#
##----------------------content------------------------
#indexs = [2]
#dic_path =dic_main_path+"Dic1_content.key"
#glo_aff_path  = dic_main_path+"Dic1_content.glo"
#M=3789 # the size of dictionary
#sample_save_path = save_main_path+"content.train"

#----------------------title+content-----------------------
indexs = [1,2]
dic_path =dic_main_path+"Dic1_title_content.key"
glo_aff_path  = dic_main_path+"Dic1_title_content.glo"
M=3807 # the size of dictionary
sample_save_path = save_main_path+"title_content.train"

delete =True
tc_splitTag="\t"
str_splitTag ="^"

# step 2 :训练模型
#sample_save_path,param,model_save_path
svm_model_save_path = save_main_path+"title.model"
svm_param='-c 16.0 -g 0.00048828125' 

# step 3 :3为生成初始分类得分
#test_path,m,for_lsa_train_save_path 
test_path = sample_save_path 
for_lsa_train_save_path =  save_main_path +"for_lsa.train"

#step 4 :
#M,N,n,k,for_lsa_train_save_path,train_save_path,lsa_model_save_path

threhold= 0.5 #threhold indicates the initial score.  top n documents for local SVD
k = 10
lsa_train_save_path =  save_main_path +"0905_lsa_"+str(k)+".train"
lsa_save_path = save_main_path + "0905_lsa"

#step 5:
lsa_svm_param  = '-c -g'
lsa_svm_model_save_path  = save_main_path + "LSA_title.model"
#step 6 
extra_filename  = save_main_path +"data.extra"
-------------------------------------------------'''


'''------------model_ban禁限售样本----------------------------------------------------------------'''
#----------输入数据文件的一些参数

save_main_path = c_p+"model/model_0830_ban/"
dic_main_path = c_p+"Dictionary/ban/"

# step 1 :构造SVM训练的样本
#filename,indexs,dic_path,glo_aff_path,sample_save_path,delete
filename  = save_main_path+"adult_all_data.txt"
indexs = [1]
dic_path =dic_main_path+"Dic_ban.key"
glo_aff_path  = dic_main_path+"Dic_ban.glo"
M=7937 # the size of dictionary
sample_save_path = save_main_path+"ban.train"
delete =True
tc_splitTag="\t"
str_splitTag =" "

# step 2 :训练模型
#sample_save_path,param,model_save_path
svm_model_save_path = save_main_path+"ban.model"
svm_param='-c 4.0 -g 0.001953125' 

# step 3 :3为生成初始分类得分
#test_path,m,for_lsa_train_save_path 
test_path = sample_save_path 
for_lsa_train_save_path =  save_main_path +"for_lsa.train"

#step 4 :
#M,N,n,k,for_lsa_train_save_path,train_save_path,lsa_model_save_path

threhold= 0.5 #threho ld indicates the initial score.  top n documents for local SVD
k = 5
lsa_train_save_path =  save_main_path +"lsa_ban_"+str(k)+".train"
lsa_save_path = save_main_path + "lsa_ban_"+str(k)

#step 5:
lsa_svm_param  = '-c 8129.0 -g 8.0'
lsa_svm_model_save_path  = save_main_path + "LSA_ban_"+str(k)+".model"
#step 6 
extra_filename = save_main_path+"ban.extra"




