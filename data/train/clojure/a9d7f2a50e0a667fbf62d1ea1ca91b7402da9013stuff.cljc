(ns state.stuff
  (:require [reveal.clj.code-sample :as c]))


(def concerns
  [:section
   [:h2 "Separation of Concerns"]
   [:ul
    [:li "Data"]
    [:li "Functions"]
    [:li "State Management"]
    [:li "UI/UX"]]])

(def atomic-bridges
  [:section
   [:h2 "Atomic Bridges"]
   [:ul
    [:li "Clojure atoms, agents, and refs should manage all state"]
    [:li "add-watch is your friend"]
    [:li "They are the bridge"]
    [:li "All interactions are with the refs"]
    [:li "Compared to beans' complexity"]]])

(def data
  [:section
   [:h2 "Data is King"]
   [:ul
    [:li "Model everything as data"]
    [:li "Clojure Data Structures"
     [:ul
      [:li "Heterogeneous"]
      [:li "Nestable"]
      [:li "Common interfaces"]]]]])

(def whats-it-about-oop
  [:section
   [:h2 "Object Oriented Programming"]
   [:h3 "A Familiar Paradigm"]
   [:ul
    [:li "Objects contain state in the form of fields"]
    [:li "Fields are generally mutable (setters)"]
    [:li "They are often observable or observed (e.g. Beans, PCLs, etc.)"]
    [:li "Wiring all of these items up produces a program"]]])

(def whats-it-about-fp
  [:section
   [:h2 "Functional Program"]
   [:h3 "A Growingly Popular Paradigm"]
   [:ul
    [:li "Computation is modeled as the application of functions to values"]
    [:li "Values = no mutable state"]
    [:li "To those new to FP, this makes NO sense"]
    [:li "How can you do anything useful if nothing changes?"]]])

;;$$ are not inline
(def equations
  [:section
   [:p "$${dR\\over dt} = \\alpha R - \\beta R F$$"]
   [:p "$$f(x) = sin(x)$$"]
   [:p "This is an equation \\({dR\\over dt} = \\alpha R - \\beta R F\\) that is inline."]])

(def functions
  [:section
   [:p "$${dR\\over dt} = \\alpha R - \\beta R F$$"]
   [:p "This is an equation \\({dR\\over dt} = \\alpha R - \\beta R F\\) that is inline."]])


(def code
  [:section
   [:h2 "Code"]
   (c/code-block "src/cljc/state/test.clj")])

(def scala-the-good
  [:section
   [:h2 "Scala"]
   [:ul
    [:li "Introduced to Scala ~2009"]
    [:li "Excellent bridge language"
     [:ol
      [:li "Scala as Java"]
      [:li "Scala immutable collections"]
      [:li "Scala collection operations"]
      [:li "Functions everywhere"]]]]])

(def scala-the-bad
  [:section
   [:h2 "Scala: Questions"]
   [:ul
    [:li "How do I do heterogeneous collections?"]
    [:li "How do I modify nested value types (case classes)?"]
    [:li "How do I manage global application state?"]]])