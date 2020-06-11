package attributes

import (
	"github.com/ottemo/foundation/app/models"
	"github.com/ottemo/foundation/db"
	"github.com/ottemo/foundation/env"
)

// init makes package self-initialization routine
func init() {
	var _ models.InterfaceCustomAttributes = new(ModelCustomAttributes)
	var _ models.InterfaceExternalAttributes = new(ModelExternalAttributes)

	db.RegisterOnDatabaseStart(setupDB)
}

// setupDB prepares database for a package
func setupDB() error {

	if collection, err := db.GetCollection("custom_attributes"); err == nil {
		if err := collection.AddColumn("model", db.ConstTypeVarchar, true); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("collection", db.ConstTypeVarchar, true); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("attribute", db.ConstTypeVarchar, true); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("type", db.ConstTypeVarchar, false); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("required", db.ConstTypeBoolean, false); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("label", db.ConstTypeVarchar, true); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("group", db.ConstTypeVarchar, false); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("editors", db.ConstTypeVarchar, false); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("options", db.ConstTypeText, false); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("default", db.ConstTypeText, false); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("validators", db.ConstTypeVarchar, false); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("layered", db.ConstTypeBoolean, false); err != nil {
			return env.ErrorDispatch(err)
		}
		if err := collection.AddColumn("public", db.ConstTypeBoolean, false); err != nil {
			return env.ErrorDispatch(err)
		}

	} else {
		return env.ErrorDispatch(err)
	}

	return nil
}
