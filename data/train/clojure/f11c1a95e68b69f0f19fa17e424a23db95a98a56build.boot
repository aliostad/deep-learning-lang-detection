(set-env!
 ;; Test path can be included here as source-files are not included in JAR
 ;; Just be careful to not AOT them
 ;; Also if test dirs are only needed when running tests create task to add dirs to source paths, see::
 ;; https://github.com/boot-clj/boot/wiki/Boot-for-Leiningen-Users#profiles-middleware
 
 :source-paths   #{}
 :resource-paths #{"src" "src-dev"}
 
 :dependencies '[[org.clojure/clojure "RELEASE"]

                 [com.rpl/specter "0.13.0"]

                 ;; Environment
                 [environ "1.1.0"]
                 [boot-environ "1.1.0"]
                 
                 [samestep/boot-refresh "0.1.0" :scope "test"]
                 ;; https://github.com/tolitius/boot-check
                 [tolitius/boot-check "0.1.3"]
                 [adzerk/boot-test "1.1.2"]
                 [metosin/boot-alt-test "0.1.2"]
                 
                 ;; Sql queries
                 [mysql/mysql-connector-java "5.1.38"]
                 ;; [mysql/mysql-connector-java "6.0.3"] ;breaks code
                 ;; https://search.maven.org/#search%7Cgav%7C1%7Cg%3A%22org.clojure%22%20AND%20a%3A%22java.jdbc%22
                 ;; [org.clojure/java.jdbc "0.3.7"]
                 ;; [org.clojure/java.jdbc "0.5.8"]
                 [org.clojure/java.jdbc "0.6.1"]
                 
                 ;; [org.postgresql/postgresql "9.2-1002-jdbc4"]
                 ;; [postgresql "9.3-1102.jdbc41"]
                 [com.layerware/hugsql "0.4.7"]
                 ;; [honeysql "0.7.0"]
                 
                 [org.postgresql/postgresql "9.4-1201-jdbc41"]
                                        ; For db connection pooling
                 [clojure.jdbc/clojure.jdbc-c3p0 "0.3.2"]
                 
                 ;; String manipulation
                 [funcool/cuerdas "1.0.2"]
                 
                 ;; Logging
                 [com.taoensso/timbre      "4.7.4"]
                 [com.taoensso/encore      "2.85.0"]
                 [print-foo-cljs "2.0.0"] 
                 
                 ;; Manage lifecycle of services
                 [mount "0.1.10"]
                 [robert/hooke "1.3.0"] ; logging for mount
                 
                 ;; Bcrypt for use with passwords
                 [crypto-password "0.2.0"]
                 
                 
                 ;; Dev
                 ;; Hook up editor with clojure repl
                 [org.clojure/tools.nrepl "0.2.12"    :scope "test"]
                 
                 ;; http://ioavisopretty.readthedocs.io/en/0.1.21/
                 [io.aviso/pretty "0.1.30" :scope "test"]
                 [aprint "0.1.3"]
                 [jansi-clj "0.1.0"]               
                 ])

(require
 '[samestep.boot-refresh :refer [refresh]]
 '[environ.boot :refer [environ]]
 '[tolitius.boot-check :as check]
 '[adzerk.boot-test :refer :all]
 '[metosin.boot-alt-test :refer :all]
 ) 

; Watch boot temp dirs
;; (init-ctn!)

(task-options!
 repl {:server true :host "127.0.0.1" :port 15123 :init-ns 'aid.core
       :eval '(set! *print-length* 20) }
 pom {:project 'bilby
      :version "0.1.0-SNAPSHOT"
      :description ""
      }
 aot {:namespace #{'aid.core}}
 jar {:main 'aid.core}
 )

(deftask dev
  "Run a restartable system in the Repl. Connecting to nrepl server will load
  dev namespace where start is called on the app, unless refresh task is run
  straight away."
  []
  (comp
   (dev-env)                        ;set in gitignored profile.boot
   ;; (check/with-yagni)
   ;; (check/with-eastwood)
   ;; (check/with-kibit)
   ;; (check/with-bikeshed)
   (repl)
   ;;watch + refresh reloads namespaces (and dependants) on save, kind of messes
   ;;up repl workflow, so putting this before watch
   ;; Refresh on it own will load all namespaces on 'boot dev', so also the dev ns, which calls (start)
   ;; To start app on connecting to nrepl server comment it out
   (refresh)
   (wait)
   ))
;; boot dev-env check/with-...

(deftask do-tests
  []
  (comp
   (dev-env)
   ;; (watch)
   (test) 
   ))
;; same as:
;; boot set-dev-env test

;; TODO: test task for production build.
(deftask build
  "Build the jar package"
  []
  (comp
   (prod-env)                           ;TODO: has no effect no jar, superfluous?
   (aot)
   (pom)
   (uber)
   (jar)
   (target)))
