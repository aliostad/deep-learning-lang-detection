fin=$1
evt0=$2
evt1=$3
kgrid=$4

chunk=${fin##*/}
#11000143237007.70.root

chunk=${chunk%.*}
#11000143237007.70

echo fin:$fin
echo evt0:$evt0
echo evt1:$evt1
echo kgrid:$kgrid
echo chunk:$chunk
echo

dir=$chunk\_evt$evt0\_$evt1
mkdir $dir
cd $dir

~/.task/Reconstruction/rec $fin $evt0 $evt1 $kgrid
cd -
exit

aliroot -b -l <<EOF
gInterpreter->AddIncludePath("$myINC");
.L ~/.task/Reconstruction/rec.C 
rec("$fin",$nevt, $kgrid)
.q
EOF

cd $dir

   
#xlu@lxi035:~/.task/Reconstruction$ echo $aa
#/d/alice11/xlu/myTestData/alien/alice/data/2011/LHC11a/000143237/raw/11000143237007.70.root

#xlu@lxi035:~/.task/Reconstruction$ echo ${aa##*/}
#11000143237007.70.root

#xlu@lxi035:~/.task/Reconstruction$ echo ${aa#*/}
#d/alice11/xlu/myTestData/alien/alice/data/2011/LHC11a/000143237/raw/11000143237007.70.root

#xlu@lxi035:~/.task/Reconstruction$ echo ${aa%%/*}


#xlu@lxi035:~/.task/Reconstruction$ echo ${aa%/*}
#/d/alice11/xlu/myTestData/alien/alice/data/2011/LHC11a/000143237/raw

