#!/bin/bash

# Load data that should be suitable for running a dev environment

LOAD_COMMAND="django-admin loaddata"
LOAD_SETTINGS="--ignorenonexistent"
PROJECT_DIR="livinglotsphilly"

$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/cms/fixtures/dev_cms.json

$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/lots/fixtures/dev_lots.json
$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/lots/fixtures/dev_files.json
$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/lots/fixtures/dev_notes.json
$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/lots/fixtures/dev_photos.json
$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/lots/fixtures/dev_actstream.json

$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/pathways/fixtures/dev_pathways.json

$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/steward/fixtures/dev_steward.json

$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/phillyorganize/fixtures/dev_phillyorganize.json

$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/phillydata_local/fixtures/dev_opa.json
$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/phillydata_local/fixtures/dev_owners.json
$LOAD_COMMAND $LOAD_SETTINGS $PROJECT_DIR/phillydata_local/fixtures/dev_violations.json
