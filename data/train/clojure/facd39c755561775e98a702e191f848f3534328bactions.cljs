(ns sculpture.admin.views.pages.actions
  (:require
    [sculpture.admin.state.core :refer [dispatch!]]))

(defn actions-view []
  [:div.actions
   [:div.header
    [:h1 "Administrative Actions"]
    [:button.close {:on-click (fn [_]
                                (dispatch! [:set-main-page nil]))}
     "Close"]]

   [:div.content

    [:button
     {:on-click (fn [_]
                  (dispatch! [:sculpture.user/log-out]))}
     "Log Out"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:set-main-page :advanced-search]))}
     "Advanced Search"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:sculpture.advanced-search/go [{:key :type
                                                              :option :equals?
                                                              :value "photo"}
                                                             {:key :sculpture-id
                                                              :option :nil?
                                                              :value nil}]]))}
     "Photos w/ no Sculpture"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:set-main-page :regions]))}
     "Regions"]



    [:h2 "Create New"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:sculpture.edit/create-entity {:type "sculpture"}]))}
     "+ Sculpture"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:sculpture.edit/create-entity {:type "artist"}]))}
     "+ Artist"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:sculpture.edit/create-entity {:type "region"}]))}
     "+ Region"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:set-main-page :upload]))}
     "+ Photo"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:sculpture.edit/create-entity {:type "material"}]))}
     "+ Material"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:sculpture.edit/create-entity {:type "sculpture-tag"}]))}
     "+ Sculpture Tag"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:sculpture.edit/create-entity {:type "artist-tag"}]))}
     "+ Artist Tag"]

    [:button
     {:on-click (fn [_]
                  (dispatch! [:sculpture.edit/create-entity {:type "region-tag"}]))}
     "+ Region Tag"]]])
