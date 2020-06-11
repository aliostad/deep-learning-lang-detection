(ns trico.adviser.core
  (:require [clojure.spec.alpha :as spec]
            [clojure.spec.test.alpha :as stest]))

(def db (atom {}))

(spec/def ::income (spec/and integer?
                             #(< 0 %)))

(spec/def ::saving-goal (spec/and integer?
                                  #(< 0 %)))

(spec/def ::profile (spec/keys :req []
                               :opt [::income ::saving-goal]))

; Doesn't spec the all state. This spec just check the return value from
; set-income
(spec/def ::state (spec/keys :req [::profile]
                             :opt []))

;;;;;;;;;;;;;;;;
;; SET INCOME ;;
;;;;;;;;;;;;;;;;

(defn set-income
  "This function allows the user to set his monthly income"
  [income]
  (if (spec/valid? ::income income)
    (swap! db assoc-in [::profile ::income] income) ; SAVE TO DATABASE MOCK
    [:error "income must be a number > 0"]))

(spec/fdef set-income
  :args (spec/cat :income ::income)
  :ret ::state)
  ; :fn #()) How to check the the value is acutally the parameter using spec ?
  ; Using spec somehow or just have to get the value from the map ?
(comment
 (set-income 5000)
 (stest/check `set-income)
 (stest/instrument `set-income))

;;;;;;;;;;;;;;;;;;;;;
;; SET SAVING GOAL ;;
;;;;;;;;;;;;;;;;;;;;;

(defn set-saving-goal
  "This function allows the user to set his saving goal"
  [saving-goal]
  (if (spec/valid? ::saving-goal saving-goal)
    (swap! db assoc-in [::profile ::saving-goal] saving-goal) ; SAVE TO DATABASE MOCK
    [:error "saving-goal must be a number > 0"]))

(spec/fdef set-saving-goal
  :args (spec/cat :saving-goal ::saving-goal)
  :ret ::state)
  ; :fn #()) How to check the the value is acutally the parameter using spec ?
  ; Using spec somehow or just have to get the value from the map ?
(comment
 (set-saving-goal 5000)
 (stest/check `set-saving-goal)
 (stest/instrument `set-saving-goal))
