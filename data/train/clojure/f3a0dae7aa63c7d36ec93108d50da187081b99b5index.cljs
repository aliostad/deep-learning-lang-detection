(ns elixir-cljs.ui.views.index
  (:require
    [re-frame.core :refer [dispatch subscribe]]
    [elixir-cljs.ui.containers.authenticated :refer [authenticated-container]]
    [elixir-cljs.ui.components.top-navbar :refer [top-navbar]]
    [elixir-cljs.ui.views.registration.index :refer [registration-view]]
    [elixir-cljs.ui.views.session.index :refer [session-view]]
    [elixir-cljs.ui.views.admin.index :refer [admin-view]]))

(defn root-view []
  [:div
   [:h2 "Welcome to the App!"]
   [:button {:on-click #(dispatch [:nav/goto :login])} "Sign In"]
   [:button {:on-click #(dispatch [:nav/goto :registration])} "Register"]
   [:button {:on-click #(dispatch [:nav/goto :content])} "Protected"]
   [:button {:on-click #(dispatch [:nav/goto :admin])} "Admin"]]
  )

(defn index-view []
  (let [nav (subscribe [:nav/get-nav])]
    (fn []
      [:div
       [top-navbar]
       (if-not (= @nav :root)
         [:span
          [:button {:on-click #(dispatch [:nav/goto :root])} "Home"]
          [:hr]])
       (case @nav
         :root [root-view]
         :admin [admin-view]
         :login [session-view]
         :registration [registration-view]
         :content [authenticated-container [:div "If you can see this, you are authenticated."]]
         (dispatch [:nav/goto :root]))])))
