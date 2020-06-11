(defproject com.beardandcode/users "0.1.3"
  :description "A library to manage and manipulate users for use with a webapp"
  :url "https://github.com/beardandcode/users"
  :license {:name "MIT"
            :url "http://opensource.org/licenses/MIT"}

  :min-lein-version "2.0.0"

  :plugins [[lein-ancient "0.6.7"]
            [jonase/eastwood "0.2.1"]
            [lein-bikeshed "0.2.0"]
            [lein-kibit "0.1.2"]]

  :dependencies [[org.clojure/clojure "1.7.0"]
                 [com.beardandcode/components "0.1.3"]
                 [com.beardandcode/forms "0.1.4"]]

  :source-paths ["src/clj"]
  :test-paths ["test/clj"]
  :resource-paths ["src"]

  :javac-options ["-target" "1.8" "-source" "1.8"]

  :aliases {"checkall" ["do" ["check"] ["kibit"] ["eastwood"] ["bikeshed"]]}
  
  :profiles {:dev {:dependencies [[org.clojure/tools.namespace "0.2.10"]
                                  [leiningen #=(leiningen.core.main/leiningen-version)]
                                  [im.chit/vinyasa "0.3.4"]
                                  [reloaded.repl "0.1.0"]

                                  ;; for tests
                                  [clj-webdriver "0.7.2"]
                                  [com.codeborne/phantomjsdriver "1.2.1"
                                   :exclusion [org.seleniumhq.selenium/selenium-java
                                               org.seleniumhq.selenium/selenium-server
                                               org.seleniumhq.selenium/selenium-remote-driver]]
                                  [org.seleniumhq.selenium/selenium-java "2.48.2"]

                                  ;; for test webapp
                                  [ch.qos.logback/logback-classic "1.1.3"]
                                  [compojure "1.4.0"]
                                  [hiccup "1.0.5"]
                                  [buddy/buddy-auth "0.8.1"]
                                  [ragtime "0.5.2"]]
                   :source-paths ["dev" "example/clj"]
                   :resource-paths ["test" "example"]}})
