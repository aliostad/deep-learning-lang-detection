(set-env!
 :source-paths   #{"src/cljs" "src/clj" "test"}
 :resource-paths #{"resources"}
 :dependencies '[
                 ;;; These three libraries are Boot's answer to Figwheel
                 [adzerk/boot-cljs            "1.7.228-1" :scope "test"]
                 [adzerk/boot-reload          "0.4.12" :scope "test"]
                 [adzerk/boot-cljs-repl       "0.3.0" :scope "test"]

                 ;;; Enables a Cljs-specific nREPL. Haven't yet used.
                 [com.cemerick/piggieback     "0.2.1"  :scope "test"]
                 ;;; Together with piggieback, enables a browser REPL.
                 [weasel                      "0.7.0"  :scope "test"]
                 
                 ;;; Devcards is wonderful for literate interactive client-side components
                 [devcards                    "0.2.1-7"   :scope "test" :exclusions [cljsjs/react cljsjs/react-dom]]
                 ;;; Must be enabled with Chrome https://github.com/binaryage/cljs-devtools
                 [binaryage/devtools          "0.8.2"]
                 [powerlaces/boot-cljs-devtools "0.1.1"     :scope "test"]
                 
                 [reagent-utils "0.2.0"]
                 [reagent                     "0.6.0-rc"]                 
                 [re-frame                    "0.8.0"]
                 [day8.re-frame/undo          "0.3.2"]
                 ;;; The story of URLs with re-frame and secretary is not yet complete.
                 [secretary                   "1.2.3"]
                 [oj "0.3.0"]
                 [korma "0.4.3"]
                 [sqlingvo "0.8.17"]
                 [com.taoensso/sente "1.10.0"]
                 [mbuczko/boot-ragtime "0.2.0"]
                 [mbuczko/boot-flyway "0.1.0-SNAPSHOT"]
                 [migratus "0.8.28"]
                 [com.fzakaria/slf4j-timbre "0.3.2"]

                 [cljs-ajax "0.5.8"]
                 
                 [org.clojure/tools.nrepl     "0.2.12"]                 
                 [org.clojure/clojure         "1.8.0"]
                 [org.clojure/clojurescript   "1.9.225"]
                 [org.clojure/tools.logging   "0.3.1"]
                 [liberator "0.14.1"]
                 [compojure                   "1.4.0"]                 
                 [ring-middleware-format      "0.7.0"]
                 [ring/ring-json "0.4.0"]
                 [ring-webjars                "0.1.1"]
                 [ring/ring-core              "1.4.0"]
                 [ring/ring-jetty-adapter     "1.4.0"]
                 [ring/ring-defaults          "0.1.5"]
                 ;;; This library enables Swagger with Compojure.
                 [metosin/compojure-api        "1.1.8"]
                 [metosin/ring-http-response   "0.8.0"]
                 
                 ;;; These two libraries are necessary to use Postgres.
                 [org.clojure/java.jdbc        "0.6.2-alpha3"]
                 [org.postgresql/postgresql    "9.4.1209"]

                 ;;; Allows us to make a .boot-env file and access the map elsewhere.
                 [boot-environ                 "1.1.0"]
                 ;;; Similar, same overall library, used by System.
                 [environ                      "1.1.0"]
                 ;;; Authentication library. Simpler than friend they say.
                 [buddy                        "1.1.0"]
                 [drift "1.5.3"]
                 ;;; Lets us manage web server, database, etc., and hot-reload them.
                 [org.danielsz/system          "0.3.0-SNAPSHOT"]
                 [com.stuartsierra/component "0.3.1"]
                 
                 [tolitius/boot-check           "0.1.3"     :scope "test"]
                 [adzerk/boot-test "1.1.2"]
                 [pandeiro/boot-http            "0.7.3"     :scope "test"]
                 [crisptrutski/boot-cljs-test   "0.2.1"     :scope "test"]])

(require
 '[adzerk.boot-cljs      :refer [cljs]]
 '[adzerk.boot-cljs-repl :refer [cljs-repl start-repl]]
 '[adzerk.boot-reload    :refer [reload]]
 '[adzerk.boot-test :as boot-test]
 '[holy-grail.systems :refer [dev-system prod-system]]
 '[pandeiro.boot-http            :refer [serve]]
 '[crisptrutski.boot-cljs-test   :refer [test-cljs]]
 '[tolitius.boot-check           :as    check]
 '[environ.boot :refer [environ]]
 '[environ.core :refer [env]]
 '[clojure.java.io :as io]
 '[system.boot :refer [system run]])

(ns-unmap 'boot.user 'test)

(def config
  (let [f (io/file "config.edn")]
    (if (.exists f)
      (-> f slurp read-string)
      {})))

(deftask run-tests []
  (comp
   (environ :env config)
   (watch)
   (speak)
   (boot-test/test :namespaces #{'database-url-test 'bootenvtest})))


(deftask analyze []
  (comp
   (sift :include #{#"\.clj(s|c)$"})
   (check/with-yagni)
   (check/with-eastwood)
   (check/with-kibit)
   (check/with-bikeshed)))


(deftask development []
  (task-options! cljs {:source-map true
                       :compiler-options {:devcards true}}
                 reload {:on-jsload 'holy-grail.core/app})
  identity)


(deftask dev
  "Run a restartable system in the Repl"
  []
  (comp
   (development)
   (environ :env config)
   (watch :verbose true)
   (system :sys #'dev-system :auto true :files ["handler.clj" "services.clj"])
   (reload)
   (cljs)
   (repl :server true)
   (speak)))


(deftask dev-cljs-repl
  "Run a restartable system in the Repl"
  []
  (comp
   (environ :env {:http-port "3000"})
   (watch :verbose true)
   (system :sys #'dev-system :auto true :files ["handler.clj"])
   (reload)
   (cljs-repl)
   (cljs :source-map true)))

(deftask dev-run
  "Run a dev system from the command line"
  []
  (comp
   (environ :env {:http-port "3000"})
   (cljs)
   (run :main-namespace "holy-grail.core" :arguments [#'dev-system])
   (wait)))

(deftask prod-run
  "Run a prod system from the command line"
  []
  (comp
   (environ :env {:http-port "8008"
                  :repl-port "8009"})
   (cljs :optimizations :advanced)
   (run :main-namespace "holy-grail.core" :arguments [#'prod-system])
   (wait)))
