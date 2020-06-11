;; This controller is the app level controller and starting point.
;; It handles routing, authentication, and all global-unique
;; DOM-related events.

(ns mex.controller.app
  (:require-macros [cljs.core.async.macros :refer [go]]
                   [mex.macros.core :refer [-<>]]
                   [reagent.ratom :refer [reaction]])
  (:require [cljsjs.jquery]
            [cljs.core.async :as async]
            [cljs-time.extend] ; Not used in this namespace, extends = to work with cljs-time date values
            [mex.components.app :refer [app]]
            [mex.components.app-item :refer [app-item]]
            [mex.components.bootstrap-error :refer [bootstrap-error]]
            [mex.configuration :as configuration]
            [mex.controller.admin :as admin]
            [mex.controller.ask-reuters :as ask-reuters]
            [mex.controller.collections :as collections]
            [mex.controller.credentials :as credentials]
            [mex.controller.download :as download]
            [mex.controller.experiments :as experiments]
            [mex.controller.item :as item]
            [mex.controller.items :as items]
            [mex.controller.login-cookie-auto-refresh :as login-cookie-auto-refresh]
            [mex.controller.modal :as modal]
            [mex.controller.navigation :as navigation]
            [mex.controller.notifications :as notifications]
            [mex.controller.package-downloads :as package-downloads]
            [mex.controller.preferences :as preferences]
            [mex.controller.saved-searches :as saved-searches]
            [mex.controller.search :as search]
            [mex.controller.toasts :as toasts]
            [mex.middleware :as mw]
            [mex.re-frame :as rf]
            [mex.router :as router]
            [mex.state.core :as state]
            [mex.service.connect :as service]
            [mex.utils.analytics :as analytics-utils]
            [mex.utils.core :as utils]
            [mex.utils.dom :as dom-utils]
            [mex.utils.local-storage :as local-storage]
            [mex.utils.nav :as nav-utils]
            [reagent.core :as reagent]))

(defonce init-db
  {:page-visible? true})

