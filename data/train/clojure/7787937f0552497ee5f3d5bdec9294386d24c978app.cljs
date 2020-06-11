(ns sculpture.admin.views.app
  (:require
    [sculpture.admin.state.core :refer [subscribe dispatch! dispatch-sync!]]
    [sculpture.admin.views.styles :refer [styles-view]]
    [sculpture.admin.views.mega-map :refer [mega-map-view]]
    [sculpture.admin.views.sidebar :refer [sidebar-view]]
    [sculpture.admin.views.page :refer [page-view]]))

(defn new-entity-button-view []
  [:button.menu {:on-click (fn [_]
                             (dispatch! [:set-main-page :actions]))}])

(defn toolbar-view []
  (if-let [user @(subscribe [:user])]
    [:div.toolbar
     [new-entity-button-view]
     [:img.avatar {:src (user :avatar)}]]
    [:div.toolbar
     [:button.auth
      {:on-click (fn []
                   (dispatch-sync! [:sculpture.user/authenticate]))}]]))

(defn app-view []
  [:div.app
   [styles-view]
   [mega-map-view]
   [toolbar-view]
   [sidebar-view]
   [page-view]])
