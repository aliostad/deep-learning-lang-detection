#!/bin/bash
process-csv analyze crime_with_errors.csv
process-csv analyze-column crime_with_errors.csv year
process-csv analyze-column crime_with_errors.csv mont
process-csv analyze-column crime_with_errors.csv hour
process-csv analyze-column crime_with_errors.csv week
process-csv analyze-column crime_with_errors.csv SHIFT
process-csv analyze-column crime_with_errors.csv OFFENSE
process-csv analyze-column crime_with_errors.csv METHOD
process-csv analyze-column crime_with_errors.csv DISTRICT
process-csv analyze-column crime_with_errors.csv REPORT_DAT
process-csv analyze-dates crime_with_errors.csv REPORT_DAT
process-csv switch-dates crime_with_errors.csv year REPORT_DAT 3 /
process-csv switch-dates out-sd.csv mont REPORT_DAT 1 /
process-csv switch-const out-sd.csv SHIFT EVENING evening
process-csv switch-const out-sc.csv SHIFT E evening
process-csv switch-const out-sc.csv SHIFT MIDNIGHT midnight
process-csv switch-const out-sc.csv SHIFT M midnight
process-csv switch-const out-sc.csv SHIFT DAY day
process-csv switch-const out-sc.csv SHIFT D day
process-csv analyze-column out-sc.csv SHIFT
process-csv switch-const out-sc.csv OFFENSE HOMICIDE homicide
process-csv switch-const out-sc.csv OFFENSE H homicide
process-csv switch-const out-sc.csv OFFENSE "SEX ABUSE" "sex_abuse"
process-csv switch-const out-sc.csv OFFENSE "S" "sex_abuse"
process-csv switch-const out-sc.csv OFFENSE "sex abuse" "sex_abuse"
process-csv analyze-column out-sc.csv OFFENSE
process-csv switch-const out-sc.csv METHOD K knife
process-csv switch-const out-sc.csv METHOD KNIFE knife
process-csv switch-const out-sc.csv METHOD G gun
process-csv switch-const out-sc.csv METHOD GUN gun
process-csv switch-const out-sc.csv METHOD OTHER other
process-csv switch-const out-sc.csv METHOD OTHERS other
process-csv switch-const out-sc.csv METHOD O other
process-csv analyze-column out-sc.csv METHOD
process-csv fill-mean-class out-sc.csv SHIFT hour 2
