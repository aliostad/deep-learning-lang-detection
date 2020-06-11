package in.emor.scalahub

import org.specs._

class ReposSpec extends Specification {
  val repos = new Repos("schacon", "grit")
  "Repos" should {
    "show parameter" in {
      "show has-downloads" in {
        repos.show("has-downloads") mustEqual "true"
      }
      "show url" in {
        repos.show("url") mustEqual "https://github.com/schacon/grit"
      }
      "show forks" in {
        repos.show("forks") mustEqual "11"
      }
      "show homepage" in {
        repos.show("homepage") mustEqual "http://grit.rubyforge.org/"
      }
      "show created-at" in {
        repos.show("created-at") mustEqual "2008-04-18T16:14:24-07:00"
      }
      "show fork" in {
        repos.show("fork") mustEqual "true"
      }
      "show has-wiki" in {
        repos.show("has-wiki") mustEqual "true"
      }
      "show watchers" in {
        repos.show("watchers") mustEqual "113"
      }
      "show size" in {
        repos.show("size") mustEqual "4104"
      }
      "show private" in {
        repos.show("private") mustEqual "false"
      }
      "show name" in {
        repos.show("name") mustEqual "grit"
      }
      "show owner" in {
        repos.show("owner") mustEqual "schacon"
      }
      "show open-issues" in {
        repos.show("open-issues") mustEqual "0"
      }
      "show description" in {
        repos.show("description") mustEqual "Grit is a Ruby library for extracting information from a git repository in an object oriented manner - this fork tries to intergrate as much pure-ruby functionality as possible"
      }
      "show has-issues" in {
        repos.show("has-issues") mustEqual "true"
      }
      "show pushed-at" in {
        repos.show("pushed-at") mustEqual "2010-05-05T15:28:38-07:00"
      }
    }
  }
}
