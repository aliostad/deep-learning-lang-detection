#!/usr/bin/python2.6
# coding: gbk
#Filename: post_train_lsa_wrapper.py
from ctm_train_model import *
import os.path
c_p = os.path.dirname(os.getcwd())+"/"

save_main_path = c_p+"model/model_0829_dic1/0915_lsa/"
dic_main_path = c_p+"Dictionary/ctm/"

# step 1 :构造SVM训练的样本
#filename,indexs,dic_path,glo_aff_path,sample_save_path,delete
filename  = "D:/张知临/源代码/python_ctm/model/model_0829_dic1/post.train"

#----------------------title+content-----------------------
title_content_indexs = [1,2]
title_content_dic_path =dic_main_path+"Dic_all.key"
title_content_glo_aff_path  = dic_main_path+"Dic_all_1.glo"
title_content_M=28448 # the size of dictionary
title_content_sample_save_path = save_main_path+"title_content_1.train"

delete =True
tc_splitTag="\t"
str_splitTag ="^"

# step 2 :训练模型
#sample_save_path,param,model_save_path
title_content_svm_model_save_path = save_main_path+"title_content_1.model"
title_content_svm_param='-c 8.0 -g 0.0078125' 

# step 3 :3为生成初始分类得分
#test_path,m,for_lsa_train_save_path 
title_content_test_path = title_content_sample_save_path 
title_content_for_lsa_train_save_path =  save_main_path +"for_lsa.train"

#step 4 :
#M,N,n,k,for_lsa_train_save_path,train_save_path,lsa_model_save_path

threhold= 1.0 #threhold indicates the initial score.  top n documents for local SVD
k = 500
title_content_lsa_train_save_path =  save_main_path +"lsa_title_content_"+str(k)+".train"
title_content_lsa_save_path = save_main_path + "lsa_title_content_"+str(k)

#step 5:
title_content_lsa_svm_param  = '-c 0.5 -g 0.5'
title_content_lsa_svm_model_save_path  = save_main_path + "LSA_title_content"+str(k)+".model"
#step 6 
extra_filename = save_main_path+".extra"



print "欢迎使用C社区帖子监控，LSA模型训练系统"
choice = int(raw_input("1为构造SVM训练的样本； 2为训练模型；3为生成初始分类得分；4为构造LSA模型；5为训练LSA生成的模型;6为向原模型中增加原先误判的样本；7为向LSA模型中增加原先误判样本。0为退出模型"))
while choice!=0:
    if choice==1:
        cons_train_sample_for_cla(filename,title_content_indexs,title_content_dic_path,title_content_glo_aff_path,title_content_sample_save_path,delete,str_splitTag)
    if choice==2:
      m=ctm_train_model(title_content_sample_save_path,title_content_svm_param,title_content_svm_model_save_path) 
    if choice==3:
        save_train_for_lsa(title_content_test_path,title_content_svm_model_save_path,title_content_for_lsa_train_save_path)
    if choice==4:
        ctm_lsa(title_content_M,threhold,k,title_content_for_lsa_train_save_path,title_content_lsa_train_save_path,title_content_lsa_save_path)
    if choice ==5:
        ctm_train_model(title_content_lsa_train_save_path,title_content_lsa_svm_param,title_content_lsa_svm_model_save_path)
    if choice ==6:
      add_sample_to_model(extra_filename,title_content_indexs,title_content_dic_path,title_content_glo_aff_path,title_content_sample_save_path,delete,str_splitTag)  
    choice = int(raw_input("1为构造SVM训练的样本； 2为训练模型；3为生成初始分类得分；4为构造LSA模型；5为训练LSA生成的模型;6为向原模型中增加原先误判的样本；7为向LSA模型中增加原先误判样本。0为退出模型"))
