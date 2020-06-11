(defproject cashflow-api "0.1.0-SNAPSHOT"
    ;TODO: add description and URL
    :description "An API which manage expeses."
    :url "https://github.com/HemanthGowda/cashflow-api"
    :license {:name "MIT" :url "http://opensource.org/licenses/MIT"}
    :dependencies [[org.clojure/clojure "1.5.1"]
                   [ring/ring-core "1.2.1"]
                   [ring/ring-jetty-adapter "1.2.1"]
                   [compojure "1.1.6"]
                   [cheshire "5.3.1"]
                   [ring/ring-json "0.2.0"]
                   [korma "0.3.0-RC5"]
                   [org.postgresql/postgresql "9.2-1002-jdbc4"]
                   [ragtime "0.3.4"]
                   [environ "0.4.0"]
                   [buddy/buddy-hashers "0.4.0"]
                   [buddy/buddy-auth "0.4.0"]
                   [crypto-random "1.2.0"]]

    :plugins [[lein-ring "0.8.10"]
              [ragtime/ragtime.lein "0.3.6"]
              [lein-environ "0.4.0"]]

    :ring {:handler cashflow_api.handler/app
           :nrepl   {:start? true
                     :port   9998}}

    :ragtime {:migrations ragtime.sql.files/migrations :database ~(System/getenv "CASHFLOW_DB_URL")}

    :profiles {:dev  {:dependencies [[javax.servlet/servlet-api "2.5"]
                                     [ring-mock "0.1.5"]]
                      :env          {:cashflow-db      "cashflow_dev"
                                     :cashflow-db-user "cashflow_dev"
                                     :cashflow-db-pass "pass_dev"}}
               :test {
                      :ragtime {:database "jdbc:postgresql://localhost:5432/cashflow_test?user=cashflow_test&password=pass_test"}
                      :env     {:cashflow-db      "cashflow_test"
                                :cashflow-db-user "cashflow_test"
                                :cashflow-db-pass "pass_test"}}})
