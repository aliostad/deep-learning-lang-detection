(defproject url-redirector "0.1.0-SNAPSHOT"
  :description "A Clojure library designed to manage URL redirection using data from a JSON document stored in MongoDB"
  :url "http://example.com/FIXME"
  :license {:name "Apache Public License"
            :url "http://www.apache.org/licenses/LICENSE-2.0"}
  :dependencies [[org.clojure/clojure "1.6.0"]
                 [org.clojure/core.async "0.1.346.0-17112a-alpha"]
                 [ring/ring-core "1.3.1"]
                 [cc.qbits/jet "0.5.0-beta1"]
                 [environ "0.5.0"]
                 [com.novemberain/monger "2.0.0"]
                 [com.taoensso/carmine "2.7.0"]])
