#Test script to test working order of other load scripts.  
#Choose NCI Thesaurus for the metadata and manifest interactive load.
echo ***Loading Terminologies****
echo ***Loading LexgridXML****
./LoadLgXML.sh -in /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/Automobiles.xml
echo ***Loading OBO****
./LoadOBO.sh -in /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/cell.obo
echo ***Loading OWL**** 
./LoadOWL.sh -in /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/sample.owl
echo ***Loading Owl2****
./LoadOWL2.sh -in /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/owl2/owl2-snippet-data.owl
echo ***Loading RRF****
./LoadUmlsBatch.sh -in file:///home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/sampleUMLS-AIR -s AIR
echo ***Loading NCI Meta***
./LoadMetaBatch.sh -in /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/sampleNciMeta
echo ***Loading Map****
./LoadMrMap.sh -inMap /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/mrmap_mapping/NCIt-to-ICD9mappings.MRMAP.RRF -inSat /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/mrmap_mapping/MRSAT_NCI2ICD9.RRF
echo ***Load Metadata***
./LoadMetadata.sh -in /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/metadata1.xml
echo ***Load NCI History***
./LoadNCIHistory.sh -in /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/Filtered_pipe_out_12f.txt -vf /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/SystemReleaseHistory.txt
echo ***Load UMLS History***
./LoadUMLSHistory.sh -in  /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/sampleNciMetaHistory
echo ***Load Manifest*****
./LoadManifest.sh -mf  /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/sample-manifest.xml
echo ***Load Pick List**** 
./LoadPickListDefinition.sh -in  /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/valueDomain/pickListTestData.xml
echo ***Load Value Set****
./LoadValueSetDefinition.sh -in  /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/valueDomain/VSDOnlyTest.xml
echo ***Load HL7 Mif****
./LoadMIFVocabulary.sh -in  /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/hl7MifVocabulary/DEFN=UV=VO=1189-20121121.coremif/
echo ***Load MedDRA****
./LoadMedDRA.sh -in  /home/m029206/LexEVS_6.1.0.RC1/test/resources/testData/medDRA
echo ***Done****
