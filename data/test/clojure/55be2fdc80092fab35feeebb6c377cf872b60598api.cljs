(ns cider-ci.repository.ui.projects.edit-new.api
  (:require-macros
    [reagent.ratom :as ratom :refer [reaction]]
    )
  (:require
    [cider-ci.repository.constants :refer [CONTEXT]]
    [cider-ci.repository.ui.projects.edit-new.shared :refer [form-data dissected-git-url id project update-form-data update-form-data-value section]]
    [cider-ci.repository.ui.state :as state]
    [cider-ci.utils.core :refer [presence]]
    ))


(def suggested-api-endpoint
  (reaction
    (when-let [hostname (:host @dissected-git-url)]
      (let [protocol (if (re-matches #"(?i)http.*" (:protocol  @dissected-git-url))
                       (:protocol  @dissected-git-url)
                       "https")]
        (str protocol "://" hostname)
        ))))

(defn api-endpoint-input []
  [:div.form-group
   [:label "Remote API endpoint"]
   [:input#remote_api_endpoint.form-control
    {:placeholder @suggested-api-endpoint
     :on-change #(update-form-data-value :remote_api_endpoint (-> % .-target .-value presence))
     :on-focus #(when @suggested-api-endpoint
                  (when (clojure.string/blank? (:remote_api_endpoint @form-data))
                    (update-form-data-value :remote_api_endpoint @suggested-api-endpoint)))
     :value (-> @form-data :remote_api_endpoint) }]
   [:p.help-block "The main entry point of the remove API, e.g. " [:code "https://api.github.com"] "."]])

(defn manage-remote-push-hooks []
  [:div.checkbox
   [:label
    [:input.manage_remote_push_hooks
     {:type :checkbox
      :checked (-> @form-data :manage_remote_push_hooks)
      :on-change #(update-form-data
                    (fn [fd]
                      (assoc fd :manage_remote_push_hooks
                             (-> fd :manage_remote_push_hooks not))))}]
    "Manage remote push hooks"]
   [:p.help-block
    "Cider-CI will set up and check push hooks on the remote if this is checked." ]])

(defn send-status-notifications []
  [:div.checkbox
   [:label
    [:input.send_status_notifications
     {:type :checkbox
      :checked (-> @form-data :send_status_notifications)
      :on-change #(update-form-data
                    (fn [fd] (assoc fd :send_status_notifications
                                    (-> fd :send_status_notifications not))))
      }]
    "Send status notifications of jobs"]
   [:p.help-block
    "Cider-CI will try to send status notification for every job if this is checked." ]])

(defn api-namespace-input []
  [:div.form-group
   [:label "Remote API project name-space"]
   [:input#remote_api_namespace.form-control
    {:placeholder (:project_namespace @dissected-git-url)
     :on-change #(update-form-data-value :remote_api_namespace (-> % .-target .-value presence))
     :on-focus #(when-let [suggested-api-namespace (:project_namespace @dissected-git-url)]
                  (when (clojure.string/blank? (:remote_api_namespace @form-data))
                    (update-form-data-value :remote_api_namespace suggested-api-namespace)))
     :value (-> @form-data :remote_api_namespace) }]
   [:p.help-block "The target namespace for API calls to the remove. "
    "Also known as the owner or organization."]])

(defn api-name-input []
  [:div.form-group
   [:label "Remote API project name"]
   [:input#remote_api_name.form-control
    {:placeholder (:project_name @dissected-git-url)
     :on-change #(update-form-data-value :remote_api_name (-> % .-target .-value presence))
     :on-focus #(when-let [suggested-api-name (:project_name @dissected-git-url)]
                  (when (clojure.string/blank? (:remote_api_name @form-data))
                    (update-form-data-value :remote_api_name suggested-api-name)))
     :value (-> @form-data :remote_api_name) }]
   [:p.help-block "The target name for API calls to the remote."]])

(defn api-token-input []
  [:div.form-group
   [:label "Remote API token"]
   [:input#remote_api_token.form-control
    {:on-change #(update-form-data-value :remote_api_token (-> % .-target .-value presence))
     :value (-> @form-data :remote_api_token) }]
   [:p.help-block "The token used to authorize API calls to the remote."]])

(defn api-token-bearer-input []
  [:div.form-group
   [:label "Remote API token bearer"]
   [:input#remote_api_token_bearer.form-control
    {:on-change #(update-form-data-value :remote_api_token_bearer (-> % .-target .-value presence))
     :value (-> @form-data :remote_api_token_bearer) }]
   [:p.help-block "The bearer of the token. Most remote services don't need this information."]])

(defn api-type-input []
  [:div.form-group
   [:label "Remote API type"]
   [:select#remote_api_type.form-control
    {:on-change #(update-form-data-value :remote_api_type (-> % .-target .-value presence))
     ;:value (-> @form-data :remote_api_type)
     }
    [:option {:value nil :selected (= nil (-> @form-data :remote_api_type presence))} ""]
    [:option {:value "github" :selected (= "github" (-> @form-data :remote_api_type))} "github"]
    [:option {:value "gitlab" :selected (= "gitlab" (-> @form-data :remote_api_type))} "gitlab"]
    ]])

(defn api-input-fields []
  [:div
   [api-token-input]
   [manage-remote-push-hooks]
   [send-status-notifications]
   (when  (-> @state/server-state :config :repository_service_advanced_api_edit_fields)
     [:div
      [api-endpoint-input]
      [api-token-bearer-input]
      [api-namespace-input]
      [api-name-input]
      [api-type-input]])])

(defn component []
  [section "API"
   api-input-fields
   :toggle-keys [:project-edit :toggle-show-api]
   :description "You can set up parameters to push notifications and more."])


