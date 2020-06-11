class Routes < MiddlemanRoutes
  def self.proxy_routes
    # register_collection_proxy PostController, "post_proxy"
    register_collection_proxy ArticleController, "articles_proxy"
    register_collection_proxy PresentationController, "presentations_proxy"
    register_collection_proxy HangoutController, "hangouts_proxy"
    register_collection_proxy TagController, "tags_proxy"
  end
  
  def self.controller_routes 
    {
      "./source/index.html.haml" => { controller: MainController, action: "index" },
      "./source/pages/references.html.haml" => { controller: ReferenceController, action: "index" },
      "./source/pages/presentations.html.haml" => { controller: PresentationController, action: "index" },
      "./source/pages/articles.html.haml" => { controller: ArticleController, action: "index" },
      "./source/pages/hangouts.html.haml" => { controller: HangoutController, action: "index" },
      "./source/pages/missions.html.haml" => { controller: MissionController, action: "index" }
    }
  end
end


