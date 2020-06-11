package springer_material_homepage

import DataProvider.testNameWithData

/**
 * Created by Siddharth on 7/24/15.
 */
class Search extends HomePage with HomePageSpecBehavior {
  val searchTestNameWithData = testNameWithData("searchItem", "src/resources/homePage.json")

  override def beforeAll() {
    driver manage() window() maximize()
    go to url
    pageTitle shouldBe "Home - SpringerMaterials"
  }

  "The search box in homepage" must "be present" in {
    waitForElement(searchId)
    click on searchId
  }
  println(searchTestNameWithData)
  it must behave like successfulSuggest(searchTestNameWithData)

  override def afterAll() {
    driver close()
  }
}