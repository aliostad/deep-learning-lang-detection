(ns experiment.views.explore
  (:use
   noir.core
   hiccup.core
   hiccup.page-helpers
   hiccup.form-helpers
   experiment.models.suggestions
   experiment.views.common
   experiment.views.menu
   handlebars.templates)
  (:require
   [cheshire.core :as json]
   [noir.response :as resp]
   [experiment.infra.session :as session]
   [experiment.infra.models :as models]
   [experiment.models.user :as user]
   [experiment.models.profile]
   [experiment.models.events :as events]
   [experiment.views.trials :as trials]))


(defpage "/explore/*" {:as options}
  (page-frame
   ["Explore Experiments"
    :fixed-size 40
    :deps ["views/common", "views/explore"]]
   (nav-fixed (:nav (default-nav "explore")))
   [:div#crumbs]
   [:div.container {:style "min-height: 400px"}
    [:div#explore]]
   [:div#templates
    (render-all-templates)
    (bootstrap-user-json)]))
   
(defpage "/explore" {:as options}
  (resp/redirect "/explore/search"))

(deftemplate search-header
  [:div.header
   [:div {:class "well search-box"}
    [:div.pull-left
     (text-field {:class "search-query input-xxlarge"} "q" (% this))
     [:button.btn {:type "button" :class "btn search-btn"} "Search"]
     [:button.btn {:type "button" :class "btn help-btn"} "Help"]]
    [:div.pull-right
     [:div.btn-group
      [:a.btn.btn-primary.dropdown-toggle {:data-toggle "dropdown" :href "#"}
       "Create "
       [:span.caret]]
      [:ul.dropdown-menu
       [:li.menuitem
        [:a {:href "#" :class "action create-treatment"}
         "Treatment"]]
       [:li.menuitem
        [:a {:href "#" :class "action create-instrument"}
         "Instrument"]]
       [:li.menuitem
        [:a {:href "#" :class "action create-experiment"}
         "Experiment"]]]]]]
   [:div#pagination]
   [:div.row
    [:div#results.span8
     [:p]]
    [:div.span4
     [:h2 "Popular Searches"]
     [:ul
      [:li [:a.popsearch {:href "#"} "show treatments"]]
      [:li [:a.popsearch {:href "#"} "show experiments"]]
      [:li [:a.popsearch {:href "#"} "show instruments"]]]
     [:div#popular]]]])
    
;;      [:li.menuitem
;;       [:a {:href "#" :class "action create-instrument"}
;;        "Instrument"]]]]]])
      
