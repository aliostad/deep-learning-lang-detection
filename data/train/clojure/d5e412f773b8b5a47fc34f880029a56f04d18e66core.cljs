(ns com.ben-allred.empire.core
    (:require-macros [com.ben-allred.utils.logger :as log])
    (:require [reagent.core :as r]))

(defn ^:private dispatch-to [subs state state-reducer action]
    (let [new-state (swap! state state-reducer action)
          subs      @subs]
        (doall (for [sub (vals (get subs (:type action)))]
                   (sub action new-state)))
        new-state))

(defn manage [{:keys [get-state dispatch]} app & args]
    [(fn []
         (into [app (assoc (get-state) :dispatch dispatch)] args))])

(defn create-store [state-reducer]
    (let [state    (r/atom (state-reducer))
          subs     (atom {})
          store    {:get-state #(deref state)
                    :subscribe (fn [type callback]
                                   (let [key       (gensym "callback")
                                         subscribe #(do (swap! subs update % assoc key callback)
                                                        (fn [] (swap! subs update type dissoc key) :success))]
                                       (if (coll? type)
                                           (mapv subscribe type)
                                           (subscribe type))))}
          dispatch (fn dispatch [value]
                       (cond
                           (fn? value) (value (assoc store :dispatch dispatch))
                           (keyword? value) (dispatch {:type value})
                           (vector? value) nil ;;TODO: handle event?
                           (and (map? value) (keyword? (:type value))) (dispatch-to subs state state-reducer value)
                           :else (throw (str "Cannot dispatch value '" value "' of type: " (type value)))))]
        (assoc store :dispatch dispatch)))

(defn combine-reducers [reducers]
    {:pre [(map? reducers) (every? fn? (vals reducers))]}
    (fn
        ([] (->> reducers
                (map (fn [[key reducer]] [key (reducer)]))
                (into {})))
        ([state action] (->> reducers
                            (map (fn [[key reducer]] [key (reducer (get state key) action)]))
                            (into {})))))
