(defproject veggie-lunch "0.1.0-SNAPSHOT"
  :description "A Slack command integration to help manage the vegetarian lunch orders for our team"
  :url "http://example.com/FIXME"
  :license {:name "MIT License"
            :url "https://opensource.org/licenses/MIT"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [compojure "1.5.1"]
                 [http-kit "2.2.0"]
                 [ring/ring-devel "1.5.0"]
                 [ring/ring-core "1.5.0"]
                 [ring/ring-defaults "0.2.1"]
                 [org.clojure/java.jdbc "0.6.1"]
                 [org.xerial/sqlite-jdbc "3.15.1"]
                 [clj-time "0.12.2"]
                 [yesql "0.5.3"]
                 [selmer "1.10.2"]]
  
  ; Still working out the ideal options here:
  :main ^:skip-aot veggie-lunch.core
  ; :main veggie-lunch.core
  ; :aot [veggie-lunch.core]

  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}}
  :source-paths ["src" "src/veggie_lunch" "src/veggie_lunch/db"])
