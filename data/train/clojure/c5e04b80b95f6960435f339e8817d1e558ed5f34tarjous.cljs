(ns tarjoushaukka.kasittelijat.tarjous
  (:require [re-frame.core :refer [register-handler dispatch]]
            [ajax.core :as ajax]
            [clojure.walk :refer [keywordize-keys]]))

(register-handler
  :hae-tarjoukset
  (fn [db [_]]
    (ajax/GET "/tarjoukset" {:handler #(dispatch [:paivita [:tarjoukset] (keywordize-keys %)])})
    db))
(defn hae-tarjoukset []
  (dispatch [:hae-tarjoukset]))

(register-handler
  :tarjous-id
  (fn [db [_ tarjous-id]]
    (assoc db :tarjous-id tarjous-id)))
(defn aseta-tarjous [tarjous-id]
  (dispatch [:tarjous-id tarjous-id]))

(register-handler
  :aloita-tiketin-liitos
  (fn [db [_ _]]
    (assoc db :liitettava-tiketti {:tunniste nil :nimi nil :arvio nil})))
(defn aloita-tiketin-liitos []
  (dispatch [:aloita-tiketin-liitos]))

(register-handler
  :aloita-tarjouksen-luonti
  (fn [db [_ _]]
    (assoc db :uusi-tarjous {:nimi nil :maksueranumero nil :tilausnumero nil})))
(defn aloita-tarjouksen-luonti []
  (dispatch [:aloita-tarjouksen-luonti]))