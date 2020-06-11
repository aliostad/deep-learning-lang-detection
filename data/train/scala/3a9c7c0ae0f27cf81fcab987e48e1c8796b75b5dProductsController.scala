package controllers

import play.api._
import play.api.mvc._
import play.api.data._
import play.api.data.Forms._
import play.api.data.validation.Constraints._
import models.Product
import play.api.data.format.Formats._

object ProductsController extends Controller {

  val productForm = Form(
    single(
      "price" -> of[Double]
    )
  )

  def list = Action {
    Ok(views.html.products.list(Product.all()))
  }

  def manageList = Action {
    Ok(views.html.products.manageList(Product.all()))
  }

  def detail(id: Int) = Action {
    Ok(views.html.products.detail(Product.getById(id), productForm))
  }

  def manage(id: Int) = Action {
    Ok(views.html.products.manage(Product.getById(id), productForm))
  }

  def search(key: String, value: String) = Action {
    println("key: " + key + ", value: " + value)
    val results = Product.searchByKeyValue(key, value)
    println(results)
    //stockNumber: String, manufacturer: String, modelNumber: String, category: String, descriptionAttribute: String, descriptionValue: String
    Ok(views.html.products.list(results))
  }


  def update = Action { implicit request =>
    productForm.bindFromRequest.fold(
      //error => BadRequest(views.html.products.detail(Product.getById(id), productForm)),
      error => BadRequest(views.html.products.list(Product.all())),
      {
        case (price) => {
          Product.update(price)
          //Redirect(routes.ProductsController.detail(Product.getById(id), productForm))
          Redirect(routes.OrdersController.list())
        }
      }
    )
  }


}
