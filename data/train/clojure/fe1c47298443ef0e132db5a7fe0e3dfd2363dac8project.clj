(defproject CarRepairShop "0.1.0-SNAPSHOT"
  :description "The simple clojure web application with wich you can connect to your Soundcloud account and manage your settings. This application is made using Clojure, MongoDB and Leiningen."
  :url "localhost:8080"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.5.1"]
                 [compojure "1.1.5"]
                 [ring/ring-core "1.2.0"]
                 [hiccup "1.0.4"]
                 [ring/ring-jetty-adapter "1.2.0"]
                 [congomongo "0.4.1"]
                 [amalloy/mongo-session "0.0.2"]
                 [lib-noir "0.7.0"]
                 [clj-time "0.6.0"]
                 [hiccup-bridge "1.0.0-SNAPSHOT"]]
  
  :main run.run)
