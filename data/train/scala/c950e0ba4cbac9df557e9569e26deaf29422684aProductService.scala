package services.managing_products.impl

import com.google.inject.Inject
import models.manage_products.Product
import models.manage_products.repositories.IProductRepo
import services.managing_products.IProductService

import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

/**
 * Created by Oudam on 10/14/2016.
 */
class ProductService @Inject() (repo: IProductRepo) extends IProductService {

  override def insertNewProduct(product: Product): Future[Int] = {
    try {
      repo.insertNewProduct(product)
    } catch {
      case _: Throwable => Future(0)
    }
  }

  override def getUserId(email: String): Future[Int] = {
    try {
      repo.getUserId(email)
    } catch {
      case _: Throwable => Future(0)
    }
  }

  override def getCategoryId(name: String): Future[Int] = {
    try {
      repo.getCategoryId(name)
    } catch {
      case _: Throwable => Future(0)
    }
  }

  override def list(): Future[Seq[Product]] = {
    try {
      repo.list()
    } catch {
      case _: Throwable => Future(null)
    }
  }
}
