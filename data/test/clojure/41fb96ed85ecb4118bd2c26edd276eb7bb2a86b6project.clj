(defproject foodship-restaurant "0.1.0-SNAPSHOT"
  :description "Foodship Restaurant: manage restaurants and menus"
  :license {:name "MIT"
            :url "https://opensource.org/licenses/MIT"}
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [environ "1.1.0"]
                 [http-kit "2.2.0"]
                 [metosin/compojure-api "1.1.11"]
                 [clj-time "0.14.0"]
                 [com.stuartsierra/mapgraph "0.2.1"]
                 [com.stuartsierra/component "0.3.2"]
                 [prismatic/schema "1.1.6"]]
  :plugins [[lein-environ "1.1.0"]
            [lein-cloverage "1.0.9"]]
  :repl-options {:init-ns user}
  :test-selectors {:default (complement :integration)
                   :integration :integration
                   :all (constantly true)}
  :main foodship-restaurant.core)
