
python /data/array_tomography/ForSharmi/allen_SB_code/scripts/create_xml_from_tilespecs.py --inputStack ALIGNEDSTACK_DEC22_DAPI_1_CUTOUT_7566_19046 --outputDirectory ../processed/subvolume_chunk/ --sectionsPerChunk 100 --firstSection 700 --lastSection 800

python alignme_subvolume.py --chunkDirectory ../processed/subvolume_chunk/ --outputDirectory ../processed/subvolume_affinealignment/

python deletestack.py --stackName ALIGNEDSTACK_DEC22_DAPI_1_SUBVOLUME_AFFINE_7566_19046

rm ../processed/temp3 -rf

python create_json_from_xml.py --inputfile ../processed/subvolume_affinealignment/700-1900/intersection_Affine.xml --Owner Sharmishtaas --Project M270907_Scnn1aTg2Tdt_13 --outputStack ALIGNEDSTACK_DEC23_DAPI_1_SUBVOLUME_AFFINE_7566_19046 --outputDir ../processed/temp3 --inputStack ALIGNEDSTACK_DEC22_DAPI_1_CUTOUT_7566_19046


python create_views.py --inputStack ALIGNEDSTACK_DEC23_DAPI_1_SUBVOLUME_AFFINE_7566_19046 --outputDirectory ../processed/QC_every10_DEC23_SUBVOLUME_AFFINE --scale 0.5 --firstz 700 --lastz 1900 --skip 10




