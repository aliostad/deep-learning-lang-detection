(defproject webmarks "0.3.0-SNAPSHOT"
  :description "Manage bookmarks with tags."
  :url "http://github.com/manuelp/webmarks"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :plugins [[lein-marginalia "0.7.1"]
            [lein-ring "0.7.5"]]
  :dependencies [[org.clojure/clojure "1.4.0"]
                 [cheshire "4.0.1"]
                 [ring "1.1.6"]
                 [compojure "1.1.3"]
                 [enlive "1.0.1"]
                 [clj-time "0.4.4"]
                 [com.cemerick/friend "0.1.2"]
                 [org.clojure/java.jdbc "0.2.3"]
                 [postgresql/postgresql "9.1-901-1.jdbc4"]]
  :ring {:handler webmarks.web/routes}
  :main webmarks.web)