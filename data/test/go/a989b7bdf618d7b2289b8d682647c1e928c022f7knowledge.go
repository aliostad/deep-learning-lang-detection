package data

import (
	"github.com/corpseware/solomon/utility"
)

// KnowledgeDataManager manages the fact entity
type KnowledgeDataManager utility.KnowledgeDataManager

// CreateKnowledgeManager creates a new relationships manager
func CreateKnowledgeManager(collection utility.CollectionManager, factManager utility.CollectionManager,
	ruleManager utility.CollectionManager, actionManager utility.CollectionManager) *KnowledgeDataManager {
	return &KnowledgeDataManager{Collection: collection, FactManager: factManager,
		RuleManager: ruleManager, ActionManager: actionManager}
}

// AddThought adds a single thought to the graph
func (dataManager *KnowledgeDataManager) AddThought(thought utility.Thought) error {
	dataManager.RuleManager.Create(thought.Rule)
	err := dataManager.createFactsToRuleNodes(thought)
	if err != nil {
		return err
	}
	return dataManager.createRuleToActionsNodes(thought)
}

// GetActivated gets all the thoughts that have fired due to activation
func (dataManager *KnowledgeDataManager) GetActivated() ([]interface{}, error) {
	return dataManager.Collection.Query(GetActivatedKnowledge(), nil)
}

// Purge purges all knowledge but not working set memory
func (dataManager *KnowledgeDataManager) Purge() error {
	return dataManager.Collection.Purge()
}

// GetFacts gets the facts associated with a given rule by key. Get LHS
func (dataManager *KnowledgeDataManager) GetFacts(ruleKey string) ([]interface{}, error) {
	variables := map[string]interface{}{utility.RuleIDIndexKey: utility.GetTypeID(utility.RuleCollectionName, ruleKey)}
	return dataManager.Collection.Query(GetFactsByRule(), variables)
}

// GetActions gets the actions associated with a given rule by key. Get RHS
func (dataManager *KnowledgeDataManager) GetActions(ruleKey string) ([]interface{}, error) {
	variables := map[string]interface{}{utility.RuleIDIndexKey: utility.GetTypeID(utility.RuleCollectionName, ruleKey)}
	return dataManager.Collection.Query(GetActionsByRule(), variables)
}

func (dataManager *KnowledgeDataManager) createFactsToRuleNodes(thought utility.Thought) error {
	for _, fact := range thought.Facts {
		log.Debugf(utility.NewFactLog, fact.Key)
		err := dataManager.FactManager.Create(fact)
		if err != nil {
			return err
		}
		knowledge := utility.NewFactToRuleKnowledge(fact, thought.Rule)
		log.Debug(utility.CreateKnowledgeLog)
		log.Info(knowledge.Key)
		err = dataManager.Collection.Create(knowledge)
		if err != nil {
			return err
		}
	}
	return nil
}

func (dataManager *KnowledgeDataManager) createRuleToActionsNodes(thought utility.Thought) error {
	for _, action := range thought.Actions {
		log.Debugf(utility.NewActionLog, action.Key)
		err := dataManager.ActionManager.Create(action)
		if err != nil {
			return err
		}
		knowledge := utility.NewRuleToActionKnowledge(thought.Rule, action)
		log.Info(knowledge.Key)
		log.Debug(utility.CreateKnowledgeLog)
		err = dataManager.Collection.Create(knowledge)
		if err != nil {
			return err
		}
	}
	return nil
}
