(defproject clojurefield "0.0.20-SNAPSHOT"

  :description "For approximately five hours and fifty-seven minutes,
  it rampages throughout the city, destroying landmarks and battling 
  the military. After several failed attempts to kill the monster, 
  the government initiates the HAMMER-DOWN Protocol, in a last ditch 
  effort to destroy it."

  :url "http://clj-no.de/clojurefield" ;; stub

  :license {:name "Eclipse Public License" ;; derived from clj
            :url "http://www.eclipse.org/legal/epl-v10.html"}

  ;; Some of these packages might also be included as git or svn
  ;; (to git) repositories and be present as submodules of this one.
  ;; Eventually I will manage it all a bit better through uberjars
  ;; and maven repositories.
  ;; ----------------------------------------------------------------
  ;; |j| jar   <u> uberjar   (c) classes   $s$ submodule
  ;; ----------------------------------------------------------------
  
  :dependencies [[org.clojure/clojure "1.5.1"] ; |j|
                 [clojure-opennlp "0.2.0"]
                 [clojurewerkz/urly "1.0.0"]
                 [alter-ego "0.0.5-SNAPSHOT"] ; $s$
                 [org.clojars.nakkaya/vision "1.0.0"] ; $s$
                 ])





