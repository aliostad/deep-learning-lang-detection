(ns p-frame.db
  (:require-macros [reagent.ratom :refer [reaction]])
  (:require [reagent.core :as r]
            [re-frame.frame :as frame]))

(def log (fn [& xs] (apply #(js/console.log %) xs)))

(def default-db {:name (gensym "re-frame")})

(def app-db (r/atom default-db))

;;;;;;;;;;;;;;;;;;;;;
;; Register Functions

(defn register-handler [app-frame kw hand-fn]
  (frame/register-event-handler app-frame kw hand-fn))

(defn regsiter-sub [app-frame kw sub-fn]
  (frame/register-subscription-handler
   app-frame kw (partial sub-fn app-db)))

;;;;;;;;;;;;;;;;;;;;;
;;; Handler Functions

(defn init-db [_ _] default-db)

(defn set-kv [db [_ k v]] (assoc db k v))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Subscription Functions

(defn name-sub [db _] (:name @db))

;;;;;;;;;;;;;;;;;;;;
;;; Create App Frame

(defn create-app-frame
  ([] (create-app-frame (frame/make-frame nil nil)))
  ([frame]
   (-> frame
       (register-handler :init-db init-db)
       (register-handler :set-kv set-kv)
       (regsiter-sub :name name-sub))))

(def app-frame (create-app-frame))

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Dispatch and Subscribe

(defn dispatch
  ([dispatch-v] (dispatch app-db dispatch-v))
  ([app-db dispatch-v]
   (reset! app-db (frame/process-event app-frame @app-db dispatch-v))))

(defn subscribe [subscribe-v]
  (reaction (frame/subscribe app-frame subscribe-v)))


(comment

  app-db

  (dispatch [:init-db])

  @(subscribe [:name])

  ;;; Woo
  (dotimes [n 1000]
    (js/setTimeout
     #(dispatch [:set-kv :name (apply str (shuffle "qwertyuiopasdfghjklzxcvbnm"))])
     n))


  )
