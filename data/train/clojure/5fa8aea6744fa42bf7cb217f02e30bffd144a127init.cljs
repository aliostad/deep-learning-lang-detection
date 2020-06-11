(ns centipair.admin.init
  (:require [centipair.admin.menu :as admin-menu]
            [centipair.core.components.notifier :as notifier]
            [centipair.admin.channels :as channel]
            [centipair.site.forms :as site-forms]
            [centipair.store.forms :as store-forms]
            [centipair.store.dashboard :as dashboard]
            [centipair.core.components.editor :refer [init-markdown-channel]]
            [centipair.site.page :refer [init-page-list-channel]]
            [centipair.user.manage :refer [;;init-user-manager-form-channel
                                           init-user-manager-list-channel
                                           ]]
            [centipair.store.product :refer [init-product-list-channel
                                             init-product-page-selector-channel]]
            [centipair.core.csrf :as csrf]
            [centipair.admin.images :refer [init-product-image-upload-channel]]))


(defn init-channels []
  (do 
    (site-forms/init-site-settings-channel)
    ;;(site-forms/init-new-site-channel)
    (store-forms/init-store-settings-channel)
    (init-markdown-channel)
    (init-page-list-channel)
    (admin-menu/init-admin-menu-channel)
    (dashboard/init-dashboard-channel)
    (init-user-manager-list-channel)
    (init-product-list-channel)
    (init-product-page-selector-channel)
    (init-product-image-upload-channel)
    ;;(init-user-manager-form-channel)
    ))


(defn ^:export init-admin []
  (do 
    (notifier/render-notifier-component)
    (csrf/fetch-csrf-token)
    (init-channels)
    (channel/render-site-selector)))
