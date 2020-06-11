(defproject om-bower/lein-template "0.0.7-SNAPSHOT"
  :description "A lein-template for creating OM projects using Bower
to manage JavaScript libraries."
  :url "https://github.com/hoelzl/om-bower-template"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :min-lein-version "2.3.4"
  :pom-addition [:developers [:developer
                              [:id "mhoelzl"]
                              [:name "Matthias Hoelzl"]
                              [:url "https://github.com/hoelzl"]
                              [:email "tc@xantira.com"]]]
  :repositories [["local" "file:///Users/tc/.m2/repository"]]
  :eval-in-leiningen true
  :profiles {:dev {:aliases {"deploy"
                             ["do" "deploy" "clojars"]}}})
