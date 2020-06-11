(ns blog.core
  (:require [reagent.core :as reagent :refer [atom]]
            [reagent.session :as session]
            [re-frame.core :refer [dispatch dispatch-sync subscribe]]
            [re-frame.db :refer [app-db]]
            [secretary.core :as secretary :include-macros true]
            [accountant.core :as accountant]
            [goog.events :as events]
            [goog.history.EventType :as EventType]

            [blog.devtool :refer [devtool]]
            [blog.state.handlers]
            [blog.state.devtool-subs]
            [blog.main.post-widget :refer [default-post-widget]]
            [blog.main.single-post :refer [single-post-widget]]
            [blog.main.editor :refer [editor-container editor-sidebar-container]]
            [blog.main.user-editor :refer [user-editor]]
            [blog.main.register-view :refer [register]]
            blog.state.editor-subs
            blog.state.subs 
            blog.state.single-post-handlers
            blog.state.single-post-subs
            blog.state.landing-page-handlers
            [blog.loginview :refer [loginview]]
            blog.state.login-subs
            [blog.main.importer :refer [import-gui]])
  (:import goog.History))

(let [h (History.)]
  (goog.events/listen h EventType/NAVIGATE #(secretary/dispatch! (.-token %)))
  (doto h (.setEnabled true)))

;; -------------------------
;; Views

(defn current-page []
  (let [devtool-vis? (subscribe [:devtool-visible?])
        settings (subscribe [:settings])]
    (fn []
      (let [current-main [(session/get :current-main)]
            current-bar [(session/get :current-sidebar)]]
        (js/window.scrollTo 0 0)
        (if (first current-main)
          [:div
           [:header [:a {:href "/"}
                     (:blog-title @settings)]]
           [:div#container
            [:div#page
             current-main]
            [:div#sidebar
             (if (first current-bar)
               current-bar
               [loginview])]]
           #_[devtool @app-db @devtool-vis?]]
          [:div])))))

;; -------------------------
;; Routes

(secretary/defroute "/blog/" []
  (secretary/dispatch! "/blog/page/1"))

(secretary/defroute "/blog/page/:nr" {:keys [nr]}
  (dispatch [:is-empty?])
  (dispatch [:load-settings-with-page-nr (js/parseInt nr)])
  (dispatch [:load-grouper])
  (session/put! :current-sidebar #'loginview)
  (session/put! :current-main #'default-post-widget))

(secretary/defroute "/blog/post/:id" {:keys [id]}
  (dispatch [:load-settings])
  (dispatch [:load-post-full (js/parseInt id)])
  (dispatch [:load-grouper])
  (session/put! :current-main #'single-post-widget))

(secretary/defroute "/blog/post/:id/:version" {:keys [id version]}
  (dispatch [:load-settings])
  (dispatch [:load-versioned-post-full (js/parseInt id) (js/parseInt version)])
  (dispatch [:load-grouper])
  (session/put! :current-main #'single-post-widget))

(secretary/defroute "/blog/user-editor" []
  (dispatch [:load-settings])
  (dispatch [:load-grouper])
  (session/put! :current-main #'user-editor))

(secretary/defroute "/blog/register" []
  (dispatch [:load-settings])
  (dispatch [:load-grouper])
  (session/put! :current-main #'register))

(secretary/defroute "/blog/create-post" []
  (dispatch [:load-settings])
  (dispatch [:load-grouper])
  (dispatch [:start-new-post])
  (session/put! :current-main #'editor-container)
  (session/put! :current-sidebar #'editor-sidebar-container))

(secretary/defroute "/blog/import/atom" []
  (dispatch [:load-settings])
  (dispatch [:load-grouper])
  (session/put! :current-main #'import-gui))

(secretary/defroute "/" []
  (dispatch [:query-landing-page]))

;; -------------------------
;; Initialize app

(defn mount-root []
  (let [target (.getElementById js/document "app")]
    (reagent/render [current-page] target)))

;;Called in $blogroot/env/dev/cljs/blog/dev.cljs
(defn init! []
  (accountant/configure-navigation!
    {:nav-handler
     (fn [path]
       (secretary/dispatch! path))
     :path-exists?
     (fn [path]
       (secretary/locate-route path))})
  (secretary/dispatch! (.-pathname (.-location js/window)))
  (mount-root)
  (js/console.log "init!"))

