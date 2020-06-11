#!/bin/sh


path=test_ele_with_PUweight_NoMassCut

  # SingleElectron data

  folder_name=output_ele

     save_name=SingleElectron-combine
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/$save_name.root\"\,\"$save_name\"\)

  # DY
  folder_name=DY

     save_name=DYJetsToLL_M-50_HT-100to200_13TeV
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/output_ele/$save_name.root\"\,\"$save_name\"\)

     save_name=DYJetsToLL_M-50_HT-200to400_13TeV
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/output_ele/$save_name.root\"\,\"$save_name\"\)

     save_name=DYJetsToLL_M-50_HT-400to600_13TeV
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/output_ele/$save_name.root\"\,\"$save_name\"\)

     save_name=DYJetsToLL_M-50_HT-600toInf_13TeV
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/output_ele/$save_name.root\"\,\"$save_name\"\)

  # TTbar
  folder_name=TTbar

     save_name=TT_TuneCUETP8M1_13TeV
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/output_ele/$save_name.root\"\,\"$save_name\"\)

  # diboson + ZH
  folder_name=diboson

     save_name=ZH_HToBB_ZToLL_M125_13TeV_amcatnlo
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/output_ele/$save_name.root\"\,\"$save_name\"\)

     save_name=ZH_HToBB_ZToLL_M125_13TeV_powheg
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/output_ele/$save_name.root\"\,\"$save_name\"\)

     save_name=WW_TuneCUETP8M1_13TeV
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/output_ele/$save_name.root\"\,\"$save_name\"\)

     save_name=WZ_TuneCUETP8M1_13TeV
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/output_ele/$save_name.root\"\,\"$save_name\"\)

     save_name=ZZ_TuneCUETP8M1_13TeV
     root -q -b -l make_histogram.C+\(\"$path/$folder_name/output_ele/$save_name.root\"\,\"$save_name\"\)


echo "finish"
rm *.d *.so *.pcm








