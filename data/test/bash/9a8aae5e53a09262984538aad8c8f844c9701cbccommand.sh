# commands to run

#Recomputation Model

#LeNet
#th calculation.lua --modelFile 'model_LN.net' --channels 1 --W 32 --H 32 --outfile 'LeNetResults' --model 'C' --ascii

#ImageNet
#th calculation.lua --modelFile 'model_IN2.net' --channels 3 --W 224 --H 224 --outfile 'ImageNetResults' --model 'C' --ascii

#VGG
#th calculation.lua --modelFile 'model_VGG.net' --channels 3 --W 224 --H 224 --outfile 'VGGResults' --model 'C' 

#INP
#th calculation.lua --modelFile 'model_INP.net' --channels 3 --W 224 --H 224 --outfile 'ImageNetResultsPaper' --model 'C'  --ascii

#INP2
#th calculation.lua --modelFile 'model_INP2.net' --channels 3 --W 224 --H 224 --outfile 'ImageNetResultsPaper2_recompute' --model 'C'  --ascii

#-----------------------------------------------------------------------------------------------------------------------

#ReUse Model

#LeNet
#th calculation.lua --modelFile 'model_LN.net' --channels 1 --W 32 --H 32 --outfile 'LeNetResults' --model 'U' --ascii

#ImageNet
#th calculation.lua --modelFile 'model_IN2.net' --channels 3 --W 224 --H 224 --outfile 'ImageNetResults' --model 'U' --ascii

#VGG
#th calculation.lua --modelFile 'model_VGG.net' --channels 3 --W 224 --H 224 --outfile 'VGG_Results' --model 'U'

#VGG2
#th calculation.lua --modelFile 'model_VGG2.net' --channels 3 --W 224 --H 224 --outfile 'VGG_Results2' --model 'U'

#test
#th calculation.lua --modelFile 'model_test.net' --channels 3 --W 227 --H 227 --outfile 'TestNetResults' --model 'U' --ascii

#INP
#th calculation.lua --modelFile 'model_INP.net' --channels 3 --W 224 --H 224 --outfile 'ImageNetResults2_layers' --model 'U'  --ascii

#INP First Layer
#th calculation.lua --modelFile 'model_INP2.net' --channels 3 --W 224 --H 224 --outfile 'ImageNetResults1_layers' --model 'U'  --ascii

#--------------------------------------------------------------------------------------------------------------------------
#Multicone model

#INP
#th calculation.lua --modelFile 'model_INP.net' --channels 3 --W 224 --H 224 --outfile 'ImageNetResults2_layers' --multicone --optimize --plot --ascii

#LeNet
#th calculation.lua --modelFile 'model_LN.net' --channels 1 --W 32 --H 32 --outfile 'LeNetResults' --multicone --optimize --plot --ascii

#ImageNet
#th calculation.lua --modelFile 'model_IN2.net' --channels 3 --W 224 --H 224 --outfile 'ImageNetResults' --multicone --optimize --plot --ascii

#VGG
#th calculation.lua --modelFile 'model_VGG.net' --channels 3 --W 224 --H 224 --outfile 'VGG_Results' --multicone --optimize --plot --ascii

#VGG2
#th calculation.lua --modelFile 'model_VGG2.net' --channels 3 --W 224 --H 224 --outfile 'VGG_Results2' --multicone --optimize --plot 

#test
#th calculation.lua --modelFile 'model_test.net' --channels 3 --W 227 --H 227 --outfile 'TestNetResults' --multicone --optimize --plot --ascii

#INP
#th calculation.lua --modelFile 'model_INP.net' --channels 3 --W 224 --H 224 --outfile 'ImageNetResults2_layers' --multicone --optimize --plot --ascii

#INP First Layer
#th calculation.lua --modelFile 'model_INP2.net' --channels 3 --W 224 --H 224 --outfile 'ImageNetResults1_layers' --multicone --optimize --plot --ascii

#VGG2 Without plot
#th calculation.lua --modelFile 'model_VGG2.net' --channels 3 --W 224 --H 224 --outfile 'VGG_test' --multicone --optimize  

#VGG2 Without plot and optimize
#th calculation.lua --modelFile 'model_VGG2.net' --channels 3 --W 224 --H 224 --outfile 'VGG_test_optimize' --multicone  --optimize

#VGG2 Without plot and optimize
#th calculation.lua --modelFile 'model_VGG2.net' --channels 3 --W 224 --H 224 --outfile 'VGG_test' --multicone

#INP
#th calculation.lua --modelFile 'model_INP.net' --channels 3 --W 227 --H 227 --outfile 'ImageNetResults2_layers_test' --multicone --ascii

#th calculation.lua --modelFile 'model_INP.net' --channels 3 --W 227 --H 227 --outfile 'ImageNetResults2_layers_optimize' --multicone --optimize --ascii

#---------------------------------------------------------------------------------------------------------------------------------------------
#FPGA Prints
#VGG2 Without plot and optimize
#th calculation.lua --modelFile 'model_VGG2.net' --channels 3 --W 224 --H 224 --outfile 'VGG_test_optimize' --multicone  --optimize --singlePyramid

#VGG19
#th calculation.lua --modelFile 'model_VGG19.net' --channels 3 --W 224 --H 224 --outfile 'VGG_test_optimize' --multicone  --optimize --singlePyramid

#VGG4
#th calculation.lua --modelFile 'model_VGG4.net' --channels 3 --W 224 --H 224 --outfile 'VGG4_test_optimize' --multicone  --optimize --singlePyramid

#VGG3
#th calculation.lua --modelFile 'model_VGG3.net' --channels 3 --W 224 --H 224 --outfile 'VGG3_test_optimize' --multicone  --optimize --singlePyramid

#VGG5
th calculation.lua --modelFile 'model_VGG5.net' --channels 3 --W 224 --H 224 --outfile 'VGG5_test_optimize' --multicone  --optimize --singlePyramid


#th calculation.lua --modelFile 'model_VGG19.net' --channels 3 --W 224 --H 224 --outfile 'VGG19_Results' --model 'U'

#th calculation.lua --modelFile 'model_INP.net' --channels 3 --W 227 --H 227 --outfile 'ImageNet' --model 'U'  --ascii
#----------------------------------------------------------------------------------------------------------------------------------------------
#Generate the model

#ImageNet
#th model_generate.lua --model IN

#LeNet
#th model_generate.lua --model LN

#test
#th model_generate.lua --model T

#vgg2
#th model_generate.lua --model vgg2

#INP
#th model_generate.lua --model INP

#INP2
#th model_generate.lua --model INP2


#VGG 19
#th model_generate.lua --model vgg19


#VGG 4
#th model_generate.lua --model vgg4

#VGG 3
#th model_generate.lua --model vgg3

#VGG 5
#th model_generate.lua --model vgg5

