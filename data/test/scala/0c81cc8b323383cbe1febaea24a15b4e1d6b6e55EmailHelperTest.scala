package se.crisp.signup4.unit.util

import org.scalatestplus.play._
import se.crisp.signup4.util.EmailHelper

class EmailHelperTest extends PlaySpec {

  def name = "kalle.anka"

  def domain = "ankeborg.se"

  def email = name + "@" + domain

  "EmailHelper" must {

    "abbreviate when not logged" in {
      EmailHelper.abbreviated(email, isLoggedIn = false) must equal("at " + domain)
    }

    "full address when logged" in {
      EmailHelper.abbreviated(email, isLoggedIn = true) must equal(email)
    }

    "manage empty string" in {
      EmailHelper.abbreviated("") must equal("")
    }

    "manage invalid email address" in {
      EmailHelper.abbreviated(name) must equal("")
    }

  }
}

