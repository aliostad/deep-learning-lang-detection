(ns clojurescript-ethereum-example.views
  (:require
   [re-frame.core :refer [dispatch subscribe]]
   [reagent.core :as r]
   [cljs-react-material-ui.reagent :as ui]
   [cljs-react-material-ui.core :refer [get-mui-theme color]]
   [clojurescript-ethereum-example.v-twitter :as v_twitter]
   [clojurescript-ethereum-example.v-dev :as v_dev]
   [clojurescript-ethereum-example.v-list :as v_list]
   [clojurescript-ethereum-example.v-users :as v_users]
   [clojurescript-ethereum-example.v-login :as v_login]
   [clojurescript-ethereum-example.utils :as u]))

(def col (r/adapt-react-class js/ReactFlexboxGrid.Col))
(def row (r/adapt-react-class js/ReactFlexboxGrid.Row))

(defn- drawer-component []
  (let [drawer (subscribe [:db/drawer])
        type   (subscribe [:db/type])]
    (fn []
      [ui/drawer {:docked false
                  :open   (:open @drawer)
                  }
       [ui/menu-item {:onTouchTap #(dispatch [:ui/drawer])} "-CLOSE-"]
       [ui/menu-item {:onTouchTap #(do
                                     (dispatch [:ui/page 0])
                                     (dispatch [:ui/drawer]))} (if (= @type "customer") "account info" "messages")]
       [ui/menu-item {:onTouchTap #(do
                                     (dispatch [:ui/page 2])
                                     (dispatch [:ui/drawer]))} "list"]
       #_[ui/menu-item {:onTouchTap #(do
                                     (dispatch [:ui/page 1])
                                     (dispatch [:ui/drawer]))} "development"]
       [ui/menu-item {:onTouchTap #(do
                                     (dispatch [:ui/page 3])
                                     (dispatch [:ui/logout])
                                     (dispatch [:ui/drawer]))} "logout"]])))

(defn- display [x y]
  (if (== x y)
    {:style {:display "block"}}
    {:style {:display "none"}}))

(defn main-panel []
  (let [page (subscribe [:db/page])]
    (fn []
      [ui/mui-theme-provider
       {:mui-theme (get-mui-theme {:palette {:primary1-color (color :light-blue500)
                                             :accent1-color  (color :amber700)}})}
       [:div
        [ui/app-bar {:title                    "Blockchain DEMO: \"carsensor.net\""
                     :onLeftIconButtonTouchTap #(do (dispatch [:ui/drawer]))}]
        [drawer-component]
        ;; default
        [:div (display @page 0)
         [v_twitter/new-tweet-component]
         [v_twitter/tweets-component]]
        ;; development
        [:div (display @page 1)
         [v_dev/dev-component0]
         [v_dev/dev-component1]]
        ;; list
        [:div (display @page 2)
         [v_list/enquiry-component]
         [v_list/list-component]]
        [:div (display @page 3)
         [v_login/login-component]
         [v_users/component0]
         ]]])))
