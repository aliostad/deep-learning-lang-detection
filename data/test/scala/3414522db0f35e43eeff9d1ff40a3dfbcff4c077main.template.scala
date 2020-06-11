
package views.html

import play.templates._
import play.templates.TemplateMagic._

import play.api.templates._
import play.api.templates.PlayMagic._
import models._
import controllers._
import java.lang._
import java.util._
import scala.collection.JavaConversions._
import scala.collection.JavaConverters._
import play.api.i18n._
import play.core.j.PlayMagicForJava._
import play.mvc._
import play.data._
import play.api.data.Field
import play.mvc.Http.Context.Implicit._
import views.html._
/**/
object main extends BaseScalaTemplate[play.api.templates.HtmlFormat.Appendable,Format[play.api.templates.HtmlFormat.Appendable]](play.api.templates.HtmlFormat) with play.api.templates.Template1[String,play.api.templates.HtmlFormat.Appendable] {

    /**/
    def apply/*1.2*/(message: String):play.api.templates.HtmlFormat.Appendable = {
        _display_ {

Seq[Any](format.raw/*1.19*/("""
<!DOCTYPE html>

<html>
    <head>
        <title>CMS Admin Page</title>
        <link rel="stylesheet" media="screen" href=""""),_display_(Seq[Any](/*7.54*/routes/*7.60*/.Assets.at("stylesheets/main.css"))),format.raw/*7.94*/("""">
        <link rel="shortcut icon" type="image/png" href=""""),_display_(Seq[Any](/*8.59*/routes/*8.65*/.Assets.at("images/favicon.png"))),format.raw/*8.97*/("""">
        <script src=""""),_display_(Seq[Any](/*9.23*/routes/*9.29*/.Assets.at("javascripts/jquery-1.9.0.min.js"))),format.raw/*9.74*/("""" type="text/javascript"></script>
    </head>
    <body>
	    <h1>"""),_display_(Seq[Any](/*12.11*/message)),format.raw/*12.18*/("""</h1>
    	<fieldset>
    	<legend><h2>Select the following links for service:</h2></legend>
	    <ul>
		    <li>
	    <a href = "/manageUser">Manage User Class</a>
    		</li>
    		<li>
	    <a href = "/manageEventType">Manage Event Type</a>
		</li>
    		<li>
	    <a href = "/relationship">Manage Agency-EventType Relationship</a>
    		</li>
    		<li>
	    <a href = "/bug">Report the bug</a>   
    		</li>
    		<li>
	    <a href = "/logout">Log out</a>
		</li>
	    
  	  </ul>
	  </fieldset>
	  
    </body>
</html>
"""))}
    }
    
    def render(message:String): play.api.templates.HtmlFormat.Appendable = apply(message)
    
    def f:((String) => play.api.templates.HtmlFormat.Appendable) = (message) => apply(message)
    
    def ref: this.type = this

}
                /*
                    -- GENERATED --
                    DATE: Mon Oct 20 14:39:10 CST 2014
                    SOURCE: /Users/ruanpingcheng/Desktop/CMS/app/views/main.scala.html
                    HASH: 0cfc395207c60109740386e93b7100c9fb2e5e95
                    MATRIX: 773->1|884->18|1046->145|1060->151|1115->185|1211->246|1225->252|1278->284|1338->309|1352->315|1418->360|1522->428|1551->435
                    LINES: 26->1|29->1|35->7|35->7|35->7|36->8|36->8|36->8|37->9|37->9|37->9|40->12|40->12
                    -- GENERATED --
                */
            