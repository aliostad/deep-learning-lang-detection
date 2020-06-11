package post

import (
	"github.com/ottemo/foundation/api"
	"github.com/ottemo/foundation/db"
	"github.com/ottemo/foundation/env"

	"github.com/ottemo/foundation/app/models"
	"github.com/ottemo/foundation/app/models/blog/post"
)

// init makes package self-initialization routine
func init() {
	blogPostInstance := new(DefaultBlogPost)
	var _ post.InterfaceBlogPost = blogPostInstance
	if err := models.RegisterModel(post.ConstModelNameBlogPost, blogPostInstance); err != nil {
		_ = env.ErrorDispatch(err)
	}

	db.RegisterOnDatabaseStart(setupDB)
	api.RegisterOnRestServiceStart(setupAPI)
}

// setupDB prepares system database for package usage
func setupDB() error {
	var err error

	collection, err := db.GetCollection(ConstBlogPostCollectionName)
	if err != nil {
		return env.ErrorDispatch(err)
	}

	if err = collection.AddColumn("identifier", db.ConstTypeVarchar, true); err != nil {
		return env.ErrorDispatch(err)
	}
	if err = collection.AddColumn("published", db.ConstTypeBoolean, true); err != nil {
		return env.ErrorDispatch(err)
	}
	if err = collection.AddColumn("title", db.ConstTypeVarchar, false); err != nil {
		return env.ErrorDispatch(err)
	}
	if err = collection.AddColumn("excerpt", db.ConstTypeText, false); err != nil {
		return env.ErrorDispatch(err)
	}
	if err = collection.AddColumn("content", db.ConstTypeText, false); err != nil {
		return env.ErrorDispatch(err)
	}
	if err = collection.AddColumn("created_at", db.ConstTypeDatetime, false); err != nil {
		return env.ErrorDispatch(err)
	}
	if err = collection.AddColumn("updated_at", db.ConstTypeDatetime, false); err != nil {
		return env.ErrorDispatch(err)
	}
	if err = collection.AddColumn("tags", "[]"+db.ConstTypeText, false); err != nil {
		return env.ErrorDispatch(err)
	}
	if err = collection.AddColumn("featured_image", db.ConstTypeVarchar, false); err != nil {
		return env.ErrorDispatch(err)
	}

	return nil
}
