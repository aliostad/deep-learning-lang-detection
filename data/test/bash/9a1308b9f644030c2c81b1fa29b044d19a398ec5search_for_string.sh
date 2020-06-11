#!bin/bash

echo grep kris sample_file.txt
echo ==========================
grep kris sample_file.txt
echo


echo grep -i kris sample_file.txt 
echo ==============================
grep -i kris sample_file.txt
echo

echo grep [kK]ris sample_file.txt
echo ==============================
grep  [kK]ris sample_file.txt
echo

echo grep T[oO]mmy sample_file.txt
echo ==============================
grep T[oO]mmy sample_file.txt
echo

echo grep T[ioIO]mmy sample_file.txt
echo ==============================
grep T[ioIO]mmy sample_file.txt
echo


echo search for lines begin with kris
echo grep ^[kK]ris sample_file.txt
echo ==============================
grep ^[kK]ris sample_file.txt
echo

echo search for lines ending with kris
echo grep [kK]ris$ sample_file.txt
echo ==============================
grep [kK]ris$ sample_file.txt
echo

echo search all blank lines
echo grep ^$ sample_file.txt
echo ==============================
grep ^$ sample_file.txt
echo

echo -v inverts the search result , all lines which are not blank
echo grep -v ^$ sample_file.txt
echo ==============================
grep -v ^$ sample_file.txt
echo
