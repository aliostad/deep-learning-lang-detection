(ns frontend.counter-list-fancy
  (:require [frontend.ui :as ui]
            [frontend.counter :as counter]
            [cljs.core.match :refer-macros [match]]))

(defn init
  []
  {; list of [id counter-model] vectors
   :counters (list)
   :next-id  0})

(defn -update-counters*
  "Applies a function of args [counter-model & args] to the counters specified by predicate.
  The function can have side-effects. Returns a new model."
  [model pred f & args]
  (letfn [(update-counter [[counter-id counter-model :as counter]]
            (if (pred counter)
              [counter-id (apply f counter-model args)]
              counter))]
    (update model :counters #(doall (map update-counter %)))))

(defn -update-counter
  [model id f & args]
  (apply -update-counters* model #(= id (first %)) f args))

(defn -update-every-counter
  [model f & args]
  (apply -update-counters* model (constantly true) f args))

(defn -get-counter
  [model id]
  (->> (:counters model)
       (filter #(= (first %) id))
       first
       second))

(defn control
  [model signal dispatch]
  (match signal
         :on-connect nil
         :on-insert (dispatch :insert)
         [:on-remove id] (dispatch [:remove id])

         [[:on-modify id] s]
         (-update-counter model id
                          counter/control
                          s
                          #(-> (dispatch [[:modify id] %])
                               (-get-counter id)))))

(defn reconcile
  [model action]
  (match action
         :insert
         (-> model
             (update :counters concat [[(:next-id model) (counter/init 0)]])
             (update :next-id inc))

         [:remove id]
         (update model :counters #(filter (fn [[cid _]] (not= cid id)) %))

         [[:modify id] a]
         (-update-counter model id counter/reconcile a)))

(defn view-model
  [model]
  (select-keys (-update-every-counter model counter/view-model)
               [:counters]))

(defn -view-counter
  [[id view-model] dispatch]
  [counter/view-with-remove-button view-model {:dispatch           (ui/tagged dispatch [:on-modify id])
                                               :dispatch-on-remove #(dispatch [:on-remove id])}])

(defn view
  [view-model dispatch]
  (let [counters (map #(-view-counter % dispatch) (:counters view-model))
        insert [:button {:on-click #(dispatch :on-insert)} "Insert"]]
    (into [:div insert] counters)))

(def spec
  {:init       init
   :view-model view-model
   :view       view
   :control    control
   :reconcile  reconcile})