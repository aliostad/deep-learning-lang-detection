package services

import (
	"strconv"
	"strings"

	"github.com/osondoar/divvystat/models"
)

type LoadReporter struct {
	cacheService   *CacheService
	divvyApiClient DivvyApiClient
}

func NewLoadsService() *LoadReporter {
	var loadReporter LoadReporter
	loadReporter.cacheService = NewCacheService()

	return &loadReporter
}

func (lr LoadReporter) CurrentAveragedLoad(lastN int) (int, string) {
	divvyStatuses := lr.cacheService.getStatuses(lastN)
	statusesSize := len(divvyStatuses)
	var average int

	for i := 0; i < statusesSize-1; i++ {
		diff := lr.getStatusDiff(divvyStatuses[i], divvyStatuses[i+1])
		average += diff
	}

	if statusesSize > 1 {
		return (average / (statusesSize - 1)), divvyStatuses[0].ExecutionTime
	} else if statusesSize > 0 {
		return 0, divvyStatuses[0].ExecutionTime
	} else {
		return 0, ""
	}
}

func (lr LoadReporter) GetLoads(from int64, to int64) []models.LoadStatus { //map[string]int {
	loadStatuses := []models.LoadStatus{}
	encodedLoads := lr.cacheService.getEncodedLoads(from, to)

	for _, encodedLoad := range encodedLoads {
		parts := strings.Split(encodedLoad, "__")
		load, _ := strconv.Atoi(parts[1])
		loadStatuses = append(loadStatuses, models.LoadStatus{Time: parts[0], Load: load})
	}

	return loadStatuses
}

func (lr LoadReporter) getStatusDiff(dr1 models.StationsStatus, dr2 models.StationsStatus) int {
	var diffAcum int
	for stationId, station1 := range dr1.GetStations() {
		s2, ok := dr2.Station(stationId)
		if !ok {
			continue
		}
		// Available docks
		diff := s2.AvailableDocks - station1.AvailableDocks
		if diff < 0 {
			diff = -diff
		}

		diffAcum += diff
	}

	return diffAcum
}

func (ls LoadReporter) CalculateAndAddNewLoad() {
	lastN := 15
	load, now := ls.CurrentAveragedLoad(lastN)

	epoch := GetEpoch(now)
	encodedValue := now + "__" + strconv.Itoa(load)
	ls.cacheService.addLoad(epoch, encodedValue)

}

func (ls LoadReporter) UpdateStationStatuses() {
	ds := ls.divvyApiClient.getCurrentStatuses()
	ls.cacheService.addStatuses(ds)
}
