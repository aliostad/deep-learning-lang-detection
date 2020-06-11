package fr.sogeti.rest

import io.vertx.scala.ext.web.{Router, RoutingContext}
import fr.sogeti.rest.common.BaseHandler
import fr.sogeti.entities.Product
import fr.sogeti.services.ProductService

class ProductResource(router : Router, productService : ProductService) extends GenericService[Product](router, productService, classOf[Product]){
  
  /**
   * manage a get request on products to find a specific product
   * get the id parameter
   */
  router.get("/api/v1/products/:id").produces(contentType).handler(new BaseHandler {
    override def handle( context : RoutingContext ) = findById(context)
  } )
  
  /**
   * manage a get request on products to get all the products
   */
  router.get("/api/v1/products").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = {
      val criterias = context.request.getParam("criterias")
      val idSupplier = context.request.getParam("idSupplier")
      val count = context.request.getParam("count")
      
      if( count.isDefined ){
        getCount(context)
      }else{
      
        if( idSupplier.isDefined ) {
           var entities = productService.findBySupplier(idSupplier.get.toInt)
           context.response.end( jsonHelper.toJson( entities, true ) )
        }else{
        
          if( criterias.isDefined ) {
            val entities = productService.findByCriterias(criterias.get)
            context.response.end( jsonHelper.toJson( entities , true ) )
          }else{
            getAll(context)
          }
        }
      }
      
    }
  } )
  
  /**
   * manage a post request on products to create a new one
   */
  router.post("/api/v1/products").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = create(context)
  } )
  
  /**
   * manage a put request on products to update a product 
   */
  router.put("/api/v1/products").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = update(context)
  } )
  
  /**
   * manage a delete request on products to update a product
   */
  router.delete("/api/v1/products/:id").produces(contentType).handler( new BaseHandler {
    override def handle( context : RoutingContext ) = delete(context)
  } )
  
}