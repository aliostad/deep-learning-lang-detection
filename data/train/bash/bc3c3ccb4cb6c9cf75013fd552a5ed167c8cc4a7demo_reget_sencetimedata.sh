mpwd=`pwd`
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$mpwd/../../lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$mpwd/../../src/API_caffe/v1.2.0/lib
export PYTHONPATH=$PYTHONPATH:$mpwd/../../src/API_caffe/v1.2.0/python/py-faster-rcnn-lib
################################Path################################
queryList='data/face_mutipeople_20160316/trainval.txt'
path_img='data/face_mutipeople_20160316/res_face7class/JPEGImages/'
loadAnnotations='data/face_mutipeople_20160316/res_face7class/Annotations/'

################################Path################################
SavePath='res/'
rm -r $SavePath
mkdir $SavePath
############################trainval.txt################################
rm $SavePath/trainval.txt
################################Path################################
xmlSavePath='Annotations/'
rm -r $SavePath$xmlSavePath
mkdir $SavePath$xmlSavePath
################################Path################################
imgSavePath='JPEGImages/'
rm -r $SavePath$imgSavePath
mkdir $SavePath$imgSavePath
################################DL_ImgLabel################################
#Demo_facedetect -reget_sencetime queryList.txt imgPath loadAnnotations xmlSavePath imgSavePath
../Demo_facedetect -reget_sencetime $queryList $path_img $loadAnnotations $SavePath$xmlSavePath $SavePath$imgSavePath


