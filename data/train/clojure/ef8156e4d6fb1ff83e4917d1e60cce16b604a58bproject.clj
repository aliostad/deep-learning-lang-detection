(defproject com.degel/re-frame-storage-fx "0.1.0"
  :description "A re-frame effects handler to manage web storage"
  :url "https://github.com/deg/re-frame-storage-fx"
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [org.clojure/clojurescript "1.9.542"]
                 [re-frame "0.9.3"]]
  :jvm-opts ^:replace ["-Xmx1g" "-server"]
  :plugins [[lein-npm "0.6.2"]]
  :npm {:dependencies [[source-map-support "0.4.0"]]}
  :source-paths ["src" "target/classes"]
  :clean-targets ["out" "release"]
  :target-path "target")
