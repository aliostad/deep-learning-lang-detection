resource "home" do
  resource "/index" do
    get url: "/", controller: "MainController", method: "root"
    post url: "/add", controller: "MainController", method: "add_url"
    put url: "/rm", controller: "MainController", method: "rm_url"
  end
  get url: "/", controller: "MainController", method: "root"
end

resource "homes" do
  get url: "/", controller: "MainController", method: "root"
end

get url: "/", controller: "MainController", method: "root"
get url: "/add", controller: "MainController", method: "add_url"
get url: "/rm", controller: "MainController", method: "rm_url"
get url: "/debug", controller: "MainController", method: "debug"
get url: "/hello", controller: "MainController", method: "hello"

# get url: "/image", controller: "MainController", method: "image"
get url: "/image/:image", controller: "MainController", method: "image"
get url: "img/:image", controller: "MainController", method: "image"

get url: "/get_cookies", controller: "MainController", method: "get_cookies"
get url: "/add_cookie", controller: "MainController", method: "add_cookie"

get "/err500", controller: "MainController", method: "err500"

get "/;/cookie", to: "MainController#root"
