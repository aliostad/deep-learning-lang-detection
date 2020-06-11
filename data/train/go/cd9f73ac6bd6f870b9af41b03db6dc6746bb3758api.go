package post

import (
	"github.com/ottemo/foundation/api"
	"github.com/ottemo/foundation/db"
	"github.com/ottemo/foundation/env"

	"github.com/ottemo/foundation/app/models"
	"github.com/ottemo/foundation/app/models/blog/post"
)

func setupAPI() error {
	service := api.GetRestService()

	service.GET("blog/posts", APIListPosts)
	service.GET("blog/post/:id", APIPostByID)
	service.GET("blog/posts/attributes", APIListPostAttributes)

	// admin
	service.POST("blog/post", api.IsAdminHandler(APICreateBlogPost))
	service.PUT("blog/post/:id", api.IsAdminHandler(APIUpdateByID))
	service.DELETE("blog/post/:id", api.IsAdminHandler(APIDeleteByID))

	return nil
}

// APIListPosts returns list of posts
func APIListPosts(context api.InterfaceApplicationContext) (interface{}, error) {
	collection, err := db.GetCollection(ConstBlogPostCollectionName)
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	// filters handle
	if err = models.ApplyFilters(context, collection); err != nil {
		return nil, env.ErrorDispatch(err)
	}

	// not allowing to see disabled articles if not admin
	if !api.IsAdminSession(context) {
		if err = collection.AddGroupFilter("and_published", "published", "=", true); err != nil {
			return nil, env.ErrorDispatch(err)
		}
	}

	// check "count" request
	if context.GetRequestArgument(api.ConstRESTActionParameter) == "count" {
		if count, err := collection.Count(); err == nil {
			return count, nil
		}
		return nil, env.ErrorDispatch(err)
	}

	result, err := collection.Load()
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	return result, nil
}

// APIPostByID returns post by id
func APIPostByID(context api.InterfaceApplicationContext) (interface{}, error) {
	blogPostID := context.GetRequestArgument("id")
	if blogPostID == "" {
		return nil, env.ErrorNew(ConstErrorModule, env.ConstErrorLevelAPI, "331e8869-8d6a-4603-8cf8-9a84266fdad1", "post id was not specified")
	}

	postModel, err := post.GetBlogPostModel()
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	if err = postModel.Load(blogPostID); err != nil {
		return nil, env.ErrorDispatch(err)
	}

	result := postModel.ToHashMap()
	var resultExtra = map[string]interface{}{
		"next": nil,
		"prev": nil,
	}
	result["extra"] = resultExtra

	// check for admin rights to see particular article
	if !api.IsAdminSession(context) && result["published"] == false {
		return nil, env.ErrorNew(ConstErrorModule, env.ConstErrorLevelAPI, "a3c29bd2-f4eb-4df2-bd75-722cb246def4", "no rights to see this post")
	}

	// Next / prev post
	collection, err := db.GetCollection(ConstBlogPostCollectionName)
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	// Next post
	if err = collection.ClearFilters(); err != nil {
		return nil, env.ErrorDispatch(err)
	}
	if err = collection.ClearSort(); err != nil {
		return nil, env.ErrorDispatch(err)
	}
	if err = collection.AddFilter("updated_at", ">", postModel.GetUpdatedAt()); err != nil {
		return nil, env.ErrorDispatch(err)
	}
	if err = collection.AddSort("updated_at", false); err != nil {
		return nil, env.ErrorDispatch(err)
	}
	if err = collection.SetLimit(0, 1); err != nil {
		return nil, env.ErrorDispatch(err)
	}
	if !api.IsAdminSession(context) {
		if err = collection.AddFilter("published", "=", true); err != nil {
			return nil, env.ErrorDispatch(err)
		}
	}

	posts, err := collection.Load()
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	if len(posts) > 0 {
		resultExtra["next"] = posts[0]
	}

	// Prev post
	if err = collection.ClearFilters(); err != nil {
		return nil, env.ErrorDispatch(err)
	}
	if err = collection.ClearSort(); err != nil {
		return nil, env.ErrorDispatch(err)
	}
	if err = collection.AddFilter("updated_at", "<", postModel.GetUpdatedAt()); err != nil {
		return nil, env.ErrorDispatch(err)
	}
	if err = collection.AddSort("updated_at", true); err != nil {
		return nil, env.ErrorDispatch(err)
	}
	if err = collection.SetLimit(0, 1); err != nil {
		return nil, env.ErrorDispatch(err)
	}
	if !api.IsAdminSession(context) {
		if err = collection.AddFilter("published", "=", true); err != nil {
			return nil, env.ErrorDispatch(err)
		}
	}

	posts, err = collection.Load()
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	if len(posts) > 0 {
		resultExtra["prev"] = posts[0]
	}

	return result, nil
}

// APIListPostAttributes returns a list of blog post attributes
func APIListPostAttributes(context api.InterfaceApplicationContext) (interface{}, error) {

	postModel, err := post.GetBlogPostModel()
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	return postModel.GetAttributesInfo(), nil
}

// APICreateBlogPost creates blog post by provided data
func APICreateBlogPost(context api.InterfaceApplicationContext) (interface{}, error) {
	requestData, err := api.GetRequestContentAsMap(context)
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	blogPostModel, err := post.GetBlogPostModel()
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	for attribute, value := range requestData {
		if err := blogPostModel.Set(attribute, value); err != nil {
			return nil, env.ErrorDispatch(err)
		}
	}

	if err = blogPostModel.Save(); err != nil {
		return nil, env.ErrorDispatch(err)
	}

	return blogPostModel.ToHashMap(), nil
}

// APIUpdateByID updates post by id
func APIUpdateByID(context api.InterfaceApplicationContext) (interface{}, error) {
	blogPostID := context.GetRequestArgument("id")
	if blogPostID == "" {
		return nil, env.ErrorNew(ConstErrorModule, env.ConstErrorLevelAPI, "f3ad6310-8b5b-428c-bfbd-107479d708f0", "post id was not specified")
	}

	requestData, err := api.GetRequestContentAsMap(context)
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	blogPostModel, err := post.GetBlogPostModel()
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	if err = blogPostModel.Load(blogPostID); err != nil {
		return nil, env.ErrorDispatch(err)
	}

	for attribute, value := range requestData {
		if err := blogPostModel.Set(attribute, value); err != nil {
			return nil, env.ErrorDispatch(err)
		}
	}

	if err = blogPostModel.Save(); err != nil {
		return nil, env.ErrorDispatch(err)
	}

	return blogPostModel.ToHashMap(), nil
}

// APIDeleteByID deletes post by id
func APIDeleteByID(context api.InterfaceApplicationContext) (interface{}, error) {

	// checking request context
	//-------------------------
	blogPostID := context.GetRequestArgument("id")
	if blogPostID == "" {
		return nil, env.ErrorNew(ConstErrorModule, env.ConstErrorLevelAPI, "2bc9a20e-8d44-4381-97f1-13774c041838", "post id was not specified")
	}

	// operation
	//-------------------------
	blogPostModel, err := post.GetBlogPostModel()
	if err != nil {
		return nil, env.ErrorDispatch(err)
	}

	if err = blogPostModel.SetID(blogPostID); err != nil {
		return nil, env.ErrorDispatch(err)
	}

	if err = blogPostModel.Delete(); err != nil {
		return nil, env.ErrorDispatch(err)
	}

	return "Delete Successful", nil
}
