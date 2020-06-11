export WORKDIR=`pwd`
cd $WORKDIR

g++ run_create_qgl_tmva_all.C -g -o run_qgl `root-config --cflags --glibs` 

max_samples_num=2
path=/shome/nchernya/Hbb/skim_trees/v14/
input_dir=(VBFHToBB_M-125_13TeV_powheg BTagCSV)
ROOT=.root
v14=_v14
single=_single
slash=/


current_sample=0
while [ $current_sample -lt $max_samples_num ]
do	
	echo  ${path[$current_sample]} 
	./run_qgl $path${input_dir[ $current_sample ]}$v14$slash${input_dir[ $current_sample ]}$v14$ROOT ${input_dir[ $current_sample ]} $current_sample 0
	./run_qgl $path${input_dir[ $current_sample ]}$v14$single$slash${input_dir[ $current_sample ]}$v14$single$ROOT ${input_dir[ $current_sample ]} $current_sample 1

	current_sample=$(( $current_sample + 1 ))
done
