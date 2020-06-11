(defproject com.breezeehr/hitch "0.1.7-SNAPSHOT"
  :description "A Clojurescript library designed to manage and cache derived data."
  :url "https://github.com/Breezeemr/hitch"
  :license {:name "Eclipse Public License"
            :url  "http://www.eclipse.org/legal/epl-v10.html"}
  :scm "https://github.com/Breezeemr/hitch"

  :source-paths ["src"]
  :java-source-paths ["src-java"]

  ;; lein figwheel doesn't do automatic javac; use this alias instead
  :aliases {"test-cljs" ["do" "javac," "figwheel"]}

  :profiles
  {:provided
   {:dependencies [[org.clojure/clojure "1.8.0"]
                   [org.clojure/clojurescript "1.8.51"]]}

   :dev
   {:dependencies   [[com.cemerick/piggieback "0.2.1"]      ; needed by figwheel nrepl
                     [devcards "0.2.3"]]
    :plugins        [[lein-figwheel "0.5.10"]]
    :figwheel       {:http-server-root "public"
                     :nrepl-port       7889
                     :server-logfile   "target/figwheel-logfile.log"}

    ;; Target/classes is to ensure HaltException.class is in the classpath
    ;; This is needed by halt.cljc at macro-time even though it is not used!
    :resource-paths ["dev-resources" "target/devcards" "target/classes"]
    :cljsbuild      {:builds
                     [{:id           "devcards"
                       :source-paths ["src" "test"]
                       :figwheel     {:devcards true}
                       :compiler     {:main                 hitch.test-runner
                                      :asset-path           "js/out"
                                      :output-to            "target/devcards/public/js/hitch_devcards.js"
                                      :output-dir           "target/devcards/public/js/out"
                                      :optimizations        :none
                                      :source-map           true
                                      :source-map-timestamp false
                                      :cache-analysis       false}}]}}})
