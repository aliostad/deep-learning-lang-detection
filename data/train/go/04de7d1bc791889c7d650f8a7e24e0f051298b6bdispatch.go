package dispatch

import (
	"od3n/dispatchNode/objects"
	"od3n/dispatchNode/rankScore"
	"time"

	"github.com/satori/go.uuid"
)

//Dispatch method return an assignment
func Dispatch(delivery objects.Delivery, courierPool []objects.Courier, trafficStatus objects.TrafficStatus) objects.Assignment {
	//Map courierID and RankScore
	rankMap := make(map[string]float64)
	for _, value1 := range courierPool {
		rankMap[value1.ID] = rankScore.RankScore(delivery, value1, trafficStatus)
	}
	//Find best score courier
	var smallestScoreCourier string
	var smallestScore float64 = 99999999
	for key, value2 := range rankMap {
		if value2 < smallestScore {
			smallestScoreCourier = key
			smallestScore = value2
		}
	}
	//Create new assignment
	assignmentID := uuid.NewV4()
	assignment := objects.Assignment{ID: assignmentID.String(), DeliveryID: delivery.ID, CourierID: smallestScoreCourier, TimeStamp: time.Now()}
	return assignment
}
