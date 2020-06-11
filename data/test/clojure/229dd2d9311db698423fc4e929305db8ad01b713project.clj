(defproject
  ideas
  "0.1.0-SNAPSHOT"

  :repl-options
  {:init-ns ideas.repl}

  :dependencies
  [
   [org.clojure/clojure "1.8.0"]
   [ring-server "0.4.0"] ;; web server
   [ragtime "0.5.2"] ;; migration stuff
   [environ "1.0.1"] ;; manage envs (TODO use it)
   [markdown-clj "0.9.62"] ;; used for ./resources/md/
                           ;; NOTE: new version (.78) is broken
   [com.taoensso/timbre "4.1.4"] ;; logging / profiling
   [korma "0.4.2"] ;; sql
   [com.taoensso/tower "3.0.2"] ;; i18n
   [selmer "0.9.4"] ;; jinja-like templating
   [lib-noir "0.9.9"] ;; ring helpers: sessions, assets, input val., caching, ...
   [compojure "1.4.0"] ;; routing
   [clj-time "0.11.0"] ;; like joda-time... but for clojure
   [postgresql/postgresql "9.3-1102.jdbc41"]
   [log4j "1.2.17" ;; logging. seems to be outdated (2012)
    :exclusions [javax.mail/mail javax.jms/jms com.sun.jdmk/jmxtools com.sun.jmx/jmxri]]

   ;; cljs
   [org.clojure/clojurescript "0.0-2913"]
   [domina "1.0.3"] ;; DOM
   [hipo "0.5.1"] ;; templating
   [prismatic/dommy "1.1.0"] ;; event
   [cljs-ajax "0.5.1"] ;; ajax

   ; and now, for project-specific deps...
   [inflections "0.10.0"] ; used for DB stuff
   [prone "0.8.2"] ; better_errors for ring
   ]

  :source-paths
  ["src"]

  :cljsbuild
  {:builds
   [{:source-paths ["src-cljs"],
     :compiler
     {:pretty-print false,
      :output-to "resources/public/js/site.js",
      :optimizations :advanced}}]}

  :ring
  {:handler ideas.handler/app,
   :init ideas.handler/init,
   :destroy ideas.handler/destroy}

  :profiles
  {
   :uberjar
   {:aot :all},
   :production
   {:ring
    {:open-browser? false, :stacktraces? false, :auto-reload? false}},
   :dev
   {:dependencies [[ring-mock "0.1.5"]
                   [ring/ring-devel "1.4.0"]],
    :env {:dev true}
    :ring {:auto-reload? true
           :stacktrace-middleware prone.middleware/wrap-exceptions}}}

  :url
  "https://github.com/vendethiel/ideas-luminus.clj"

  :aliases {"migrate"  ["run" "-m" "ideas.ragtime/migrate"]
            "rollback" ["run" "-m" "ideas.ragtime/rollback"]}

  :plugins
  [[lein-ring "0.9.2"]
   [lein-environ "0.4.0"]
   [lein-cljsbuild "0.3.3"]]

  :description
  "Tell us what are your ideas!"

  :min-lein-version
  "2.0.0")
