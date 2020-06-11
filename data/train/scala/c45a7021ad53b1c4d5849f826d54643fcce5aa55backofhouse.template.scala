
package views.html

import play.twirl.api._
import play.twirl.api.TemplateMagic._


     object backofhouse_Scope0 {
import models._
import controllers._
import play.api.i18n._
import views.html._
import play.api.templates.PlayMagic._
import java.lang._
import java.util._
import scala.collection.JavaConversions._
import scala.collection.JavaConverters._
import play.core.j.PlayMagicForJava._
import play.mvc._
import play.data._
import play.api.data.Field
import play.mvc.Http.Context.Implicit._

class backofhouse extends BaseScalaTemplate[play.twirl.api.HtmlFormat.Appendable,Format[play.twirl.api.HtmlFormat.Appendable]](play.twirl.api.HtmlFormat) with play.twirl.api.Template0[play.twirl.api.HtmlFormat.Appendable] {

  /**/
  def apply/*1.2*/():play.twirl.api.HtmlFormat.Appendable = {
    _display_ {
      {


Seq[Any](format.raw/*1.4*/("""

"""),_display_(/*3.2*/main("Manage the Sky Store.")/*3.31*/ {_display_(Seq[Any](format.raw/*3.33*/("""
"""),format.raw/*4.1*/("""<!-- Main jumbotron for a primary marketing message or call to action -->
<div class="jumbotron">
  <div class="container">
    <h1>Manage the Sky Store!</h1>
    <p>Make changes to the product line and view order statuses.</p>
  </div>
</div>

<div class="container">
    <h1>- <a href="/stock">Stock Control</a></h1>
    <h1>- <a href="/manage/orders">View Orders/Order Status</a></h1>
</div>

""")))}),format.raw/*17.2*/("""
"""))
      }
    }
  }

  def render(): play.twirl.api.HtmlFormat.Appendable = apply()

  def f:(() => play.twirl.api.HtmlFormat.Appendable) = () => apply()

  def ref: this.type = this

}


}

/**/
object backofhouse extends backofhouse_Scope0.backofhouse
              /*
                  -- GENERATED --
                  DATE: Thu Oct 01 17:37:49 BST 2015
                  SOURCE: /Users/rsp04/Websites/BSkyBProject/Website/app/views/backofhouse.scala.html
                  HASH: 33b7c0f332f6ac648c12be9e8d063afc84b5853a
                  MATRIX: 750->1|846->3|874->6|911->35|950->37|977->38|1404->435
                  LINES: 27->1|32->1|34->3|34->3|34->3|35->4|48->17
                  -- GENERATED --
              */
          