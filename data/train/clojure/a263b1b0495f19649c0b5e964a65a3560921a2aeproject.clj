(defproject lunch-bot "0.1.0-SNAPSHOT"
  :description "A Slack bot to manage group lunches"
  :url ""
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.6.0"]
                 [clj-slack-client "0.1.6-SNAPSHOT"]
                 [clj-time "0.9.0"]
                 [org.clojure/math.combinatorics "0.0.8"]
                 [org.clojure/core.incubator "0.1.3"]]
  :main ^:skip-aot lunch-bot.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
