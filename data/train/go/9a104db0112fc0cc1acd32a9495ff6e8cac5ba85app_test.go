package main

import (
	"fmt"
	"testing"

	mgo "gopkg.in/mgo.v2"
)

type LoadTestMock struct {
	LoadTests []LoadTest
}

func (l LoadTestMock) GetAllLoadTest(mongo *mgo.Session, collectionName string) []LoadTest {

	return l.LoadTests
}

func TestFindUniqueData(t *testing.T) {
	// create dummy LoadTest
	testObjects := struct {
		LoadTests []LoadTestMock
	}{
		LoadTests: []LoadTestMock{
			{
				LoadTests: []LoadTest{
					{DriverId: "1"},
					{DriverId: "1"},
					{DriverId: "2"},
					{DriverId: "2"},
					{DriverId: "3"},
					{DriverId: "4"},
					{DriverId: "5"},
					{DriverId: "5"},
					{DriverId: "9"},
				},
			},
			{
				LoadTests: []LoadTest{
					{DriverId: "1"},
					{DriverId: "1"},
					{DriverId: "2"},
					{DriverId: "3"},
					{DriverId: "5"},
					{DriverId: "9"},
				},
			},
			{
				LoadTests: []LoadTest{
					{DriverId: "1"},
					{DriverId: "1"},
					{DriverId: "2"},
					{DriverId: "3"},
					{DriverId: "5"},
					{DriverId: "9"},
					{DriverId: "9191"},
					{DriverId: "91912"},
					{DriverId: "91912"},
				},
			},
		},
	}

	for index, loadTest := range testObjects.LoadTests {
		for _, value := range loadTest.LoadTests {
			fmt.Printf("%+v, ", value.DriverId)
		}
		fmt.Println("Result")

		uniqueData := findUniqueData(loadTest.LoadTests)

		// getting only the id from struct LoadTest
		var DriverIdsResult []string
		for _, value := range uniqueData {
			DriverIdsResult = append(DriverIdsResult, value.DriverId)
		}
		fmt.Printf("uniqueData = %+v\n", DriverIdsResult)
		if !isAllUnique(uniqueData) {

			t.Errorf("Error :: data not unique at index = %v data Result = %+v\n", index, DriverIdsResult)
		}
	}

}

func isAllUnique(loadTests []LoadTest) bool {
	for i := 0; i < len(loadTests); i++ {
		for j := i + 1; j < len(loadTests); j++ {
			if loadTests[i].DriverId == loadTests[j].DriverId {
				return false
			}
		}
	}
	return true
}
