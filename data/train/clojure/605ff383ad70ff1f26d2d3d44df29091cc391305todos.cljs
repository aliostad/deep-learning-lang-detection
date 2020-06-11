(ns cosmos.todos
  (:require
    [cosmos.todo :as todo]
    [cosmos.html :refer [h1 ul li]]))

;using an index instead of an array allows displayed sort order to remain a separate concern
(def init {
  :last-id 2
  :loaded {
    1 {:done false :desc "buy eggs"}
    2 {:done false :desc "send note to boss"}
  }
})

(defn render-many [path render dispatch state]
  (apply ul
    (map
      (fn [[id item]]
        (li {:key id}
          (render
            (fn [msg]
              (dispatch [id msg]))
            item)))
      (get-in state path))))

(defn reduce-many [path reducer msg state]
  (update-in state (conj path (first msg)) (partial reducer (nth msg 1))))

(defn render [dispatch state]
  (render-many [:loaded] todo/render dispatch state))

(defn reducer [msg state]
  (reduce-many [:loaded] todo/reducer msg state))