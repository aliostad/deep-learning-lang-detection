package manager

import (
	"github.com/server-forecaster/model/entity"
)

type PredictionManager struct {
	BaseManager
}

func (manager PredictionManager) GetByMatch(matchId uint) ([]entity.Prediction, error) {
	predictions := []entity.Prediction{}
	err := manager.DB.Where("match_id = ?", matchId).Find(&predictions).Error
	return predictions, err
}

func (manager PredictionManager) GetPending() ([]entity.Prediction, error) {
	predictions := []entity.Prediction{}
	err := manager.DB.Where("is_pending = ?", true).Find(&predictions).Error
	return predictions, err
}

func (manager PredictionManager) UpdatePredictionResults(prediction entity.Prediction, match entity.Match) {
	if match.Status != "FINISHED" {
		return
	}
	isHit := prediction.AwayTeamGoals == match.AwayTeamGoals &&
		prediction.HomeTeamGoals == match.HomeTeamGoals
	manager.DB.Model(&prediction).Update("IsHit", isHit)
	manager.DB.Model(&prediction).Update(map[string]interface{}{"IsHit": isHit, "IsPending": false})
}

func CreatePredictionManager() PredictionManager {
	return PredictionManager{BaseManager: Create()}
}
