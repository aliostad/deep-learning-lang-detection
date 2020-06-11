#/usr/bin/bash
#create directories
for i in {1..4..1}
	do
	Files="./Experiment00$i/test*dim_theta*"

	for f in $Files
		do
	    newf=${f##./*/}
		#newf=${newf//20PCA/20PCA_5States}
		newf=${newf/12states/5states}
		echo $newf
		cp -n $f ./Experiment5States00$i/$newf
		#replace subExperiment in the file
		sed -i -e "s/Experiment00$i/Experiment5States00$i/g" "./Experiment5States00$i/$newf"
		sed -i -e "/numStates =/c numStates = 5;" "./Experiment5States00$i/$newf"
		sed -i -e "76,81s/^save_file_name/%save_file_name/g" "./Experiment5States00$i/$newf"
		sed -i -e "76,81s/^\([^%]*\)num2str(size(Names,2)/%\1num2str(size(Names,2)/g" "./Experiment5States00$i/$newf" 
		sed -i -e "76,81s/^\([^%]*\)num2str(timestr(3)/%\1num2str(timestr(3)/g" "./Experiment5States00$i/$newf" 
		sed -i -e "76,81s/^\([^%]*\)save('-mat7-binary'/%\1save('-mat7-binary'/g" "./Experiment5States00$i/$newf"
		#replace the last line
		sed -i -e "85,$ s/^save\(.*\).mat'));/%save\1.mat'));/g" "./Experiment5States00$i/$newf"
		rename "12states" "5states" ./Experiment5States00$i/$newf
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'FPHMMCell');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracyEmotion_FPHMM_MissingSet_knownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracyEmotion_FPHMM_TestSet_knownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracyEmotion_FPHMM_TrainSet_knownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracyEmotion_FPHMM_ValSet_knownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracyEmotion_FPHMM_MissingSet_knownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_MissingSet_knownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_MissingSet_unknownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_TestSet_knownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_TestSet_unknownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_TrainSet_knownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_TrainSet_unknownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_ValSet_knownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat7-binary',strcat(save_file_name,'.mat'),'accuracy_FPHMM_ValSet_unknownEm','-append');" "./Experiment5States00$i/$newf"
		sed -i -e "$ a save('-mat-binary',strcat(save_file_name,'.mat'),'prdt*','-append');" "./Experiment5States00$i/$newf"

	done



done

. ./script_CpCommands.sh
#Name1="PfSW_NtWH"
#Name2="PfSW_AgWH"
#Name3="PfSW_AxWH"
#Name4="PrSW_AgWH"

#Name=('PfSW_NtWH','PfSW_NtWH','PfSW_NtWH','PfSW_NtWH')
#for i in {1..1..1}
#	do
		#cp ../SynthesisExp009/Experiment001/test* ./Experiment00$i/
		#cp ../SynthesisExp009/Experiment001/Comma* ./Experiment00$i/
		#rename $Name[$i] ./Experiment00$i/test*.m

#done

#rename 'NtSW_SdWH' 'PfSW_NtWH' ./Experiment001/test*.m
#rename 'NtSW_SdWH' 'PfSW_AgWH' ./Experiment002/test*.m
#rename 'NtSW_SdWH' 'PfSW_AxWH' ./Experiment003/test*.m
#rename 'NtSW_SdWH' 'PrSW_AgWH' ./Experiment004/test*.m


