#!/bin/bash

#Builds database

defaultEnv="prod"
env=${1:-$defaultEnv}

startTime=$(date +"%s")

echo "Build started at $( date )"

dir="$( cd "$( dirname "$0" )" && pwd )"
console=$dir"/../app/console --env=$env"

echo "Drop database schema"
php $console doctrine:schema:drop --force

echo "Create new schema"
php $console doctrine:schema:update --force

echo "Load System Types"
php $console comppi:build:systems

echo "Load Loctree"
php $console comppi:build:loctree

echo "Load SacCe maps"
php $console comppi:build:map sc

echo "Load SacCe interactions"
php $console comppi:build:interactions sc

echo "Load SacCe localizations"
php $console comppi:build:localizations sc

echo "Load SacCe name lookup table"
php $console comppi:build:namelookup sc

echo "Load Human maps"
php $console comppi:build:map hs

echo "Load Human interactions"
php $console comppi:build:interactions hs

echo "Load Human localizations"
php $console comppi:build:localizations hs

echo "Load Human name lookup table"
php $console comppi:build:namelookup hs

echo "Load Drosi maps"
php $console comppi:build:map dm

echo "Load Drosi interactions"
php $console comppi:build:interactions dm

echo "Load Drosi localizations"
php $console comppi:build:localizations dm

echo "Load Drosi name lookup table"
php $console comppi:build:namelookup dm

echo "Load C'Elegans maps"
php $console comppi:build:map ce

echo "Load C'Elegans interactions"
php $console comppi:build:interactions ce

echo "Load C'Elegans localizations"
php $console comppi:build:localizations ce

echo "Load C'Elegans name lookup table"
php $console comppi:build:namelookup ce

echo "Clean names"
php $console comppi:build:nameClean

echo "Load protein names (mainly for autocomplete support)"
php $console comppi:build:names

echo "Calculate Confidence Scores"
echo "disabled"
#php $console comppi:build:confidenceScores

endTime=$(date +"%s")
diffTime=$(($endTime - $startTime))

echo ""
echo "Build completed"
echo "Elapsed time:"
date -u -d @"$diffTime" +'%-Hh %-Mm %-Ss'
