package task

import (
	"github.com/server-forecaster/model/manager"
	"github.com/server-forecaster/model"
)

func UpdatePredictionResults() {
	model.OpenDB()
	matchManager := manager.CreateMatchManager()
	predictionManager := manager.CreatePredictionManager()
	predictions, err := predictionManager.GetPending()
	if err != nil {
		panic(err)
	}
	for _, prediction := range predictions {
		match := matchManager.GetByID(prediction.MatchID)
		predictionManager.UpdatePredictionResults(prediction, match)
	}
	matchManager.DB.Close()
}
