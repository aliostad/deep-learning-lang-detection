(ns kanopi.view.core
  (:require [com.stuartsierra.component :as component]
            [taoensso.timbre :as timbre
             :refer-macros (log trace debug info warn error fatal report)]
            [sablono.core :refer-macros [html] :include-macros true]
            [kanopi.controller.history :as history]
            [kanopi.model.ref-cursors :as ref-cursors]
            [kanopi.model.message :as msg]
            [kanopi.view.modals.insight  :as insight]
            [kanopi.view.header :as header]
            [kanopi.view.prompt :as prompt]
            [kanopi.view.footer :as footer]
            [kanopi.view.datum :as datum]
            [kanopi.view.datum-search :as datum-search]
            [kanopi.view.literal :as literal]
            [kanopi.view.pages.settings :as settings]
            [kanopi.view.pages.teams :as teams]
            [kanopi.view.pages.user :as user]
            [kanopi.aether.core :as aether]
            [kanopi.util.browser :as browser]
            [ajax.core :as http]
            [cljs.core.async :as async]
            [om.core :as om]))

(defn root-component
  [props owner opts]
  (reify
    om/IDisplayName
    (display-name [_]
      "app-root")

    om/IWillMount
    (will-mount [_]
      (info "mounting root component"))

    om/IRender
    (render [_]
      (html
       [:div
        [:div.header-container
         (om/build header/header props)]
        [:div.page-container
         {:class [(when (get props :modal)
                    "fade-out-page")]}
         [:div.prompt-container
          (om/build prompt/prompt props)]
         (case (get-in props [:page :handler])
           :datum
           (om/build datum/container (get props :datum))

           :literal
           (om/build literal/container (get props :literal))

           (:enter :login :logout :register)
           (om/build user/authentication props)

           :settings
           (om/build settings/settings (get props :user))

           :teams
           (om/build teams/manage-teams (get props :user))

           ;; default
           (om/build datum-search/suggestions props))
         ]
        [:div.modal-container
         {:style {:display (when (get props :modal)
                             "inherit" "none")}}
         (case (get-in props [:modal :type])
           :insight
           (om/build insight/capture (get props :modal))

           ;default
           nil)
         ]
        ]
       ))))

(defn- search-results-ref-cursor [app-state]
  (->> app-state
       (om/root-cursor)
       (:search-results)
       (om/ref-cursor)))

(defn mount-root!
  [app-state container aether history ref-cursors]
  {:pre [(instance? Atom app-state)
         (not-empty @app-state)]}
  (om/root root-component
           app-state
           {:target container
            :shared (merge
                     {:aether (:aether aether)
                      :history history}
                     (ref-cursors/mk-ref-cursor-map app-state ref-cursors))}))

(defrecord Om [config app-state aether history app-container]
  component/Lifecycle
  (start [this]
    ;; NOTE: purposely not checking if already mounted to support
    ;; figwheel re-mounting om on-jsload
    (let [container (. js/document (getElementById (:container-id config))) ]

      ;; NOTE: when starting component if page is set it must be the
      ;; full string path: e.g. "/datum/<datum-id>"
      (when-let [page (not-empty (-> app-state :app-state (deref) :page))]
        (when (string? page)
          (history/navigate-to! history page)))

      (info "mount om root" (:container-id config))
      (mount-root! (:app-state app-state) container aether history (:ref-cursors config))
      (assoc this :app-container container)))

  (stop [this]
    (info "un-mount om root?")
    (assoc this :app-container nil)))

(defn new-om-root [config]
  (map->Om {:config config}))
