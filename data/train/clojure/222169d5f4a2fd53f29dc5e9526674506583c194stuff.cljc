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

(def canvas
  [:section
   [:h2 "Teaser"]
   [:ul {:style  "float:left;width:50%;" }
    [:li "Flocking Behaviors"]
    [:li "Based on Craig Reynold's Flocking Algorithms"]
    [:li "Stateless*"]
    [:li "Stick around to see how it's done"]]
   [:canvas {:id "flocking-canvas" :style  "float:right;width:50%;" }]
   [:script { :type "text/javascript" :src "js/flocking.js"}]
   [:script { :type "text/javascript" }
    "flocking.game_launcher.launch_app(document.getElementById(\"flocking-canvas\"), 400, 400, 20);"]
   ])

(def predator-prey
  [:section
   [:h2 "Stateless Predator Prey"]
   [:div {:style  "float:left;width:400px;" }
    [:div
     [:small [:label { :style "display: inline-block; width: 250px;" } "Initial Prey Population"]]
     [:input {:id "prey-population-slider" :type "range" :min 0 :max 500 :step 1 }]]
    [:div
     [:small [:label { :style "display: inline-block; width: 250px;" } "Initial Predator Population"]]
     [:input {:id "predator-population-slider" :type "range" :min 0 :max 500 :step 1 }]]
    [:div
     [:small [:label { :style "display: inline-block; width: 250px;" } "Reproduction Rate"]]
     [:input {:id "reproduction-rate-slider" :type "range" :min 0 :max 500 :step 1 }]]
    [:div
     [:small [:label { :style "display: inline-block; width: 250px;" } "Predation Rate"]]
     [:input {:id "predation-rate-slider" :type "range" :min 0 :max 500 :step 1 }]]
    [:div
     [:small [:label { :style "display: inline-block; width: 250px;" } "Growth Rate"]]
     [:input {:id "growth-rate-slider" :type "range" :min 0 :max 500 :step 1 }]]
    [:div
     [:small [:label { :style "display: inline-block; width: 250px;" } "Death Rate"]]
     [:input {:id "death-rate-slider" :type "range" :min 0 :max 500 :step 1 }]]]
   [:canvas {:id "rk-canvas" :width 400 :height 400 :style "border:1px solid #000000;" }]
   [:script { :type "text/javascript" :src "js/rk.js"}]
   [:script { :type "text/javascript" } "numerics.canvasui.init(document.getElementById(\"rk-canvas\"));"]])