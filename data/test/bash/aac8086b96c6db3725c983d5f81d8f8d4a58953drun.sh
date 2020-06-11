#!/bin/bash

export DATABASE_URL="user=admin host=localhost dbname=orc password=admin sslmode=disable"

export PORT="6543"

read -p "Clear the database [y/n]: " resetDB
read -p "Run the system with test data [y/n]: " loadTestData

if [[ "$resetDB" == "y" || "$resetDB" == "Y" || "$resetDB" == "yes" || "$resetDB" == "Yes" ]];
then resetDB=true
else resetDB=false
fi

if [[ "$loadTestData" == "y" || "$loadTestData" == "Y" || "$loadTestData" == "yes" || "$loadTestData" == "Yes" ]];
then loadTestData=true
else loadTestData=false
fi

go build && orc.exe -reset-db="$resetDB" -test-data="$loadTestData"
