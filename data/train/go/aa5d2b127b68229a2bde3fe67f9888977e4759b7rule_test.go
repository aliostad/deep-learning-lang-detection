package data

import (
	"testing"

	"github.com/corpseware/solomon/utility"
)

func TestRuleCreate(t *testing.T) {
	assertion := getTestAsserter(t)
	ruleManager := getMockedRuleManager()
	err := ruleManager.Create(utility.Rule{})
	assertSuccessfulChange(assertion, err)
}

func TestRulePurge(t *testing.T) {
	assertion := getTestAsserter(t)
	ruleManager := getMockedRuleManager()
	err := ruleManager.Purge()
	assertion.Nil(err)
}

func TestRuleRead(t *testing.T) {
	assertion := getTestAsserter(t)
	ruleManager := getMockedRuleManager()
	rule, err := ruleManager.Read(TestRule)
	assertSuccess(assertion, rule, err)
}

func TestRuleReadError(t *testing.T) {
	assertion := getTestAsserter(t)
	graphMock := new(MockedErrorGraphManager)
	ruleManager := CreateRuleManager(graphMock)
	assertion.NotNil(ruleManager)
	rule, err := ruleManager.Read(TestRule)
	assertFail(assertion, rule, err)
}

func TestRuleUpdate(t *testing.T) {
	assertion := getTestAsserter(t)
	ruleManager := getMockedRuleManager()
	err := ruleManager.Update(utility.Rule{})
	assertSuccessfulChange(assertion, err)
}

func TestRuleDelete(t *testing.T) {
	assertion := getTestAsserter(t)
	ruleManager := getMockedRuleManager()
	err := ruleManager.Delete(utility.Rule{})
	assertion.Nil(err)
}

func getMockedRuleManager() *RuleDataManager {
	graphMock := new(MockedGraphManager)
	graphMock.mockResult = utility.Rule{}
	ruleManager := CreateRuleManager(graphMock)
	return ruleManager
}
