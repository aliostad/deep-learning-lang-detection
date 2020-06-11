package org.unsane.spirit.news
package snippet

import model.Config
import net.liftweb.http.S

/**
 * Routing the user either to the New cool schedule or to the old uncool schedule.
 * Depends on if the panic switch was used.
 * @todo Don't know if this is the way to do it, but it works?!
 */
class ScheduleDispatch extends Config {

  loadChangeableProps("schedule") match {
    case "new" => S.redirectTo("/schedule")
    case "old" => S.redirectTo("/stundenplan/index")
    case _ => S.redirectTo("/")
  }

  def render = {

    <div></div>
  }

}

class OldScheduleDispatch extends Config {

  loadChangeableProps("schedule") match {
    case "new" => S.redirectTo("/schedule")
    case "old" =>
    case _ => S.redirectTo("/")
  }

  def render = {

    <div></div>
  }

}
