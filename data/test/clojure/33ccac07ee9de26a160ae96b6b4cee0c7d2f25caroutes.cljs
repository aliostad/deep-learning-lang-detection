(ns salava.badge.ui.routes
  (:require [salava.core.ui.layout :as layout]
            [salava.core.ui.helper :refer [base-path private?]]
            [salava.badge.ui.my :as my]
            [salava.badge.ui.info :as info]
            [salava.badge.ui.embed :as embed]
            [salava.badge.ui.embed-pic :as embed-pic]
            [salava.badge.ui.importer :as imp]
            [salava.badge.ui.exporter :as exp]
            [salava.badge.ui.upload :as up]
            [salava.core.helper :refer [dump]]
            [salava.badge.ui.stats :as stats]
            [reagent.session :as session]
            [salava.badge.ui.modal :as badgemodal]
            [salava.core.i18n :as i18n :refer [t]]))

(defn placeholder [content]
  (fn [site-navi params]
    #(layout/default site-navi content)))


(defn ^:export routes [context]
  {(str (base-path context) "/badge") [["" my/handler]
                                       ["/mybadges" my/handler]
                                       [["/info/" :badge-id] info/handler]
                                       [["/info/" :badge-id "/embed"] embed/handler]
                                       [["/info/" :badge-id "/pic/embed"] embed-pic/handler]
                                       ["/import" imp/handler]
                                       ["/upload" up/handler]
                                       ["/export" exp/handler]
                                       ["/stats" stats/handler]]})

(defn badge-navi [context]
  {(str (base-path context) "/badge") {:weight 20 :title (t :badge/Badges)   :top-navi true  :breadcrumb (t :badge/Badges " / " :badge/Mybadges)}
   (str (base-path context) "/badge/mybadges") {:weight 20 :title (t :badge/Mybadges) :site-navi true :breadcrumb (t :badge/Badges " / "  :badge/Mybadges)}
    
  
   (str (base-path context) "/badge/stats") {:weight 21
                                             :title (t :badge/Stats)
                                             :site-navi true
                                             :breadcrumb (t :badge/Badges" / " :badge/Stats)}
   (str (base-path context) "/badge/info/\\d+") {:breadcrumb   (t :badge/Badges " / " :badge/Badgeinfo)}}
  )

(defn badge-manage [context]
  {"/badge/dropdowntitle" {:weight 22
                           :title (t :badge/Manage)
                           :site-navi true
                           :breadcrumb ""
                           :dropdown true
                           :items {(str (base-path context) "/badge/import") {:weight 1
                                                                              :title (t :badge/Import)
                                                                              :site-navi true
                                                                              :dropdown-item true
                                                                              :breadcrumb (t :badge/Badges " / " :badge/Manage " / " :badge/Import)}
                                   (str (base-path context) "/badge/upload") {:weight 2
                                                                              :title (t :badge/Upload)
                                                                              :site-navi true
                                                                              :dropdown-item true
                                                                              :breadcrumb (t :badge/Badges " / " :badge/Manage " / " :badge/Upload)}
                                   (str (base-path context) "/badge/export") {:weight 3
                                                                              :title (t :badge/Export)
                                                                              :site-navi true                                                                              
                                                                              :dropdown-item true
                                                                              :breadcrumb (t :badge/Badges " / " :badge/Manage " / " :badge/Export)}}}})


(defn ^:export navi [context]
  (if (private?)
    (badge-navi context)
    (assoc (badge-navi context) (first (keys (badge-manage context))) (first (vals (badge-manage context)))))
  
  )

