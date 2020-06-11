#!/bin/bash
for i in $(seq 30)
do
  rails runner Tasks::SaveTask.execute\("60.1"\,"99.2"\)      # Siberia
  rails runner Tasks::SaveTask.execute\("23.8"\,"11.3"\)      # the Sahara
  rails runner Tasks::SaveTask.execute\("7.0"\,"-73.0"\)      # Piedequesta
  rails runner Tasks::SaveTask.execute\("39.0"\,"141.0"\)     # Iwate
  rails runner Tasks::SaveTask.execute\("31.0"\,"-100.0"\)    # Texas
  rails runner Tasks::SaveTask.execute\("43.7"\,"39.9"\)      # Sochi
  rails runner Tasks::SaveTask.execute\("69.4"\,"88.4"\)      # Norilsk
  rails runner Tasks::SaveTask.execute\("-34.0"\,"151.3"\)    # Sydney
  rails runner Tasks::SaveTask.execute\("51.6"\,"0.2"\)       # London
  rails runner Tasks::SaveTask.execute\("-1.5"\,"36.9"\)      # Nairobi
  #rails runner Tasks::SaveTask.execute\("-82.0"\,"-133.0"\)   # Antarctic
done
