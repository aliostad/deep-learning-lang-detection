(defproject mversioner "0.1.0-SNAPSHOT"
  :description "Manage Fresh8 autoscalable services like a gentleman"
  :url "https://github.com/lbn/mversioner"
  :license {:name "MIT"
            :url "https://github.com/lbn/mversioner/blob/master/LICENSE"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [compojure "1.5.2"]
                 [ring/ring-json "0.4.0"]
                 [org.clojure/core.incubator "0.1.0"]
                 [org.clojure/tools.logging "0.2.3"]
                 [org.apache.jclouds/jclouds-all "2.0.1"]
                 [com.google.api-client/google-api-client "1.22.0"]
                 [com.google.apis/google-api-services-compute "v1-rev139-1.22.0"]
                 [levand/immuconf "0.1.0"]]

  :plugins [[lein-ring "0.7.1"]]
  :ring {:handler mversioner.core/app}
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
