package jp.gr.java_conf.hangedman.seat

import org.scalatra._
import org.scalatra.json._
import org.json4s._
import scala.xml.{Text, Node}
import scalate.ScalateSupport

// seat infomation
case class SeatPos(x: Integer, y: Integer, info: String)

class ZasekihyoServlet extends ZasekihyoStack {

  protected implicit val jsonFormats: Formats = DefaultFormats

  private def displayPage(title:String, content:Seq[Node], scripts: Seq[String]) 
    = Template.page(title, content, scripts)

  private def stringToIntIgnoreError(target: String): Integer = {
    try {
	target.toInt
    } catch {
	case e:Throwable => 0
    }
  }

  get("/") {
    <html>
      <body>
        <h1>Hello, world!</h1>
	Say <a href="hello-scalate">hello to Scalate</a>.
      </body>
    </html>
  }

  get("/manage") {
    displayPage("管理用ページ",
    <p>管理用ページ</p>
    <br/>
    <p>下の方にある設定項目から座席表の情報を入力してください</p>
    <br/>
    <div id="container"></div>
    <br/>
    <form id='the-form' action={url("/manage")} method='POST'>
    行: <input name="row" type='text'/><br/> 	
    列: <input name="col" type='text'/><br/> 	
    <input type='submit'/>
    </form>
    ,
    Seq("/assets/js/jquery-2.1.3.min.js",
	"/assets/js/highcharts.js",
	"/assets/js/modules/heatmap.js",
	"/assets/js/modules/exporting.js",
	"/assets/js/seat.js",
	"/assets/js/ajax.js")
  )}

  post("/manage") {

    contentType = formats("json")

    (params("row"), params("col")) match {

      case (row:String, col:String) => {

	var list = List[Any]()

	for ( j <- 0 to stringToIntIgnoreError(row);
	      k <- 0 to stringToIntIgnoreError(col)) {
	    // => List(List(1, 2), 3, 4, 5)
	    list = List(j, k, 10) :: list
	}

	Extraction.decompose(
	  list
	)
      }
    }
  }
}

object Template {

  def page(title:String, content:Seq[Node], scripts: Seq[String]) = {

    <html lang="ja">
      <head>
        <title>{ title }</title>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="" />
        <meta name="author" content="" />

        <!-- Le styles -->

        <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]>
          <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
      </head>

      <body>
           
	  { content }

          <!-- Le javascript
          ================================================== -->
          <!-- Placed at the end of the document so the pages load faster -->
          { (scripts) map { pth =>
            <script type="text/javascript" src={pth}></script>
          } }

      </body>
    </html>
  }
}
