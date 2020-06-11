(ns evil.fight
  (:require
   [evil.ajaj :as ajaj]
   [evil.dom :as dom]
   [evil.shiptype :as shiptype]))

(defn add-fight-line [{id "id"
                       [{fleet-a "name"
                         {user-a "name"} "user"}
                        {fleet-b "name"
                         {user-b "name"} "user"}] "fleets"}]
  (dom/append
   "#fight-list"
   (dom/c
    [:a
     {:href (str "/fight/" id)
      :target "_blank"}
     (str fleet-a "(" user-a ") vs. " fleet-b "(" user-b ")") [:br]])))

(defn start-fight []
  (let [fleet-a (dom/ival "#fleet-a")
        fleet-b (dom/ival "#fleet-b")]
    (ajaj/post-clj
     "/api/v1/fight"
     {"fleet_a" fleet-a
      "fleet_b" fleet-b}
     add-fight-line)))

(defn fight-view []
  (dom/clear "#center")
  (dom/append
   "#center"
   (dom/c
    [:div
     [:span {:id "new-fight"}]
     [:br]
     [:span {:id "fight-list"}]]))
  (ajaj/get-clj
   "/api/v1/fight"
   (fn [res]
     (let [list (dom/select "#fight-list")])
     (doall
      (map
       add-fight-line
       res))))
  (ajaj/get-clj
   "/api/v1/fleet"
   (fn [res]
     (dom/append
      "#new-fight"
      (dom/c
       [:span
        (dom/s
         [{:id "fleet-a"}]
         (fn [s]
           [:option
            {:value (s "id")}
            (s "name")])
         res)
        " vs. "
        (dom/s
         [{:id "fleet-b"}]
         (fn [s]
           [:option
            {:value (s "id")}
            (s "name")])
         res)
        " - "
        [:input
         {:value "Fight!"
          :type "submit"
          :click start-fight
          }]
        ]
       )))))

; External Functions

(defn update-fights []
  (let [div (dom/select "div#fight")]
    (dom/clear div)
    (dom/append
     div
     (dom/c
      [:span
       [:span {:click fight-view} "manage"]
       [:br]]))))