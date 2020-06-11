#python ../crf_train.py ../feature_list ../../../preprocessing/R/test/crf_feature_disjoint crf.disjoint.model
#~/git/crfsuite-0.12/frontend/crfsuite dump crf.disjoint.model > crf.disjoint.model.friendly

#python ../crf_train.py ../feature_list ../../../preprocessing/R/test/crf_feature crf.model
#~/git/crfsuite-0.12/frontend/crfsuite dump crf.model > crf.model.friendly




#python ../crf_train.py ../feature_list_all ../../../preprocessing/R/test/crf_feature_SDU082 crf.SDU082.model
#~/git/crfsuite-0.12/frontend/crfsuite dump crf.SDU082.model > crf.SDU082.model.friendly

#python ../crf_train.py ../feature_list ../../../preprocessing/R/test/crf_feature_SDU082 crf.SDU082.speed_only.model
#~/git/crfsuite-0.12/frontend/crfsuite dump crf.SDU082.speed_only.model > crf.SDU082.model.speed_only.friendly


#python ../crf_train.py ../feature_list ../../../preprocessing/R/test/crf_feature_SDU082 crf.SDU082.speeed_ele.model
#~/git/crfsuite-0.12/frontend/crfsuite dump crf.SDU082.speeed_ele.model > crf.SDU082.speeed_ele.model.friendly


#python ../crf_train.py ../feature_list_all ../../../preprocessing/R/test/crf_feature_SDU079 crf.SDU079.model
#~/git/crfsuite-0.12/frontend/crfsuite dump crf.SDU079.model > crf.SDU079.model.friendly

#python ../crf_train.py ../feature_list ../../../preprocessing/R/test/crf_feature_SDU079 crf.SDU079.speed_only.model
#~/git/crfsuite-0.12/frontend/crfsuite dump crf.SDU079.speed_only.model > crf.SDU079.model.speed_only.friendly

#python ../crf_train.py ../feature_list_all ../../../preprocessing/R/test/crf_feature_SDU085 crf.SDU085.model
#~/git/crfsuite-0.12/frontend/crfsuite dump crf.SDU085.model > crf.SDU085.model.friendly

#python ../crf_train.py ../feature_list ../../../preprocessing/R/test/crf_feature_SDU085 crf.SDU085.speed_only.model
#~/git/crfsuite-0.12/frontend/crfsuite dump crf.SDU085.speed_only.model > crf.SDU085.model.speed_only.friendly

python ../crf_train.py ../feature_list_all ../../../preprocessing/R/test/results/crf_feature_all_15_seqLength_0_overlap crf.all.model
~/git/crfsuite-0.12/frontend/crfsuite dump crf.all.model > crf.all.model.friendly

# python ../crf_train.py ../feature_list ../../../preprocessing/R/test/crf_feature_all crf.all.speed_only.model
# ~/git/crfsuite-0.12/frontend/crfsuite dump crf.all.speed_only.model > crf.all.speed_only.model.friendly



