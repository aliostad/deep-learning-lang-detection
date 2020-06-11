(ns views.apiary
  (:require [views.helpers :as helpers]
            [hivewing-web.paths :as paths])
  (:use hiccup.core
        hiccup.util
        hiccup.page
        hiccup.def))

(defn status
  [req hives]
  [:div.container-fluid
    [:div.row
      [:p "Your apiary is where all of your devices and hives live."]
    ]
    [:div.row
      [:h2 "Hives"]
      [:ul.list-group
        (map
          #(vector :li.list-group-item
                    [:a {:href (paths/hive-path (:uuid %))} (:name %)])
          hives)
        ]]
  ])


(defn manage
  [req]
  [:div.container-fluid
    [:div.row
      [:h2 "Update apiary"]
      [:p "Your apiary is where all of your devices and hives live."]
    ]
    [:div.row
      [:h2 "Not much just yet."]]
   ])


(defn join
  [action hives worker-url]
  [:div.wrapper
    [:form.form-join {:method "POST" :action action}
      [:h2.form-join-heading "Create a Worker"]
      (helpers/anti-forgery-field)
      [:input {:type :hidden :name :worker-url :value worker-url}]
      [:div.input-group
        [:label "Worker Name"]
        [:input.form-control {:type :text :name :worker-name :placeholder "Optional"}]
      ]
      [:div.input-group.spacing
        [:label "Select the hive"]
        [:select.form-control {:name "hive-uuid"} (map #(vector :option {:value (:uuid %)} (:name %)) hives)]
      ]
      [:button.btn.btn-primary.btn-block.btn-lg.spacing {:type "submit"} "Add Worker To Hive"]
  ]])
