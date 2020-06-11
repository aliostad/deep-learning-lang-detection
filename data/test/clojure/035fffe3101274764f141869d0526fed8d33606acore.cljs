(ns cljs-redux.core)

(defn- build-store [atm]
    (fn create
        ([reducer initial-state enhancers] (((apply comp enhancers) create) reducer initial-state))
        ([reducer initial-state]
         (let [state     (atm initial-state)
               get-state (fn [] @state)
               dispatch  (fn [action] (swap! state reducer action))]
             {:dispatch dispatch :get-state get-state}))))

(defn- thunk [create-store]
    (fn [reducer initial-state]
        (let [{:keys [dispatch get-state]} (create-store reducer initial-state)
              thunked (fn thunked [action] (if (fn? action)
                                               (action {:get-state get-state :dispatch thunked})
                                               (dispatch action)))]
            {:get-state get-state :dispatch thunked})))

(defn apply-middleware [& middlewares]
    (fn [create-store]
        (fn [reducer initial-state]
            (let [store    (create-store reducer initial-state)
                  dispatch (->> middlewares
                               (map #(% store))
                               (apply comp)
                               (#(% (:dispatch store))))]
                (assoc store :dispatch dispatch)))))

(defn enhance-reducer [& enhancers]
    (fn [create-store]
        (fn [reducer initial-state]
            (->> enhancers
                (apply comp)
                (#(% reducer))
                (#(create-store % initial-state))))))

(defn combine-reducers [reducers]
    (fn [& [state action :as args]]
        (->> reducers
            (map (fn [[key reducer]]
                     (if (empty? args)
                         [key (reducer)]
                         [key (reducer (get state key) action)])))
            (into {}))))


(defn create-custom-store [atm]
    (fn
        ([reducer initial-state & enhancers] (if (fn? initial-state)
                                                 ((build-store atm) reducer (reducer) (concat [thunk initial-state] enhancers))
                                                 ((build-store atm) reducer initial-state (concat [thunk] enhancers))))
        ([reducer] ((build-store atm) reducer (reducer) [thunk]))
        ([reducer initial-state] (if (fn? initial-state)
                                     ((build-store atm) reducer (reducer) [thunk initial-state])
                                     ((build-store atm) reducer initial-state [thunk])))))

(def create-store (create-custom-store atom))
