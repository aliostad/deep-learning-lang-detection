(defproject web-crawler "0.1.0-SNAPSHOT"
  :description "Web clawler"
  :url "https://github.com/ikhilko/web-crawler"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.6.0"]
                 [clj-http "1.0.1"]                         ; execute request to url and manage all responce data
                 [clojurewerkz/urly "1.0.0"]                ; work with different url parts (urls sugar)
                 [enlive "1.1.5"]]                          ; can parse html and run selectors on dom
  :main ikhilko.web-crawler.core)
