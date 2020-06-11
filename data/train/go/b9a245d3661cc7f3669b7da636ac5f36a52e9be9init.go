package config

import (
	"github.com/ottemo/foundation/api"
	"github.com/ottemo/foundation/db"
	"github.com/ottemo/foundation/env"
	"github.com/ottemo/foundation/impex"
)

// init makes package self-initialization routine
func init() {
	instance := &DefaultConfig{
		configValues:     make(map[string]interface{}),
		configTypes:      make(map[string]string),
		configValidators: make(map[string]env.FuncConfigValueValidator)}

	db.RegisterOnDatabaseStart(setupDB)
	db.RegisterOnDatabaseStart(instance.Load)

	api.RegisterOnRestServiceStart(setupAPI)

	if err := env.RegisterConfig(instance); err != nil {
		_ = env.ErrorDispatch(err)
	}

	if err := impex.RegisterImpexModel("Config", instance); err != nil {
		_ = env.ErrorDispatch(err)
	}
}

// setupDB prepares system database for package usage
func setupDB() error {
	collection, err := db.GetCollection(ConstCollectionNameConfig)
	if err != nil {
		return env.ErrorDispatch(err)
	}

	if err := collection.AddColumn("path", db.ConstTypeVarchar, true); err != nil {
		return env.ErrorDispatch(err)
	}
	if err := collection.AddColumn("value", db.ConstTypeText, false); err != nil {
		return env.ErrorDispatch(err)
	}

	if err := collection.AddColumn("type", db.ConstTypeVarchar, false); err != nil {
		return env.ErrorDispatch(err)
	}

	if err := collection.AddColumn("editor", db.ConstTypeVarchar, false); err != nil {
		return env.ErrorDispatch(err)
	}
	if err := collection.AddColumn("options", db.ConstTypeText, false); err != nil {
		return env.ErrorDispatch(err)
	}

	if err := collection.AddColumn("label", db.ConstTypeVarchar, false); err != nil {
		return env.ErrorDispatch(err)
	}
	if err := collection.AddColumn("description", db.ConstTypeText, false); err != nil {
		return env.ErrorDispatch(err)
	}

	if err := collection.AddColumn("image", db.ConstTypeVarchar, false); err != nil {
		return env.ErrorDispatch(err)
	}

	return nil
}