(defn get-app-type []
  (let [path (utils/get-page-path true)]
    (cond
      (re-matches #".*reva.*" path) :reva
      (re-matches #".*detail.*" path) :item
      :else :all)))

(let [app-type->view-opts {:all  {:page-title "Reuters Media Express"
                                  :contact-support-url "http://reutersnewsagency.com/customer/service"
                                  :search-help-url "https://s3.amazonaws.com/reuters.mex/ReutersMediaExpressUserGuide.pdf"
                                  :reva-logo-url "/images/archive_logo.png"
                                  :logo-url "/images/mex_logo.gif"
                                  :logo-url-mobile "/images/mex_logo_sm.gif"
                                  :user-guide-url "https://s3.amazonaws.com/reuters.mex/ReutersMediaExpressUserGuide.pdf"}

                           :reva {:page-title "Archive Video | Reuters Media Express"
                                  :class "reva"
                                  :contact-support-url "http://reutersnewsagency.com/customer/service"
                                  :search-help-url "/controller/tutorial.action?first=false&decorator=detailPopup&page=10#archiveVideoSearch"
                                  :logo-url "/images/archive_logo.png"
                                  :logo-url-mobile "/images/archive_logo_sm.gif"}

                           :item {:page-title "Item | Reuters Media Express"
                                  :logo-url "/images/mex_logo.gif"
                                  :reva-logo-url "/images/archive_logo.png"
                                  :contact-support-url "http://reutersnewsagency.com/customer/service"}}]
  (defn- get-view-opts [app-type reva?]
    (let [view-opts (-<> (get app-type->view-opts app-type)
                         (assoc <> :home-path (if reva? "/reva" "/all")))]
      (if (and (= app-type :item)
               reva?)
        (assoc view-opts :logo-url (:reva-logo-url view-opts))
        view-opts))))

(defn- initialize-page-events []
  ;; -- Page Visibility
  (.addEventListener js/document "visibilitychange"
     (fn []
       (rf/dispatch [:app/set-page-visible (not= (.-visibilityState js/document) "hidden")])))

  ;; -- Page Resize
  (let [initial-media-query-result? (atom true)
        saved-searches? (state/has-features? :saved-searches?)
        mobile-useragent? (re-find #"(?i)mobi|android" (-> js/window .-navigator .-userAgent))
        media-query (if mobile-useragent?
                      "screen and (max-width: 1025px)"
                      "screen and (max-width: 600px)")
        handler (fn [view-type saved-searches?]
                  (rf/dispatch [:app/media-query view-type saved-searches? @initial-media-query-result?])
                  (reset! initial-media-query-result? false))]
    (js/enquire.register media-query #js {:match   #(handler :mobile false)
                                          :unmatch #(handler :desktop saved-searches?)})
    (. (aget js/enquire.queries media-query) assess))

  ;; -- Ellipsification
  (let [jq (js/jQuery js/window)
        ellipsify (fn [_ node]
                    (dom-utils/ellipsify! node false))
        reset-text (fn [_ node]
                     (when-let [txt (dom-utils/get-node-data node "ellipsified")]
                       (dom-utils/set-node-text! node (dom-utils/get-node-data node "text"))))
        reset-ellipsis (fn [_ node]
                         (when-let [txt (dom-utils/get-node-data node "ellipsified")]
                           (dom-utils/set-node-html! node txt)))]
    (.on jq "resize"
         (dom-utils/debounce
          (fn re-ellipsify []
            (let [nodes (js/jQuery ".ellipsify")]
              ; Doing this in passes forces a single synchronous re-render instead of re-rendering for each item.
              (.each nodes reset-text)
              (.each nodes ellipsify)
              (.each nodes reset-ellipsis)))
          80)))

  ;; -- generic window.resize for app-state --
  (. js/window addEventListener "resize" (dom-utils/debounce #(rf/dispatch [:app/window-resize]) 80)))

(defn- initialize-debug-events []
  (when goog.DEBUG
    (.addEventListener js/window "keypress"
                       (fn [e]
                         (when (= 55 (.-which e)) ; 7 key
                           (rf/dispatch-sync [:app/print-db nil]))))))

(defn initialize-controllers [app-state settings view-opts items-app?]
  (let [validate-base-url (get-in settings [:preferences :validate-base-url])
        validate-image (get-in settings [:preferences :validate-image])]

    (defn render
      ([] (render (if items-app?
                    app
                    app-item)))
      ([view]
        (reagent/render [view] (js/document.getElementById "app"))))

    (search/init items-app?)
    (credentials/init app-state)
    (collections/init)
    (item/init items-app?)
    (when items-app?
      (items/init))
    (modal/init)
    (preferences/init items-app?)
    (navigation/init (:nav-items settings))
    (when items-app?
      (saved-searches/init (:saved-searches settings)))
    (download/init (:download-counter-refresh-interval configuration/params))
    (ask-reuters/init app-state)
    (notifications/init nil)
    (package-downloads/init)
    (toasts/init)
    (admin/init settings)
    (experiments/init)

    (go
      (<! (login-cookie-auto-refresh/init "refresh-cookie" 
                                          validate-base-url
                                          validate-image
                                          (:login-cookie-refresh-interval configuration/params)
                                          (:login-cookie-max-age-in-hours configuration/params)
                                          (:page-load-login-cookie-max-age-in-hours configuration/params)))
      (router/init items-app? view-opts)
      (collections/populate-db (:collections settings))
      (when-not items-app?
        (render)))))

(defn register-topics [view-opts]
  (rf/topic :app/route
    ; This makes more sense in the router itself but we load our router last
    ; in the chain and things that want to load before router want to subscribe to
    ; route info.
    (fn [db _] (reaction (:route @db))))

  (rf/topic :app/page-visible?
    (fn [db _] (reaction (:page-visible? @db))))

  (rf/topic :app/view-options
    (fn [_ _] (reaction view-opts)))

  (rf/topic :app/is-mobile?
    (fn [db _] (reaction (:mobile? @db))))

  (rf/topic :app/page-size
    (fn [db _] (reaction (:page-size @db))))

  (rf/topic :app/view-type
    (fn [db _] (reaction (:view-type @db))))

  (rf/topic :app/selected-view
    (fn [_ _]
      (let [view-type (rf/subscribe [:app/view-type])
            is-mobile? (rf/subscribe [:app/is-mobile?])]
        (reaction
          (if @is-mobile? :list (:selected @view-type))))))

  (rf/topic :app/selected-olr-view
    (fn [db _] (reaction (:olr-view-type @db))))

  (rf/topic :app/selected-package-view
    (fn [db _]
      (let [experiments (rf/subscribe [:experiments/user-settings])]
        (reaction
          (if (:package-views? @experiments)
            (:package-view-type @db)
            nil)))))

  (rf/topic :app/last-sync
    (fn [db _] (reaction (:last-sync @db))))

  (rf/topic :app/new-items-count
    (fn [db _]
      (let [new-items (rf/subscribe [:search/current-search-new-items])
            max-items (inc (:max-new-items-number configuration/params))]
        (reaction
          (if (>= (count @new-items) max-items)
            (str max-items "+")
            (str (count @new-items)))))))

  (rf/topic :app/sidebar-open?
    (fn [db _] (reaction (:sidebar-open? @db))))

  (rf/topic :app/drawers
    (fn [db _] (reaction (:drawers @db))))

  (rf/topic :app/visited-items
    (fn [db _] (reaction (:visited-items @db))))

  (rf/topic :app/window-resize
    (fn [db _] (reaction (:window-resize @db))))

  (rf/topic :app/container-classes
    (fn [db _]
      (let [features (rf/subscribe [:preferences/features])
            is-mobile? (rf/subscribe [:app/is-mobile?])
            last-sync (rf/subscribe [:app/last-sync])
            new-items (rf/subscribe [:search/current-search-new-items])
            search-keywords (rf/subscribe [:search/current-search-keywords])
            selected-item (rf/subscribe [:item/selected])
            user-data (rf/subscribe [:preferences/user-data])]
        (reaction
          (let [roles (:roles @user-data)
                is-popout? (= (get-app-type) :item)]
            (utils/map->classes {:admin-panel-open (and (:fixed-positions-manager? @features)
                                                        (utils/not-empty? (get-in @db [:admin :components])))
                                 :desktop (not @is-mobile?)
                                 :has-keyword-search (utils/not-blank? @search-keywords)
                                 :item-detail-open (:id @selected-item)
                                 :loading (and (not is-popout?)
                                               (or (= :loading (:search @last-sync))
                                                   (= :loading (:preferences @last-sync))))
                                 :mobile @is-mobile?
                                 :new-items-notification-open (> (count @new-items) 0)
                                 :registered (some #(= % :ROLE_MEXO_REGISTERED) roles)
                                 :show-download-counter (:download-counter? @features)
                                 :sign-in-register-error (or (= :error (:sign-in @last-sync))
                                                             (= :error (:registration @last-sync)))
                                 :sign-in-register-loading (or (= :loading (:sign-in @last-sync))
                                                               (= :loading (:registration @last-sync)))
                                 :unregistered (some #(= % :ROLE_MEXO_UNREGISTERED) roles)})))))))

(defn register-handlers [items-app?]
  (rf/handler :app/initialize-db
    (fn [db [_ status settings]]
      (merge init-db
             (state/get-init-state (get-in settings [:preferences :reva?])
                                   (= status :no-channels)
                                   (:page-size configuration/params)
                                   settings))))

  (rf/handler :app/render
    mw/side-effect
    #(render))

  (rf/handler :app/media-query
    (mw/after (fn [db [_ _ _ render?]]
                (when render?
                  (rf/dispatch [:app/render]))
                (when (:mobile? db)
                  (rf/dispatch [:packages/clear-all]))))
    (fn [db [_ view-type saved-searches? _]]
      (let [mobile? (= :mobile view-type)]
        (-<> db
             (assoc-in <> [:features :saved-searches?] saved-searches?)
             (assoc-in <> [:features :clickable-search-metadata?] (and (not mobile?) items-app?))
             (assoc <> :mobile? mobile?)))))

  (rf/handler :app/set-page-visible
    (fn [db [_ v]]
      (assoc db :page-visible? v)))

  (rf/handler :app/sidebar-drawer
    (mw/analytics-event {:action "Sidebar"
                         :label (fn [_ [_ open?]] (if open? "open" "close"))})
    (fn [db [_ open?]]
      (assoc db :sidebar-open? open?)))

  (rf/handler :app/access-forbidden
    mw/side-effect ; TODO it'd be nice if we signed in users rather than redirecting
    utils/redirect-to-forbidden)

  (rf/handler :app/bootstrap-error
    mw/side-effect
    (fn [_ [_ view-opts]]
      (reagent/render [bootstrap-error (merge init-db view-opts)]
                      (js/document.getElementById "app"))))

  (rf/handler :app/local-logout
    mw/side-effect
    #(let [url (utils/get-url "/all")]
       (utils/remove-login-cookie!)
       (dom-utils/set-document-location! url)))

  (rf/handler :app/help-open
    (mw/analytics-event {:action "Help"
                         :label (fn [_ [_ _ type]] type)})
    mw/side-effect
    (fn [_ [_ url type]]
      (when url
        (dom-utils/pop-out url))))

  (rf/handler :app/topic-codes-open
    (mw/analytics-event {:action "Topic Codes"
                         :label "No results"})
    mw/side-effect
    (fn [_ _]
      (dom-utils/pop-out "http://liaison.reuters.com/tools/")))

  (rf/handler :app/header-logo
    (when items-app? mw/set-url)
    mw/clear-saved-search
    mw/clear-navigation
    (mw/analytics-event {:action "Logo clicked"})
    (mw/after #(rf/dispatch [:search]))
    (fn [db _]
      (let [current-search-path (:current-search-path db)
            new-search (assoc (search/new-search {})
                              :facets (merge (search/clear-all-facets (conj current-search-path :facets))
                                             (if (:reva? db)
                                               {:categories (search/get-categories)
                                                :regions (search/get-regions)}
                                               {:media-types (search/get-media-types)}))
                              :results (get-in db (conj current-search-path :results)))]
        (assoc-in db current-search-path new-search))))

  (rf/handler :app/location-services
    (mw/analytics-event {:action "Location services logo clicked"})
    rf/no-op)

  (rf/handler :app/footer-logo
    (mw/analytics-event {:action "Footer clicked"
                         :label "logo"})
    rf/no-op)

  (rf/handler :app/terms-of-use
    (mw/analytics-event {:action "Footer clicked"
                         :label "terms of use"})
    rf/no-op)

  (rf/handler :app/privacy-statement
    (mw/analytics-event {:action "Footer clicked"
                         :label "terms of use"})
    rf/no-op)

  (rf/handler :app/print-db
    mw/side-effect
    (fn [db [_ path]]
      (js/console.log "DB" (clj->js (get-in db path)))))

  (rf/handler :app/redirect
   (mw/analytics-event {:action "Redirect"
                        :label (fn [_ [_ type _ _]] type)
                        :callback (fn [_ [_ _ url logout?]] #(do
                                                               (when logout? (utils/remove-login-cookie!))
                                                               (dom-utils/set-document-location! url)))})
   rf/no-op)

  (rf/handler :app/enable-scrolling
    (mw/before (fn [db [_ scroll-to]]
                (when (not (:scrolling-enabled? db))
                  (if scroll-to
                    (dom-utils/enable-body-scrolling scroll-to)
                    (dom-utils/enable-body-scrolling)))))
    (fn [db _]
      (assoc db :scrolling-enabled? true)))

  (rf/handler :app/disable-scrolling
    (mw/before (fn [db _]
                 (when (:scrolling-enabled? db)
                   (dom-utils/disable-body-scrolling))))
    (fn [db _]
      (assoc db :scrolling-enabled? false)))

  (rf/handler :app/manage-scrolling
    mw/side-effect
    (fn [db _]
      (let [mobile? (:mobile? db)
            drawers (:drawers db)
            item-detail-open? (utils/not-nil? (get-in db [:selected :id]))
            search-has-keywords? (utils/not-empty? (get-in db [:search :type-and-keywords :keywords]))]
        (when mobile?
          (if (or item-detail-open?
                  (:nav-open? drawers)
                  (and (:search-open? drawers)
                       (not search-has-keywords?)))
            (rf/dispatch [:app/disable-scrolling])
            (rf/dispatch [:app/enable-scrolling]))))))

  (rf/handler :app/view-change
    (mw/analytics-event {:action "Change view type"
                         :label (fn [_ [_ view-type]] (name view-type))})
    (mw/after
      (fn [db [_ view-type]]
        (local-storage/set-item! (state/get-view-type-key (get-in db [:features :reva?])) view-type)))
    (fn [db [_ view-type]]
      (assoc-in db [:view-type :selected] view-type)))

  (rf/handler :app/olr-view-change
    (mw/after (fn [_ [_ type]]
                (if (= :top-10 type)
                  (rf/dispatch [:items/fetch-olr-top-10])
                  (rf/dispatch [:search]))))
    (fn [db [_ type]]
      (assoc db :olr-view-type type)))

  (rf/handler :app/package-view-change
    (mw/after (fn [_ [_ type]]
                (local-storage/set-item! "package-view-type" type)))
    (fn [db [_ type]]
      (assoc db :package-view-type type)))

  (rf/handler :app/update-drawer
    (mw/after #(rf/dispatch [:app/manage-scrolling]))
    (mw/after (fn [db [_ drawer-key]]
                (rf/dispatch [:app/manage-mobile-drawers drawer-key])))
    (mw/after (fn [db _]
                (let [is-mobile? (:mobile? db)
                      drawers (:drawers db)]
                  ; scroll to the top of the page when opening the nav or search drawers
                  (when (and is-mobile?
                             (or (:nav-open? drawers)
                                 (:search-open? drawers)))
                    (dom-utils/scroll-screen-to-top!)))))
    (fn [db [_ drawer-key open?]]
      (assoc-in db [:drawers drawer-key] open?)))

  (rf/handler :app/manage-mobile-drawers
    (mw/after (fn [db _]
                ; reset the mobile nav when closing
                (when (and (:mobile? db)
                           (not (get-in db [:drawer :nav-open?])))
                  (rf/dispatch [:nav/change [0]]))))
    (fn [db [_ drawer-key]]
      (let [is-mobile? (:mobile? db)
            drawers (:drawers db)]
        ; only one can be open at a time
        (if-not (and is-mobile?
                     (:nav-open? drawers)
                     (:search-open? drawers))
          db
          (if (= drawer-key :nav-open?)
            (assoc-in db [:drawers :search-open?] false)
            (assoc-in db [:drawers :nav-open?] false))))))

  (rf/handler :app/window-resize
    ; anyone that wants to handle window.resize should pile-on here
    (mw/after #(rf/dispatch [:items/build-row-height-info]))
    (mw/after #(rf/dispatch [:app/manage-scrolling]))
    (fn [db _]
      (assoc db :window-resize (utils/now-as-long)))))

(defn ^:export init [root-element-id]
  (dom-utils/scaffold (.getElementById js/document root-element-id))
  (let [app-state state/app-state
        app-type (get-app-type)
        items-app? (not= app-type :item)
        reva? (or (= app-type :reva)
                     (and (= app-type :item)
                          (utils/has-query-param-with-value? :reva "true")))
        view-opts (get-view-opts app-type reva?)
        page-title (:page-title view-opts)]

    (dom-utils/set-document-title! page-title)

    (defn- reset []
      (rf/clear-topics!)
      (rf/clear-handlers!)
      (register-topics view-opts)
      (register-handlers items-app?)
      (when item/reset (item/reset items-app?))
      (when (and items-app? items/reset) (items/reset))
      (when modal/reset (modal/reset))
      (when preferences/reset (preferences/reset items-app?))
      (when navigation/reset (navigation/reset))
      (when search/reset (search/reset items-app?))
      (when (and items-app? saved-searches/reset) (saved-searches/reset))
      (when credentials/reset (credentials/reset))
      (when ask-reuters/reset (ask-reuters/reset))
      (when download/reset (download/reset))
      (when package-downloads/reset (package-downloads/reset))
      (when notifications/reset (notifications/reset))
      (when toasts/reset (toasts/reset))
      (when router/reset (router/reset items-app?))
      (when collections/reset (collections/reset))
      (when admin/reset (admin/reset))
      (when experiments/reset (experiments/reset)))

    (reset)
    (go 
      (let [{:keys [status data] :as res} (async/<! (service/get-settings reva? (or reva?
                                                                                    (not items-app?))))]
        (case status
          :forbidden (rf/dispatch-sync [:app/access-forbidden])
          :error (rf/dispatch-sync [:app/bootstrap-error view-opts])
          (let [features (preferences/tweak-features data items-app?)
                settings (assoc data :features features)]
            (rf/dispatch-sync [:app/initialize-db status settings])
            (when items-app?
              (initialize-page-events))
            (initialize-debug-events)
            (initialize-controllers app-state settings view-opts items-app?)
            (analytics-utils/init (:preferences data))))))))

(defn reload []
  (when reset (reset))
  (when render (render)))
