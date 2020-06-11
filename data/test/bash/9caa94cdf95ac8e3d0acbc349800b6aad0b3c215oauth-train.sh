#!/bin/bash
# Train a prediction model from a CSV file
# Usage: oauth-train.sh ID DATA_LOCATION {MODEL_TYPE} {TRAINING_INSTANCES}

ID=$1
DATA_LOCATION=$2
MODEL_TYPE=$3
TRAINING_INSTANCES=$4
KEY=`cat googlekey`

if [ "$MODEL_TYPE" == "" ]; then
  MODEL_TYPE="classification"
fi

post_data="{\"id\":\"$ID\",
            \"storageDataLocation\":\"$DATA_LOCATION\",
            \"modelType\":\"$MODEL_TYPE\", \
            \"trainingInstances\": [ {$TRAINING_INSTANCES} ] }"

# Train the model.
java -cp ./oacurl-1.3.0.jar com.google.oacurl.Fetch -X POST \
-t JSON \
"https://www.googleapis.com/prediction/v1.5/trainedmodels?key=$KEY" <<< $post_data
echo