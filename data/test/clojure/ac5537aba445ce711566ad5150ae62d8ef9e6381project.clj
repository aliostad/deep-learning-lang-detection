
(defproject lein-jelastic "0.1.2"
  :description "Manage jelastic service through leiningen"
  :url "https://github.com/mysema/lein-jelastic"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :eval-in-leiningen true
  :dependencies [[org.clojure/clojure "1.4.0"]
                 [com.jelastic/jelastic-maven-plugin "1.6"]
                 [org.apache.maven/maven-core "2.2.1"]
                 [org.apache.maven/maven-plugin-api "2.2.1"]
                 [org.apache.maven/maven-artifact "2.2.1"]
                 [org.apache.maven/maven-project "2.2.1"]
                 [org.apache.maven/maven-plugin-api "2.2.1"]]
  )
