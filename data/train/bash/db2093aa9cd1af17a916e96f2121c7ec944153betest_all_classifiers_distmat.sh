#Script testing classifiers based on precomputed distance matrix
#$1 - input file
#$2 - distance matrix
#$3 -id for all pckl

#Generate test and train sets:
echo '----------splitting data----------'
python split_train_test_highest.py $1 5 5 save_train$3.pckl save_test$3.pckl save_labels$3.pckl save_elemcnt$3.pckl mc ut ti ab

#Train classifiers:
echo '----------mlknn-basic----------'
python main_train_classifier_distmat.py save_train$3.pckl save_labels$3.pckl save_elemcnt$3.pckl mlknn_basic 5 5 $2 save_test$3.pckl
echo '----------mlknn-threshold----------'
python main_train_classifier_distmat.py save_train$3.pckl save_labels$3.pckl save_elemcnt$3.pckl mlknn_threshold 5 5 $2 save_test$3.pckl
echo '----------mlknn-tensembled----------'
python main_train_classifier_distmat.py save_train$3.pckl save_labels$3.pckl save_elemcnt$3.pckl mlknn_tensembled 3,5,8 5 $2 save_test$3.pckl

#Train hierarchical classifiers:
echo '----------mlknn-basic-tree----------'
python main_train_hier_classifier_distmat.py save_train$3.pckl save_labels$3.pckl save_elemcnt$3.pckl mlknn-basic-tree 5 5 $2 save_test$3.pckl
echo '----------mlknn-threshold-tree----------'
python main_train_hier_classifier_distmat.py save_train$3.pckl save_labels$3.pckl save_elemcnt$3.pckl mlknn-threshold-tree 5 5 $2 save_test$3.pckl
echo '----------mlknn-tensembled-tree----------'
python main_train_hier_classifier_distmat.py save_train$3.pckl save_labels$3.pckl save_elemcnt$3.pckl mlknn-tensembled-tree 3,5,8 5 $2 save_test$3.pckl
