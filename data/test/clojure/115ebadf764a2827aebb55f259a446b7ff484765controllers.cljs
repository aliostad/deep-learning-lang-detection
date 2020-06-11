(ns motw.controllers
  (:require [cljs.core.async :as a]
            [clojure.zip :as zip]
            [motw.maps :as m]
            [motw.utils :as u]
            [cemerick.url :as url])
  (:require-macros [cljs.core.async.macros :refer [go go-loop]]))

;; State holds _whole_ app state.
(defonce state nil)
;; Internal pipe with actions. Should not be used outside ns.
(defonce actions (a/chan))

;; Declare some helpers
(declare assoc-all)
(declare assoc-norm-id)
(declare emit-gtm-event)

;; Route start and end (Store location)
(def origin {:lat 37.761731 :lng -122.414630})
(def destination {:lat 37.761751 :lng -122.414630})

;; Components call this function to request state changing.
(defn dispatch
  "Dispatch new action. Type should be keyword."
  ([type] (dispatch type nil))
  ([type data]
   (a/put! actions [type data])))

;; All state changes should be done via this method.
(defmulti transform
  "Transform state by action. Receives [state action-type data dispatch].
  Return updated state."
  (fn [s t d dispatch] t))

;; Take actions from chaneel, call handler by type with [state type data dispatch].
;; Expect handler return new state
(defn actions-loop
  "Start consuming actions."
  []
  (go-loop []
           (when-let [a (a/<! actions)]
             (let [[type data] a]
               (emit-gtm-event type)
               (println "Handle action" type)
               (try
                 (swap! state transform type data dispatch)
                 (catch js/Error e
                   (emit-gtm-event "error" {:name (.-name e)
                                            :message (.-message e)
                                            :stack (.-stack e)})
                   (js/console.error e)
                   (js/console.log "Transform " (name type) "failed"))))
             (if-not (map? @state)
               (js/console.error "Expect action " (name type) " return new state."))
             (recur))))

(defn init-state [state']
  (set! state state')
  (swap! state assoc :search {:movies ""
                              :locations ""})
  (swap! state update :movies assoc-norm-id :title)
  (swap! state update :locations assoc-norm-id :title))

(defn start! []
  (println "Start")
  (actions-loop))

(defmethod transform :search
  [s _ {t :type v :value}]
  (assoc-in s [:search t] v))

(defmethod transform :toggle-movie
  [s _ {t :title v :value}]
  (-> s
      (assoc-in [:movies t :opened?] false)
      (update-in [:movies t :checked?] #(or v (not %)))))

(defmethod transform :open-movie
  [s _ {t :title v :value}]
  (let [v' (or v (not (get-in s [:movies t :opened?])))]
    (-> s
        (update :movies assoc-all :opened? false)
        (assoc-in [:movies t :opened?] v'))))

(defmethod transform :change-page
  [s _ page dispatch]
  (when (= page :results)
    ;; For real app we need to implement cache for routes.
    ;; Just save points as key and js route object as value
    ;; But for example new request every time is fine.
    ;; Also real app should care about race conditions:
    ;;  and close channel of dropped request.
    (dispatch :route-request)
    (go (let [points (->> (u/checked-movies-locations (:movies s) (:locations s))
                          (filter :checked?)
                          (map #(select-keys % [:lat :lng])))
              [err route] (a/<! (m/build-route origin destination points))]
          (dispatch :route-result {:ok? (nil? err)
                                   :route route}))))
  (assoc s :page page))

(defmethod transform :route-request
  [s]
  (assoc s :route {:loading? true}))

(defmethod transform :route-result
  [s _ data]
  (assoc s :route data))

(defmethod transform :toggle-location
  [s _ {t :title v :value}]
  ;; Don't check any if already 8 (limit of GMAPS)
  (let [current (get-in s [:locations t :checked?])
        checked-count (count (filter (comp :checked? second)
                                     (:locations s)))]
    (if (and (or v (not current))
             (>= checked-count 8))
      s
      (-> s
        (assoc-in [:locations t :opened?] false)
        (update-in [:locations t :checked?] #(or v (not %)))))))

(defmethod transform :open-location
  [s _ {t :title v :value}]
  (let [v' (or v (not (get-in s [:locations t :opened?])))]
    (-> s
        (update :locations assoc-all :opened? false)
        (assoc-in [:locations t :opened?] v'))))

(defmethod transform :print
  [s]
  (.print js/window)
  s)


;; Helper functions

(defn- assoc-all
  "Set field in values of map."
  [m k v]
  (->> m
       vec
       (map (fn [[t i]] [t (assoc i k v)]))
       (into {})))

(defn- assoc-norm-id
  "Takes normal items map m and assoc k field in each item with id.
  (assoc-norm-id {:123 {:a true}} :fid) => {:123 {:a true :fid 123}}"
  [m k]
  (into {} (map (fn [[id i]] [id (assoc i k id)]) m)))

(defn emit-gtm-event
  "Send new event to google tag manage."
  ([name] (emit-gtm-event name {}))
  ([name data]
   (.push js/dataLayer (clj->js (merge {:event name} data)))))

