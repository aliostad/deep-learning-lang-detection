(defproject bean_counter "0.1.0-SNAPSHOT"

  :description "A simple web application to help me manage my monthly budget"
  :url "http://example.com/FIXME"

  :dependencies [[org.clojure/clojure "1.8.0"]
                 [selmer "1.0.4"]
                 [markdown-clj "0.9.88"]
                 [ring-middleware-format "0.7.0"]
                 [metosin/ring-http-response "0.6.5"]
                 [bouncer "1.0.0"]
                 [org.webjars/bootstrap "4.0.0-alpha.2"]
                 [org.webjars/font-awesome "4.6.1"]
                 [org.webjars.bower/tether "1.1.1"]
                 [org.webjars/jquery "2.2.2"]
                 [org.clojure/tools.logging "0.3.1"]
                 [compojure "1.5.0"]
                 [ring-webjars "0.1.1"]
                 [ring/ring-defaults "0.2.0"]
                 [mount "0.1.10"]
                 [cprop "0.1.7"]
                 [org.clojure/tools.cli "0.3.3"]
                 [luminus-nrepl "0.1.4"]
                 [org.webjars/webjars-locator-jboss-vfs "0.1.0"]
                 [luminus-immutant "0.2.0"]
                 [luminus-log4j "0.1.3"]
                 [org.clojure/data.csv "0.1.3"]]

  :min-lein-version "2.0.0"

  :jvm-opts ["-server" "-Dconf=.lein-env"]
  :source-paths ["src/clj"]
  :resource-paths ["resources"]

  :main bean-counter.core

  :plugins [[lein-cprop "1.0.1"]]
  :target-path "target/%s/"
  :profiles
  {:uberjar {:omit-source true
             
             :aot :all
             :uberjar-name "bean_counter.jar"
             :source-paths ["env/prod/clj"]
             :resource-paths ["env/prod/resources"]}
   :dev           [:project/dev :profiles/dev]
   :test          [:project/test :profiles/test]
   :project/dev  {:dependencies [[prone "1.1.1"]
                                 [ring/ring-mock "0.3.0"]
                                 [ring/ring-devel "1.4.0"]
                                 [pjstadig/humane-test-output "0.8.0"]
                                 [midje "1.8.3"]
                                 [org.clojure/test.check "0.9.0"]]
                  :plugins      [[com.jakemccrary/lein-test-refresh "0.14.0"]]
                  
                  
                  :source-paths ["env/dev/clj" "test/clj"]
                  :resource-paths ["env/dev/resources"]
                  :repl-options {:init-ns user}
                  :injections [(require 'pjstadig.humane-test-output)
                               (pjstadig.humane-test-output/activate!)]}
   :project/test {:resource-paths ["env/dev/resources" "env/test/resources"]}
   :profiles/dev {}
   :profiles/test {}})
