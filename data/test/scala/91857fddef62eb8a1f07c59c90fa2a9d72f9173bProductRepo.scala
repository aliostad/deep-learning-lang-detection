package models.manage_products.repositories.impl

import com.google.inject.Inject
import models.manage_products._
import models.manage_products.repositories.IProductRepo
import play.api.db.slick.{ DatabaseConfigProvider, HasDatabaseConfig }
import slick.driver.JdbcProfile
import slick.driver.PostgresDriver.api._
import slick.lifted.TableQuery

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

/**
 * Created by Oudam on 10/14/2016.
 */
class ProductRepo @Inject() (dbConfigProvider: DatabaseConfigProvider) extends IProductRepo with HasDatabaseConfig[JdbcProfile] {
  val dbConfig = dbConfigProvider.get[JdbcProfile]
  val products = TableQuery[TProduct]
  val categories = TableQuery[TCategory]
  val users = TableQuery[TUser]

  private def filterQuery(id: Long): Query[TProduct, Product, Seq] = {
    products.filter(_.id === id)
  }

  override def insertNewProduct(product: Product): Future[Int] = {
    try {
      dbConfig.db.run(products += product)
    } catch {
      case _: Throwable => Future(0)
    }
  }

  override def getUserId(email: String): Future[Int] = {
    try {
      dbConfig.db.run(users.filter(_.username === email).result.head).map(_.user_id.get)
    } catch {
      case _: Throwable => Future(0)
    }
  }

  override def getCategoryId(name: String): Future[Int] = {
    try {
      dbConfig.db.run(categories.filter(_.name === name).result.head).map(_.prod_cate_id.get)
    } catch {
      case _: Throwable => Future(0)
    }
  }

  override def list(): Future[Seq[Product]] = {
    try {
      val query =
        for {
          product <- products if product != null
        } yield product
      dbConfig.db.run(query.result)
    } catch {
      case _: Throwable => Future(null)
    }
  }
}
