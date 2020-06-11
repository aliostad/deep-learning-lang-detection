(ns todo-list.core
  (:require [ring.adapter.jetty :as jetty]
            [ring.middleware.reload :refer [wrap-reload]]
            [compojure.core :refer [defroutes GET]]         ;;include both the functions defroutes and GET from core library
            [compojure.route :refer [not-found]]
            [ring.handler.dump :refer [handle-dump]]))

(defn about
  "Information about the website developer"
  [request]
  {:status 200
   :body "I am an awesome Clojure developer, well getting there..."
   :headers {}})

(defn welcome
  "A ring handler to respond with a simple welcome message"
  [request]
  {:status 200
   :body "<h1>Hello, Clojure World</h1>
     <p>Welcome to your first Clojure app, I now update automatically</p>
     <p>I now use defroutes to manage incoming requests</p> "
   :headers {}})

(defn bye
  "A ring handler to respond with a simple bye message"
  [request]
  {:status 200
   :body "<h1>Goodbye, Clojure World</h1>
     <p>See you later!</p> "
   :headers {}})

(defn request-info
  "View the information contained in the request, useful for debugging"
  [request]
  {:status 200
   :body (pr-str request)
   :headers {}})

(defn hello
  "A simple personalised greeting showing the use of variable path elements"
  [request]
  (let [name (get-in request [:route-params :name])]
    {:status 200
     :body (str "Hello " name ".  I got your name from the web URL")
     :headers {}}))

(def operands {"+" + "-" - "*" * ":" /})

(defn calculator
  "A very simple calculator that can add, divide, subtract and multiply.  This is done through the magic of variable path elements."
  [request]
  (let [a  (Integer. (get-in request [:route-params :a]))
        b  (Integer. (get-in request [:route-params :b]))
        op (get-in request [:route-params :op])
        f  (get operands op)]
    (if f
      {:status 200
       :body (str (f a b))
       :headers {}}
      {:status 404
       :body "Sorry, unknown operator.  I only recognise + - * : (: is for division)"
       :headers {}})))

(defroutes app
           (GET "/" [] welcome)                             ;;[] pass no ther argument to welcome, other than the request
           (GET "/bye" [] bye)
           (GET "/about" [] about)
           (GET "/request-info" [] request-info)
           (GET "/handle-dump" [] handle-dump)
           (GET "/hello/:name" [] hello)
           (GET "/calculator/:a/:op/:b" [] calculator)
           (not-found "<h1>This is not the page you are looking for</h1>
              <p>Sorry, the page you requested was not found!</p>"))

(defn -main                                                 ;;Using a - at the start of the -main function is a naming convention, helping you see which function is the entry point to your program. Leiningen also looks for this -main function by default when running your application.
  "A very simple web server using Ring & Jetty"
  [port-number]
  (jetty/run-jetty welcome
                   {:port (Integer. port-number)}))

(defn -dev-main
  "A very simple web server using Ring & Jetty that reloads code changes via the development profile of Leiningen"
  [port-number]
  (jetty/run-jetty (wrap-reload #'app)                      ;;#' instructs not to evaluate app, but just returns its definition. We want middleware to reload the function, rather than result of the function
                   {:port (Integer. port-number)}))


(defn welcomeIf
  "A ring handler to process all requests for the web server.  If a request is for something other than then an error message is returned"
  [request]
  (if (= "/" (:uri request))
    {:status 200
     :body "<h1>Hello, Clojure World</h1>
            <p>Welcome to your first Clojure app.</p>"
     :headers {}}
    {:status 404
     :body "<h1>This is not the page you are looking for</h1>
            <p>Sorry, the page you requested was not found!></p>"
     :headers {}}))

(defn welcomeSimple
  "A ring handler to process all requests sent to the webapp"
  [request]
  {:status 200
   :body "<h1>Hello, Clojure World</h1>  <p>Welcome to your first Clojure app.  This message is returned regardless of the request, sorry<p>"
   :headers {}})

(defn mainAnonymousFunction
  "A very simple web server using Ring & Jetty"
  [port-number]
  (jetty/run-jetty
    (fn [request] {:status 200
                   :body "<h1>Hello, Clojure World</h1>  <p>Welcome to your first Clojure app.  This message is returned regardless of the request, sorry</p>"
                   :headers {}})
    {:port (Integer. port-number)}))