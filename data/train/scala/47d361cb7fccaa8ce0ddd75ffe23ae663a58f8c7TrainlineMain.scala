package trainline

import java.time.LocalDate
import java.time.format.DateTimeFormatter

import pages.{Homepage, TimetablePage}
import util.BaseFeatureSpec

class TrainlineMain extends BaseFeatureSpec {
  feature("To test the trainline website") {
    scenario("Exercise One") {

      Given("I am on a the trainline website")
      driver.manage().deleteAllCookies()
      driver.manage().window().maximize()

      go to "https://www.thetrainline.com/"

      When("I enter in the two stations and click submit")

      click on find(xpath(".//*[@id='master']/div[1]/div/button")).get.text
      searchField("originStation").value = "Brighton"

      searchField("destinationStation").value = "London"

      And("I click submit")

      clickOn("submitButton")

      Then("The timetable page will be visible")

      find(xpath(".//*[@id='tickets']/div/div[1]/table/thead/tr[1]/th[2]/div/div[1]")) shouldBe defined

    }

    scenario("Exercise 2") {

      Given("I am on a the trainline website")
      driver.manage().deleteAllCookies()
      driver.manage().window().maximize()

      go to "https://www.thetrainline.com/"

      find(xpath(pageTitle)) contains "Trainline"

      print(pageTitle)

      When("I enter in the two stations and click submit")

      click on find(xpath(".//*[@id='master']/div[1]/div/button")).get

      searchField("originStation").value = "Brighton"

      searchField("destinationStation").value = "London"

      And("I click submit")

      clickOn("submitButton")

      Then("The timetable will be visible")

      find(xpath(".//*[@id='master']/header/div/div/div[1]/a/i")) shouldBe defined
    }
  }

  scenario("Exercise 3") {

    Given("I am on a the trainline website")
    driver.manage().deleteAllCookies()
    driver.manage().window().maximize()

    go to "https://www.thetrainline.com/"

    When("I enter in the two stations and click submit")

    click on find(xpath(".//*[@id='master']/div[1]/div/button")).get

    searchField("originStation").value = "Brighton"

    searchField("destinationStation").value = "London"

    click on xpath(".//*[@id='journey-type-return']")

    click on xpath(".//*[@id='extendedSearchForm']/div[3]/div[1]/div/div[1]/button[2]")

    click on xpath(".//*[@id='extendedSearchForm']/div[3]/div[2]/div/div[1]/button[2]")

    //    find(xpath(".//*[@id='master']/header/div/button")) shouldBe defined

    And("I click submit")

    clickOn("submitButton")

    Then("The timetable will show tommorrow date")

    val dayFormat = DateTimeFormatter.ofPattern("E d")
    val day = LocalDate.now().plusDays(1).format(dayFormat)
    val monthFormat = DateTimeFormatter.ofPattern("MMM")
    val month = LocalDate.now().plusDays(1).format(monthFormat)
    val yearFormat = DateTimeFormatter.ofPattern("y")
    val year = LocalDate.now().plusDays(1).format(yearFormat)

    val expectedDay = day + "th " + month + " " + year

    val actualDate = find(xpath(".//*[@id='tickets']/div/div[1]/table/thead/tr[1]/th[2]/div/h3")).get.text

    println(expectedDay)
    actualDate shouldBe expectedDay
  }

  feature("To automate the trainline website") {
    scenario("Exercise 6") {

      Given("I am on a the trainline website")
      //      go to "https://www.thetrainline.com/"
      Homepage.goToWebsite()

      When("I enter in the two stations and click submit")

      //      searchField("originStation").value = "Brighton"
      Homepage.enterLocation("London" , "Brighton" )

      Then("The page title will be correct and the one way option deselected")
      Homepage.assertPagetitle()
//      Homepage.returnButton()
//      Homepage.tommorrowButton()
//      Homepage.nextDayButton()
      Homepage.selectNoOfPeople()
      And("I click submit")

      Homepage.submitButton()

      Then("The timetable will show tommorrow date")
      TimetablePage.outDateAssert(40)
      And("Check the number of adult is displayed on the webpage")
      TimetablePage.checkNoOfAdult()
    }
  }
  feature("To automate the trainline website") {
    scenario("Exercise 7") {

      Given("I am on a the trainline website")
      Homepage.goToWebsite()

      When("I enter in the two stations and click submit")
      Homepage.enterLocation("London" , "Brighton" )

      Then("The page title will be correct and the one way option deselected")
      Homepage.assertPagetitle()
//      Homepage.returnButton()
//      Homepage.tommorrowButton()
//      Homepage.nextDayButton()
      Homepage.selectNoOfPeople()

      And("I click submit")
      Homepage.selectDate(40)
      Homepage.submitButton()

      Then("The timetable will show tommorrow date")
      TimetablePage.outDateAssert(40)
      And("Check the number of adult is displayed on the webpage")
      TimetablePage.checkNoOfAdult()
    }
  }
}

