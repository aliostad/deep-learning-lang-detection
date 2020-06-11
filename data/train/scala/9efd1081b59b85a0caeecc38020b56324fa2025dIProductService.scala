/*
package services.managing_products

import com.google.inject.ImplementedBy
import models.manage_products.Product
import services.managing_products.impl.ProductService

import scala.concurrent.Future

/**
 * Created by Oudam on 10/14/2016.
 */
@ImplementedBy(classOf[ProductService])
trait IProductService {
  def insertNewProduct(product: Product): Future[Int]
  def getCategoryId(name: String): Future[Int]
  def getUserId(email: String): Future[Int]
  def findById(id: Long): Future[Product]
  def update(product: Product): Future[Int]
  def delete(id: Long): Future[Int]
  def list(): Future[Seq[Product]]
}
*/
