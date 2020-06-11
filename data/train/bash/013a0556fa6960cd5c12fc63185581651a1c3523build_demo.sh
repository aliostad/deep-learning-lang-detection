# Build the demo database.  Assumes 
# 1.  You start with a fresh database, i.e. you've run python build/build.py
# 2.  You have the virtual env activated

# $HeadURL: https://source.innectus.com/svn/innectus/trunk/loom/demo/build_demo.sh $
# $Id: build_demo.sh 2490 2010-11-18 04:47:56Z volkmuth $

inifile=$1
if [ $inifile"A" == "A" ]
then
  echo "Usage: $0 path/to/ini/inifile.ini"
  exit 1
fi
python load_org.py $inifile
python load_programs.py $inifile
python load_vendors.py $inifile
python load_reg.py $inifile regexample.sdf
python load_studies.py $inifile studies.txt
python load_reag.py $inifile reagexample.sdf
python load_sar.py $inifile sarexample.csv
python activate_modules.py $inifile
