(def project 'kakeibo)
(def version "0.1.0-SNAPSHOT")

(set-env! :resource-paths #{"src" "resources" "config"}
          :source-paths   #{"dev" "test"}
          :dependencies   '[[org.clojure/clojure       "1.9.0-alpha17"]
                            [org.clojure/core.async    "0.3.443"]
                            [org.clojure/clojurescript "1.9.671" :scope "test"]

                            [ch.qos.logback/logback-classic "1.2.3"]
                            [io.pedestal/pedestal.jetty     "0.5.2"]
                            [io.pedestal/pedestal.service   "0.5.2"]
                            [net.readmarks/compost          "0.2.0"]

                            [re-frame                  "0.9.4"   :scope "test"]
                            [reagent                   "0.7.0"   :scope "test"]

                            [adzerk/boot-cljs                               "2.0.0"           :scope "test"]
                            [adzerk/boot-cljs-repl                          "0.3.3"           :scope "test"]
                            [adzerk/boot-reload                             "0.5.1"           :scope "test"]
                            [adzerk/boot-test                               "1.2.0"           :scope "test"]
                            [clj-webdriver                                  "0.7.2"           :scope "test"]
                            [codebeige/boot-reset                           "0.1.3"           :scope "test"]
                            [com.cemerick/piggieback                        "0.2.1"           :scope "test"]
                            [eftest                                         "0.3.1"           :scope "test"]
                            [io.aviso/pretty                                "0.1.34"          :scope "test"]
                            [metosin/boot-alt-test                          "0.3.2"           :scope "test"]
                            [mvxcvi/puget                                   "1.0.1"           :scope "test"]
                            [org.clojure/tools.nrepl                        "0.2.12"          :scope "test"]
                            [org.seleniumhq.selenium/selenium-java          "3.4.0"           :scope "test"]
                            [org.seleniumhq.selenium/selenium-remote-driver "3.4.0"           :scope "test"]
                            [org.seleniumhq.selenium/selenium-server        "3.4.0"           :scope "test"]
                            [weasel                                         "0.7.0"           :scope "test"]
                            [pjstadig/humane-test-output                    "0.8.2"           :scope "test"]
                            [samestep/boot-refresh                          "0.1.0"           :scope "test"]]
          :exclusions     '[eftest
                            io.aviso/pretty
                            mvxcvi/puget
                            org.clojure/clojure
                            org.clojure/core.async])

(require '[adzerk.boot-cljs :refer [cljs]]
         '[adzerk.boot-cljs-repl :refer [cljs-repl start-repl]]
         '[adzerk.boot-reload :refer [reload]]
         '[codebeige.boot-reset :refer [reset]]
         '[metosin.boot-alt-test :refer [alt-test]]
         '[samestep.boot-refresh :refer [refresh]])

(task-options!
 alt-test  {:report 'eftest.report.pretty/report}
 aot       {:namespace #{'kakeibo.service}}
 cljs      {:optimizations :none
            :compiler-options {:asset-path "js/app.out"
                               :preloads '[kakeibo.dev]
                               :parallel-build true}}
 cljs-repl {:ip "0.0.0.0"
            :port 7889
            :ws-host "localhost"
            :nrepl-opts {:port 7888}}
 jar       {:main 'kakeibo.service
            :file "kakeibo-service.jar"}
 pom       {:project     project
            :version     version
            :description "Manage shared budgets online."
            :url         "https://github.com/codebeige/kakeibo"
            :scm         {:url "https://github.com/codebeige/kakeibo"}
            :license     {"MIT" "https://opensource.org/licenses/MIT"}}
 reload    {:asset-path "public"
            :port 7890
            :ws-port 7890
            :ws-host "0.0.0.0"}
 repl      {:bind "0.0.0.0"}
 reset     {:start 'kakeibo.dev/start
            :stop  'kakeibo.dev/stop}
 target    {:dir #{"builds"}})

(deftask run
  "Run the project."
  [a args ARG [str] "Arguments passed to application."]
  (require '[kakeibo.service :as service])
  (with-pass-thru _
    (apply (resolve 'service/-main) args)))

(deftask build
  "Build the project locally as a JAR."
  []
  (comp
   (cljs :optimizations :advanced
         :compiler-options {:output-wrapper true})
   (aot)
   (pom)
   (uber)
   (jar)
   (sift :include #{#"\.jar$"})
   (target)))

(deftask dev
  "Start up interactive development environment."
  []
  (comp
   (watch)
   (reload)
   (cljs-repl)
   (cljs)
   (reset)
   (refresh)))

(deftask test
  "Run all tests."
  []
  (comp
   (cljs)
   (alt-test)))

(deftask autotest
  "Automatically run related tests on file changes."
  []
  (comp
   (watch)
   (test)))
