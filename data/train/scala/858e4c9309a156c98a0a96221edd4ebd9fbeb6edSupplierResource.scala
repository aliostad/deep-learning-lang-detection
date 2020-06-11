package fr.sogeti.rest

import io.vertx.scala.ext.web.{Router, RoutingContext}
import fr.sogeti.entities.Supplier
import fr.sogeti.rest.common.BaseHandler
import fr.sogeti.services.IEntityService

class SupplierResource(router : Router, supplierService : IEntityService[Supplier]) extends GenericService[Supplier](router, supplierService, classOf[Supplier]) {
  
  /**
   * manage a get request on suppliers to find a specific product
   * get the id parameter
   */
  router.get("/api/v1/suppliers/:id").produces(contentType).handler(new BaseHandler {
    override def handle( context : RoutingContext ) = findById(context)
  } )
  
  /**
   * manage a get request on suppliers to get all the products
   */
  router.get("/api/v1/suppliers").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = getAll(context)
  } )
  
  /**
   * manage a post request on suppliers to create a new one
   */
  router.post("/api/v1/suppliers").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = create(context)
  } )
  
  /**
   * manage a put request on suppliers to update a product 
   */
  router.put("/api/v1/suppliers").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = update(context)
  } )
  
  /**
   * manage a delete request on suppliers to update a product
   */
  router.delete("/api/v1/suppliers/:id").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = delete(context)
  } )
}