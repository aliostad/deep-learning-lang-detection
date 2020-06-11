
{:jvm-opts ["-XX:-OmitStackTraceInFastThrow"] ; DONT . OMIT . STACKTRACES!!!

 :profiles
 {:dev
  {:dependencies []}}

 :cider
 {:plugins
  [[cider/cider-nrepl "0.14.0"]]
  :dependencies
  [[org.clojure/tools.nrepl "0.2.12"]]
                                        ; hide java icon in OSX dock
  :jvm-opts ["-Dapple.awt.UIElement=true"]}

 :check
 {:plugins
  [[jonase/eastwood "0.2.3" :exclusions [org.clojure/clojure]]
   [lein-kibit "0.0.8" :exclusions [org.clojure/clojure]] ; static code analysis
   [lein-cljfmt "0.5.3"]
   ]}

 :power
 {:plugins
  [[cider/cider-nrepl "0.14.0"] ; cider repl integration
   [refactor-nrepl "2.3.0-SNAPSHOT"]
   [lein-ancient "0.6.10"  :exclusions [org.clojure/clojure]] ; dependency update checker
   ]

  :jvm-opts ["-Dapple.awt.UIElement=true"  ; hide java icon in OSX dock
             "-XX:-OmitStackTraceInFastThrow"  ; DONT . OMIT . STACKTRACES!!!
             ]

  :dependencies
  [[org.clojure/tools.nrepl "0.2.12"]
   [acyclic/squiggly-clojure "0.1.6"] ; linters for emacs
   [org.clojure/tools.namespace "0.2.10"]
   [im.chit/vinyasa "0.4.2" :exclusions [org.clojure/clojure]] ; workflow tools
   [alembic "0.3.2"]]

  :injections
  [(require '[vinyasa.inject :as inject])
   (require 'alembic.still)
   (load-file (str (System/getProperty "user.home") "/.lein/tracetool.clj"))
   ;; inject utility fns in the '.' namespace
   (inject/in ;; the default injected namespace is `.`
    [vinyasa.inject :refer [inject [in inject-in]]]
    [tracetool :refer [trace trace-env *trace* defn-trace no-trace ll undef clear-ns pid diff
                       time! toggle-timed!
                       clear-times untime-all
                       ;; capture instrument uninstrument instrument-report
                       ]]
    [clojure.pprint :refer [pprint pp]]
    [clojure.repl :refer [dir-fn doc source]]
    [clojure.java.shell :refer [sh]]
    [alembic.still :refer [distill lein load-project]])]

  :repl-options
  {:init (use '[clojure.repl :only (dir-fn doc source)])}}}
