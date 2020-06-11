package controllers

import soupy.Controller
import views.BaseView

class SearchManageController extends Controller {
  def index = {
    var list = List[SearchManagePanel]()
    list = new SearchManagePanel("/images/a.jpg", "积分兑换", true, "可以用积分兑换的相关产品", "") :: new SearchManagePanel("/images/a.jpg", "飞信群组", true, "相关的飞信群组", "") :: list
    val v = new SearchModuleView(list)
    out.print(v.render)
  }
}

class SearchManagePanel(var imageUrl: String,
                        var title: String,
                        var on: Boolean,
                        var description: String,
                        var previewUrl: String
                         ) extends BaseView {
  def render = {
    <tr>
      <td>
          <img src={imageUrl} class="icon"/>
        <span class="title">{title}</span>
        <span class="description">{description}</span>
      </td>
      <td>
        <div>
            <img src={previewUrl} class="previewImg"/>
        </div>
      </td>
    </tr>

  }
}

class SearchModuleView(var list: List[SearchManagePanel]) extends BaseView {
  def render = {
    <div class="modules">
        <link rel="stylesheet" type="text/css" href="/stylesheets/manage_search.css"/>
      <table>
        {list.map(_.render)}
      </table>
    </div>
  }
}