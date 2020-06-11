package frmr.scyig.webapp.snippet

import frmr.scyig.db._
import frmr.scyig.webapp.auth.AuthenticationHelpers._
import net.liftweb.common._
import net.liftweb.http._
import net.liftweb.sitemap._
import net.liftweb.sitemap.Loc._
import net.liftweb.util._
import net.liftweb.util.Helpers._

object CompDashboard {
  import SnippetHelpers._

  val menu = Menu.param[Competition](
    "Competition Dashboard",
    "Dashboard",
    idToCompetition,
    _.id.getOrElse("").toString
  ) / "competition" / * / "dashboard" >> validateCompetitionAccess
}

class CompMeta(competition: Competition) {
  import SnippetHelpers._

  def this(tuple: (Competition, Team)) = this(tuple._1)

  def name =
    "a *" #> competition.name &
    "a [href]" #> CompDashboard.menu.toLoc.calcHref(competition)

  def status =
    ".round-group" #> hideIfCompetitionIsnt(competition, InProgress) andThen
    ".competition-status-value *" #> competition.status.value &
    ".competition-round-numeral *" #> competition.round
}

class CompDashboard(competition: Competition) {
  import SnippetHelpers._

  def render = {
    ClearClearable andThen
    ".not-started-group" #> hideIfCompetitionIsnt(competition, NotStarted) &
    ".in-progress-group" #> hideIfCompetitionIsnt(competition, InProgress) &
    ".view-teams-entry" #> hideIfCompetitionIsnt(competition, InProgress) &
    ".manage-teams-entry" #> hideIfCompetitionIsnt(competition, NotStarted) andThen
    ".view-teams-entry" #> {
      "a [href]" #> TeamList.menu.toLoc.calcHref(competition)
    } &
    ".manage-teams-entry" #> {
      "a [href]" #> TeamList.menu.toLoc.calcHref(competition)
    } &
    ".manage-judges-entry" #> {
      "a [href]" #> JudgeList.menu.toLoc.calcHref(competition)
    } &
    ".begin-competition-entry" #> {
      "a [href]" #> CompSchedulerSetup.setupMenu.toLoc.calcHref(competition)
    } &
    ".advance-round-entry" #> {
      "a [href]" #> CompSchedulerSetup.setupMenu.toLoc.calcHref(competition)
    } &
    ".edit-round-entry" #> {
      "a [href]" #> CompSchedule.menu.toLoc.calcHref(competition)
    } &
    ".enter-scores-entry" #> {
      "a [href]" #> CompScoreEntry.menu.toLoc.calcHref(competition)
    }
  }
}
