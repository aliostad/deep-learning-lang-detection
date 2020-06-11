package in.emor.scalahub

import org.specs._

class OrganizationSpec extends Specification {
  val organization = new Organization("github")

  "Organization" should {
    "show parameter" in {
      "show gravatar-id" in {
        organization.show("gravatar-id") mustEqual "61024896f291303615bcd4f7a0dcfb74"
      }
      "show company" in {
        organization.show("company") mustEqual "true"
      }
      "show name" in {
        organization.show("name") mustEqual "GitHub"
      }
      "show created-at" in {
        organization.show("created-at") mustEqual "2008-05-10T21:37:31-07:00"
      }
      "show location" in {
        organization.show("location") mustEqual "San Francisco, CA"
      }
      "show public-repo-count" in {
        organization.show("public-repo-count") mustEqual "21"
      }
      "show public-gist-count" in {
        organization.show("public-gist-count") mustEqual "0"
      }
      "show blog" in {
        organization.show("blog") mustEqual "https://github.com"
      }
      "show following-count" in {
        organization.show("following-count") mustEqual "0"
      }
      "show id" in {
        organization.show("id") mustEqual "9919"
      }
      "show type" in {
        organization.show("type") mustEqual "Organization"
      }
      "show permission" in {
        organization.show("permission") mustEqual "true"
      }
      "show followers-count" in {
        organization.show("followers-count") mustEqual "537"
      }
      "show login" in {
        organization.show("login") mustEqual "github"
      }
      "show email" in {
        organization.show("email") mustEqual "support@github.com"
      }
    }
  }
}
