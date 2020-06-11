(defproject rated "0.1.0-SNAPSHOT"
  :description "Micro API used to manage rate limits"
  :url "https://github.com/T0aD/rated/"
  :min-lein-version "2.0.0"
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [org.clojure/tools.cli "0.3.5"]
                 [compojure "1.5.1"]
                 [ring/ring-defaults "0.2.1"]
                 [cheshire	"5.4.0"]
                 [http-kit "2.2.0"]
;                 [org.clojure/tools.logging "0.3.1"]
		 ]
  :plugins [[lein-ring "0.9.7"]]
;  :ring {:handler rated.handler/app}
  :main rated.server
  :profiles
  {:dev {:dependencies [[javax.servlet/servlet-api "2.5"]
                        [ring/ring-mock "0.3.0"]
			                  [cheshire	"5.4.0"]
;  			                [org.clojure/core.async "0.2.395"]

]}})
