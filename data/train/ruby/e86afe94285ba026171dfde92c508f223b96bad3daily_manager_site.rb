class DailyManagerSite < DailyManagerCore

  OPTIONS = {:where => "processing_lines.controller NOT LIKE 'Api1%'"}

  TOP = [
    {:controller => "PlacesController", :action => "show", :format => "HTML", :chart => true},
    {:controller => "PlacesController", :action => "show", :format => "MOBILE"},
    {:controller => "CitiesController", :action => "show", :format => "HTML"},
    {:controller => "CategoriesController", :action => "show", :format => "HTML", :chart => true},
    {:controller => "GuidesController", :action => "show", :format => "HTML"},
    {:controller => "UsersController", :action => "show",  :format => "HTML"},
  ]
  TOP_WITH_ALL = TOP + [{:chart => true}]

  def name
    :site
  end

end
