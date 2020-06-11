(ns copa.routes
  (:require
    [re-frame.core :refer [dispatch dispatch-sync]]
    [bidi.bidi :as bidi]
    [pushy.core :as pushy]))

;; -- Routes and History ------------------------------------------------------

(def routes ["/" {""      :home
                  "r"     {""                :recipes
                           "/"               :recipes
                           "/new"            :recipe-new
                           ["/" :id]         :recipe
                           ["/" :id "/edit"] :recipe-edit}
                  "i"     {""        :ingredients
                           "/"       :ingredients
                           ["/" :id] :ingredient}
                  "u"     {""  :user
                           "/" :user}
                  "state" {""  :db-state
                           "/" :db-state}}])

(defn- parse-url [url]
  (bidi/match-route routes url))

(defn dispatch-recipe-new [route-params]
  (dispatch [:recipe/select nil])
  (dispatch [:update/active-main-pane :recipes])
  (dispatch [:update/active-recipe-pane :edit-recipe]))

(defn dispatch-recipe-edit [route-params]
  (dispatch [:recipe/select nil])
  (dispatch [:update/active-main-pane :recipes])
  (dispatch [:recipe/select (:id route-params)])
  (dispatch [:update/active-recipe-pane :edit-recipe]))

(defn dispatch-recipe [route-params]
  (dispatch [:recipe/select nil])
  (dispatch [:update/active-main-pane :recipes])
  (if route-params
    (dispatch [:recipe/select (:id route-params)])))

(defn dispatch-ingredients [route-params]
  (dispatch [:update/active-main-pane :ingredients])
  (if route-params
    (dispatch [:ingredient/select (:id route-params)])))

(defn dispatch-user [route-params]
  (dispatch [:update/active-main-pane :user]))

(defn dispatch-state [route-params]
  (dispatch [:update/active-main-pane :db-state]))

(defn- dispatch-route [{:keys [handler route-params]}]
  (let [handler-fn (handler {:recipes     dispatch-recipe
                             :recipe      dispatch-recipe
                             :recipe-new  dispatch-recipe-new
                             :recipe-edit dispatch-recipe-edit
                             :ingredients dispatch-ingredients
                             :ingredient  dispatch-ingredients
                             :user        dispatch-user
                             :db-state    dispatch-state})]
    (when handler-fn
      (handler-fn route-params))))

(def history (pushy/pushy dispatch-route parse-url))

(defn app-routes []
  (pushy/start! history))

(def url-for (partial bidi/path-for routes))

(defn push-url-for [handler & params]
  (let [url (apply url-for handler params)]
    (pushy/set-token! history url)))