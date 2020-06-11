(ns pickings.core
  (:require
    [pickings.ui :as ui]
    [pickings.blueprint :as blueprint]
    [carry.core :as carry]
    [integrant.core :as ig]
    [seesaw.core :as sc]))

(defmethod ig/init-key :app
  [_ _]
  (let [app (carry/app blueprint/blueprint)
        view (ui/view (:model app) (:dispatch-signal app))]
    ((:dispatch-signal app) :on-start)
    (sc/show! view)
    (assoc app :view view)))

(defmethod ig/halt-key! :app
  [_ app]
  (sc/dispose! (:view app))
  ((:dispatch-signal app) :on-stop))

(defn new-config
  ([] (new-config nil))
  ([prev-system]
   {:app         nil
    :keylistener {:hotkey-callback-atom (-> prev-system :keylistener :hotkey-callback-atom)
                  :app                  (ig/ref :app)
                  :callback             (fn [app text]
                                          ((:dispatch-signal app) [:on-append text]))}}))