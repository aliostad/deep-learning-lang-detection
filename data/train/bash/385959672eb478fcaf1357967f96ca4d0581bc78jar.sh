#! /bin/bash

cd ./bin
jar -cvf ../SampleLM.jar sample/module/SampleLoginModule.class sample/module/FileOperator.class sample/module/DigiSigner.class sample/module/FileReader.class sample/module/Digester.class sample/principal/SamplePrincipal.class
jar -cvf ../SampleAzn.jar sample/SampleAzn.class sample/MyCallbackHandler.class
jar -cvf ../SampleAction.jar sample/Printer.class
jar -cvf ../SampleServices.jar sample/Print.class sample/Services.class sample/Queue.class sample/Start.class sample/Stop.class sample/Status.class sample/ReadConfig.class sample/SetConfig.class sample/Restart.class sample/TopQueue.class
cd ..
echo "OK!"
