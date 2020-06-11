package com.raouf.productmock

import org.scalamock.scalatest.MockFactory
import org.scalatest.FlatSpec

class ProductMgmtTest extends FlatSpec with MockFactory {

  val prod1 = Product(12, "Headphones", 234)
  val prod2 = Product(12, "Headphones", 239)
  val prod3 = Product(12, "Headphones", 229)

  val productMock = mock[InventoryController]
  val productTest = new InventoryManager(productMock)

  "Product add " should "return new product with updated inventory" in {

    //set expectations
    (productMock.addInventory _).expects(5).returns(prod2)
    
    //run test
    val prod4 = productTest.manageInventory(5, true)
    assert(prod4.productQty === 239)

  }

  it should "return new product with reduced inventory" in {

    //set expectations    
    (productMock.subInventory _).expects(5).returns(prod3)

    //run test
    val prod5 = productTest.manageInventory(5, false)
    assert(prod5.productQty === 229)
  }

  //  it should "return error message when tried to "
}