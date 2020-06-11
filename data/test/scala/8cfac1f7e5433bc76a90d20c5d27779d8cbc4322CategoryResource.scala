package fr.sogeti.rest

import fr.sogeti.entities.Category
import fr.sogeti.rest.common.BaseHandler
import io.vertx.scala.ext.web.{Router, RoutingContext}
import fr.sogeti.services.IEntityService

class CategoryResource(router : Router, categoryService : IEntityService[Category]) extends GenericService[Category](router, categoryService, classOf[Category]){
  /**
   * manage a get request on products to find a specific product
   * get the id parameter
   */
  router.get("/api/v1/categories/:id").produces(contentType).handler(new BaseHandler {
    override def handle( context : RoutingContext ) = findById(context)
  } )
  
  /**
   * manage a get request on products to get all the products
   */
  router.get("/api/v1/categories").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = getAll(context)
  } )
  
  /**
   * manage a post request on products to create a new one
   */
  router.post("/api/v1/categories").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = create(context)
  } )
  
  /**
   * manage a put request on products to update a product 
   */
  router.put("/api/v1/categories").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = update(context)
  } )
  
  /**
   * manage a delete request on products to update a product
   */
  router.delete("/api/v1/categories/:id").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = delete(context)
  } )
}