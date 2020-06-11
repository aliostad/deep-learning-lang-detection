(def project 'brewerry)
(def version "0.0.1-SNAPSHOT")

(set-env! :resource-paths #{"resources" "src"}
          :source-paths   #{"test"}
          :dependencies   '[[org.clojure/clojure "RELEASE"]
                            [adzerk/boot-test "RELEASE" :scope "test"]
                            [ring "1.6.1"]
                            [ring/ring-mock "0.3.1"]
                            [ring-logger "0.7.7"]
                            [compojure "1.6.0"]
                            [clj-http "3.7.0"]
                            [cheshire "5.8.0"]])

(task-options!
 aot {:namespace   #{'brewerry.server}}
 pom {:project     project
      :version     version
      :description "Application to manage a brewerry."
      :url         "http://example/FIXME"
      :scm         {:url "https://github.com/adrienhaxaire/brewerry"}
      :license     {"Apache License Version 2.0"
                    "http://www.apache.org/licenses/LICENSE-2.0"}}
 jar {:main        'brewerry.server
      :file        (str "brewerry-" version "-standalone.jar")})

(deftask build
  "Build the project locally as a JAR."
  [d dir PATH #{str} "the set of directories to write to (target)."]
  (let [dir (if (seq dir) dir #{"target"})]
    (comp (aot) (pom) (uber) (jar) (target :dir dir))))

(deftask run
  "Run the project."
  [a args ARG [str] "the arguments for the application."]
  (require '[brewerry.server :as app])
  (apply (resolve 'app/-main) args))

(require '[adzerk.boot-test :refer [test]])
