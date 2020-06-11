
(ns clouditor.component.token
  (:require [respo.alias :refer [create-comp div input]]
            [clouditor.style.layout :as layout]
            [clouditor.style.widget :as widget]
            [clouditor.util.measure :refer [text-width]]
            [clouditor.component.token-toolbar :refer [comp-token-toolbar]]))

(defn on-modify [e dispatch! mutate!]
  (dispatch! :tree/token-modify (:value e)))

(defn on-focus [coord]
  (fn [e dispatch! mutate!]
    (println "focus!")
    (dispatch! :tree/focus coord)))

(defn render [token coord focused]
  (fn [state mutate!]
    (let [w (+ 12 (text-width token 14 "Menlo,monospace"))]
      (div
        {:style widget/token-box}
        (input
          {:style (merge widget/token {:width (str w "px")}),
           :event {:click (on-focus coord), :input on-modify},
           :attrs {:value token}})
        (if (= coord focused) (comp-token-toolbar token))))))

(def comp-token (create-comp :token render))
