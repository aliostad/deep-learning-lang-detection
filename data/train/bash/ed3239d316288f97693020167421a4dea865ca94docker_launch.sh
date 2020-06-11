REF_DIR=/opt/data/reference
SAMPLE_DIR=/opt/data/sample
TOOLS_DIR=/opt/data/tools

DEBUG=0

if [ ${DEBUG} -eq 1 ]
then
    docker run --workdir=${SAMPLE_DIR}/work \
	-v ${REF_DIR}:${REF_DIR} \
	-v ${SAMPLE_DIR}:${SAMPLE_DIR} \
	-v ${TOOLS_DIR}:${TOOLS_DIR} \
	-i -t jkern/bcbio-dev:stable \
	/bin/bash
else
    docker run --workdir=${SAMPLE_DIR}/work \
	-v ${REF_DIR}:${REF_DIR} \
	-v ${SAMPLE_DIR}:${SAMPLE_DIR} \
	-v ${TOOLS_DIR}:${TOOLS_DIR} \
	-i -t jkern/bcbio-dev:stable \
	/usr/local/bin/bcbio_nextgen.py runfn organize_samples \
	${SAMPLE_DIR}/config/bcbio_system.yaml 
fi    

 
# What is the right way to get a JSON file of args?
# /usr/local/bin/bcbio_nextgen.py runfn organize_samples
