(ns state.slides2
  (:require [reveal.clj.core :as reveal]
            [state.state :as state]))

;;no death by slides
;; *Basic* Clojure/FP overview
;; *Basic* state overview
;; Spend time on HOW with examples
;; Persistent data structures
;; Threading for fluent APIs
;; Separation of Concerns*
;; Concurrency primitives manage state
;; Functions model behavior
;; It's all operations on data
;; Separate UI/input/etc from everything else
;; This is impossible in Java

(def conclusion
  [:section
   [:h2 "In Conclusion:"]
   [:h2 "Yes, you can be stateless"]
   [:ul
    [:li "It's a different way of thinking"]
    [:li "Threading and api design"]
    [:li "Come see my other talk"]]])

(def intro
  [:section
   [:h2 "Functional Programming"]
   [:h4 "Writing Stateless Code in a Stateful World with Clojure"]
   [:p "Mark Bastian"]
   [:small [:p
            [:a
             {:href "mailto:markbastian@gmail.com?Subject=Syntax"}
             "markbastian@gmail.com"]]
    [:p [:a {:href "https://twitter.com/mark_bastian" } "@mark_bastian"]]]
   [:p "3/24/2015"]])

(def confusing
  [:section
   [:h2 "What is Functional Programming?"]
   [:blockquote { :cite "http://en.wikipedia.org/wiki/Functional_programming"}
    "&ldquo;In computer science, functional programming is a programming paradigm, a style of building the structure and
    elements of computer programs, that treat computation as the evaluation of mathematical functions and avoids
    changing-state and mutable data.&rdquo;"]
   [:div [:span { :style "position:absolute;bottom:-10;right:150;font-size:0.5em" }
    "http://en.wikipedia.org/wiki/Functional_programming" ]]])

(def confusing-2
  [:section
   [:h2 "How?"]
   [:ul
    [:li { :class :fragment } "If computation is stateless and data is immutable,
    then how do you do anything useful?"]
    [:li { :class :fragment } "Are you limited to scripts and other trivial applications?"]
    [:p { :class :fragment } "If these are the kinds of questions you have, you are in the right place."]]])

(def background
  [:section
   [:h2 "Background"]
   [:ul
    [:li "OOP since the 90s"]
    [:li "Java since ~2003"]
    [:li "Started writing Scala in the 2009 time frame"]
    [:li "Clojure was too foreign"]]])

(def scala
  [:section
   [:h2 "Scala"]
   [:ul
    [:li "Multiparadigm (A.K.A. a bridge to functional)"]
    [:li "Java-as-Scala in no time"]
    [:li "The community steers you to functional"]
    [:li "As you learn FP, you fix your code"]]])

(def scala-pros-and-cons
  [:section
   [:h2 "Scala: Pros and Cons"]
   [:ul
    [:li "Pros"
     [:ul
      [:li "Easy bridge from Java"]
      [:li "Functional"]
      [:li "Collections"]]]
    [:li "Cons"
     [:ul
      [:li "Collections"]
      [:li "Doesn't address persistent value management"]]]]])

(def stages
  [:section
   [:h2 "The Stages of FP"]
   [:ul
    [:li "Persistent collections with functions"]
    [:li "Functions"]
    [:li "Values everywhere"]
    [:li "Full state management"]]])

(def overview
  [:section
   [:h2 "Overview"]
   [:ul
    [:li "Functional Programming"]
    [:li "State and Statelessness"]
    [:li "Getting There"]
    [:li "Examples"]]])

;;Start with the problem I stated - How do I do this?
(def slides
  [intro
   confusing
   confusing-2
   (into [:section] state/slides)
   background
   scala
   scala-pros-and-cons
   overview
   stages
   conclusion])

(reveal/write-presentation
  {:out "state.html"
   :slides slides
   :author "Mark Bastian"
   :description "Functional Programming: Writing Stateless Code in a Stateful World with Clojure"
   :title "Clojure: State"})

