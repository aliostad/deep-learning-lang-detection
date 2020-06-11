#! /bin/sh

if [ "$USER"X != "jenkinsX" ]; then
	modelName="GVCMovieTests"
	modelPath=${PROJECT_DIR}/Resources/${modelName}

	outDir=${PROJECT_DIR}/${PROJECT_NAME}Tests/${modelName}
	outMachineDir=$outDir/_

	if [ ! -d ${modelPath}.xcdatamodeld ]; then
		echo "Could not find ${modelPath}.xcdatamodeld"
		exit
	fi

	modelVersion=${modelName}.xcdatamodel
	if [ -e ${modelPath}.xcdatamodeld/.xccurrentversion ]; then
		modelVersion="`cat ${modelPath}.xcdatamodeld/.xccurrentversion | grep xcdatamodel | sed 's/[[:blank:]]*<[^>]*>//g'`"
	fi

	if [ ! -d "${modelPath}.xcdatamodeld/${modelVersion}" ]; then
		echo "Could not find version ${modelPath}.xcdatamodeld/${modelVersion}"
		exit
	fi

	if [ ! -d $outDir ]; then
		mkdir $outDir
	fi

	if [ ! -d $outMachineDir ]; then
		mkdir $outMachineDir
	fi

	mogenerator \
		-m "${modelPath}.xcdatamodeld/${modelVersion}" \
		--template-var arc=true \
		--includeh ${outDir}/${modelName}Model.h \
		--base-class GVCManagedObject \
		--base-class-import "<GVCCoreData/GVCCoreData.h>" \
		--machine-dir $outMachineDir \
		--human-dir $outDir
fi
