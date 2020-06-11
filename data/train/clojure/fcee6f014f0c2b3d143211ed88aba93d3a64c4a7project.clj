(defproject pulsar-example "0.1.0-SNAPSHOT"
  :description "a sample project using Pulsar"
  :url "https://github.com/yogthos/pulsar-example"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.7.0"]
                 [co.paralleluniverse/pulsar "0.7.3"]
                 [co.paralleluniverse/quasar-core "0.7.3"]]

  :manifest {"Premain-Class" "co.paralleluniverse.fibers.instrument.JavaAgent"
             "Agent-Class" "co.paralleluniverse.fibers.instrument.JavaAgent"
             "Can-Retransform-Classes" "true"
             "Can-Redefine-Classes" "true"}

  :java-agents [[co.paralleluniverse/quasar-core "0.7.3"]]

  :main pulsar-example.core
  :uberjar-name "pulsar-example.jar" 
  :aot [pulsar-example.core])

