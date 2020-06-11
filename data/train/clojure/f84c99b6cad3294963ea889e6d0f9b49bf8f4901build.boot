(set-env!
 :resource-paths #{"src"}
 :dependencies '[[degree9/boot-semver "1.6.0" :scope "test"]])

(require '[degree9.boot-semver :refer :all])

(task-options! pom {:project 'powerlaces/boot-sources
                    :description "Boot tasks to move, collect, manage source files."
                    :url "https://github.com/boot-clj/boot-sources"
                    :scm {:url "https://github.com/boot-clj/boot-sources.git"}
                    :license {"Eclipse Public License" "http://www.eclipse.org/legal/epl-v10.html"}})


(ns-unmap 'boot.user 'test)
(ns-unmap 'boot.user 'install)

;; -- My Tasks --------------------------------------------

(deftask install
  "Install the artifact to the local .m2."
  []
  (comp
   (version)
   (build-jar)))

(deftask install-snapshot
  "Install the artifact to the local .m2 but always using a SNAPSHOT version.
Note that this task does not modify version.properties."
  []
  (comp
   (version :develop true
            :minor 'inc
            :patch 'zero
            :pre-release 'snapshot)
   (build-jar)))

(deftask deploy
  "Build boot-sources and deploy to Clojars."
  []
  (comp
   (version)
   (build-jar)
   (push-release)))

(deftask set-dev! []
  (set-env! :source-paths #(conj % "test")
            :dependencies #(into % '[[adzerk/boot-test "RELEASE" :scope "test"]
                                     [boot/core "RELEASE"]]))
  (require 'adzerk.boot-test))

(deftask test
  "Testing once (dev profile)"
  []
  (set-dev!)
  (comp ((eval 'adzerk.boot-test/test))))

(deftask auto-test
  "Start auto testing mode (dev profile)"
  []
  (set-dev!)
  (comp (watch)
        (speak)
        ((eval 'adzerk.boot-test/test))))
