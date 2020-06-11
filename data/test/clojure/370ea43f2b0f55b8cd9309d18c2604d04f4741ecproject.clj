(defproject ike/ike.gradleui "0.1.0-SNAPSHOT"
  :description "Local CI server to manage Gradle projects."
  :url "https://github.com/ikelabs/ike.gradleui"
  :license {:name "Apache License, Version 2.0"
            :url "http://www.apache.org/licenses/LICENSE-2.0.html"}

  :repositories [["jcenter" "https://jcenter.bintray.com"]]

  :dependencies [[org.clojure/clojure "1.6.0"]
                 [org.clojure/tools.logging "0.3.1"]
                 [org.clojure/core.async "0.1.346.0-17112a-alpha"]
                 [org.clojure/data.json "0.2.5"]

                 ;; component
                 [com.stuartsierra/component "0.2.2"]

                 ;; ring
                 [ring/ring-core "1.3.2"]
                 [http-kit "2.1.19"]
                 [compojure "1.3.1"]

                 ;; gradle
                 [org.gradle/gradle-tooling-api "2.2.1"]

                 ;; ike
                 [org.codehaus.groovy/groovy-all "2.3.9"]
                 [tools.ike/gradle-tooling "0.0.1"]]

  :main ike.gradleui
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}
             :dev {:dependencies [[org.clojure/tools.namespace "0.2.8"]]
                   :source-paths ["dev"]}})
