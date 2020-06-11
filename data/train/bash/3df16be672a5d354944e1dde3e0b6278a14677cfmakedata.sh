#! /bin/sh

ROPTS="--vanilla --quiet"


echo "Importing Inspection data..."
R CMD BATCH $ROPTS "import_process/inspections/process_inspection_data.R"
echo "Importing Menupages data"
R CMD BATCH $ROPTS "import_process/menupages/process_mpdata.R"
echo "Importing IRS Income data"
R CMD BATCH $ROPTS "import_process/irs/process_irs_data.R"
echo "Importing Rat sightings data"
R CMD BATCH $ROPTS "import_process/rats/process_rats_data.R"

echo "Combining inspection and menupages data"
R CMD BATCH $ROPTS "prepare/combine_insp_mp.R"
echo "Cleaning cuisine categorizations"
R CMD BATCH $ROPTS "prepare/classify_cuisines.R"
echo "Combining restuarant and zip-code data"
R CMD BATCH $ROPTS "prepare/combine_insp_zipdata.R"



mv *.Rout ../logs
