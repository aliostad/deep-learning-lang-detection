package product_managing_test.repositories

import com.google.inject.ImplementedBy
import models.manage_products.{ Category, Product }

import scala.concurrent.Future

/**
 * Created by Oudam on 10/13/2016.
 */
@ImplementedBy(classOf[productTest])
trait IproductTest {
  def list(): Seq[Product]
  def insert(product: Product): Int
  def update(product: Product): Future[Int]
  def delete(id: Long): Future[Int]
  def findById(id: Long): Future[Product]
  def findByName(name: String): Future[Seq[Product]]
  def count(): Future[Int]

  def getCategoryId(name: String): Int
  def getLastCategoryId(): Future[Int]
  def getUserId(email: String): Int
  def addNewCategory(category: Category): Future[Int]

  def sum(x: Int, y: Int): Int
}

