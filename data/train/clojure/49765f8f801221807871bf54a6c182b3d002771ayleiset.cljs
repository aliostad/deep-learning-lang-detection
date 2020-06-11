(ns tarjoushaukka.kasittelijat.yleiset
  (:require [re-frame.core :refer [register-handler dispatch dispatch-sync]]
            [tarjoushaukka.db :as db]))

(register-handler
  :aseta-paneeli
  (fn [db [_ paneeli]]
    (assoc db :paneeli paneeli)))
(defn aseta-paneeli [paneeli]
  (dispatch [:aseta-paneeli paneeli]))

(register-handler
  :alusta-db
  (fn [_ _]
    db/default-db))
(defn alusta-db []
  (dispatch-sync [:alusta-db]))

(register-handler
  :paivita
  (fn [db [_ polku arvo]]
    (assoc-in db polku arvo)))
(defn paivita [polku arvo]
  (dispatch [:paivita polku arvo]))

(register-handler
  :tyhjenna
  (fn [db [_ path]]
    (if (= 1 (count path))
      (dissoc db (first path))
      (update-in db (take (dec (count path)) path)
                 dissoc (last path)))))
(defn tyhjenna [polku]
  (dispatch [:tyhjenna polku]))