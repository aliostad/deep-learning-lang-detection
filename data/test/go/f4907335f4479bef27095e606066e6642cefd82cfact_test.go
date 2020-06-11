package data

import (
	"testing"

	"github.com/corpseware/solomon/utility"
	"github.com/stretchr/testify/assert"
)

func TestFactCreate(t *testing.T) {
	assertion := getTestAsserter(t)
	factManager := getMockedFactManager(assertion)
	fact := utility.NewFact(TestFact)
	err := factManager.Create(fact)
	assertion.Nil(err)
}

func TestFactPurge(t *testing.T) {
	assertion := getTestAsserter(t)
	factManager := getMockedFactManager(assertion)
	err := factManager.Purge()
	assertion.Nil(err)
}

func TestFactRead(t *testing.T) {
	assertion := getTestAsserter(t)
	factManager := getMockedFactManager(assertion)
	fact, err := factManager.Read(TestFact)
	assertSuccess(assertion, fact, err)
}

func TestFactReadError(t *testing.T) {
	assertion := getTestAsserter(t)
	graphMock := new(MockedErrorGraphManager)
	factManager := CreateFactManager(graphMock)
	assertion.NotNil(factManager)
	fact, err := factManager.Read(TestFact)
	assertFail(assertion, fact, err)
}

func TestFactUpdate(t *testing.T) {
	assertion := getTestAsserter(t)
	factManager := getMockedFactManager(assertion)
	err := factManager.Update(utility.NewFact(TestFact))
	assertSuccessfulChange(assertion, err)
}

func TestFactDelete(t *testing.T) {
	assertion := getTestAsserter(t)
	factManager := getMockedFactManager(assertion)
	err := factManager.Delete(utility.NewFact(TestFact))
	assertion.Nil(err)
}

func getMockedFactManager(assertion *assert.Assertions) *FactDataManager {
	graphMock := new(MockedGraphManager)
	graphMock.mockResult = utility.Fact{}
	factManager := CreateFactManager(graphMock)
	assertion.NotNil(factManager)
	return factManager
}
