(ns warehouse.process.db
  (:require
   [ajax.core :refer [GET POST]]
   [re-frame.core :refer [dispatch]]))

(defmulti run-process #(vector (:type %1) (:name %1)))

(defmethod run-process
  [:xhr :import]
  [process]
  (POST (:url process)
    :params (:data process)
    :format :json
    :response-format :json
    :keywords? true
    :headers {"Content-Type" "application/json"}
    :handler (fn [response]
               (dispatch [:process-finished (:id process) :success])
               (dispatch [:success "Import succeeded"])
               (dispatch [:import-document {:components response}]))
    :error-handler (fn []
                     (dispatch [:process-finished (:id process) :error])
                     (dispatch [:error "Import failed"]))))

(defmethod run-process
  [:xhr :import-handlers]
  [process]
  (GET (:url process)
    :format :json
    :response-format :json
    :keywords? true
    :headers {"Content-Type" "application/json"}
    :handler (fn [response]
               (dispatch [:process-finished (:id process) :success])
               (dispatch [:success "Loading of import providers succeeded"])
               (dispatch [:import-providers response]))
    :error-handler (fn []
                     (dispatch [:process-finished (:id process) :error])
                     (dispatch [:error "Loading of import providers failed"]))))
