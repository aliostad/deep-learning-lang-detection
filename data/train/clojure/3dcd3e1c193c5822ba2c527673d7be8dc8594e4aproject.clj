(defproject domain-redirector "0.1.0-SNAPSHOT"
            :description "A Clojure library designed to manage domain redirection (HTTP 301) using data from a JSON document stored in MongoDB and a REDIS cache"
            :url "https://github.com/raymcdermott/domain-redirector"
            :license {:name "Apache Public License"
                      :url  "http://www.apache.org/licenses/LICENSE-2.0"}
            :dependencies [[org.clojure/clojure "1.6.0"]
                           [ring/ring-core "1.3.2"]
                           [ring/ring-jetty-adapter "1.3.2"]
                           [org.clojure/core.memoize "0.5.6"]
                           [environ "1.0.0"]
                           [cheshire "5.4.0"]
                           [http-kit "2.1.18"]
                           [com.novemberain/monger "2.0.0"]
                           [com.taoensso/carmine "2.7.0" :exclusions [org.clojure/clojure]]]
            :main domain-redirector.core
            :min-lein-version "2.0.0"
            :plugins [[lein-environ "1.0.0"]]
            :uberjar-name "domain-redirector-standalone.jar"
            :profiles {:test       {:env {:domain-json-file             "test/test-domains.json"
                                          :prefer-network-backing-store false
                                          :protocol-header-name         "x-forwarded-proto"}}
                       :production {:env {:production           true
                                          :protocol-header-name "x-forwarded-proto"}}})