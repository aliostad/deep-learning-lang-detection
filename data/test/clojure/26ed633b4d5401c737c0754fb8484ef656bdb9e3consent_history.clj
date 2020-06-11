;; Provides the configuration of the protocol managemant UIs.
(ns org.healthsciencessc.consent.commander.process.consent-history
  (:require [org.healthsciencessc.consent.commander.ajax :as ajax]
            [org.healthsciencessc.consent.commander.error :as error]
            [org.healthsciencessc.consent.commander.security :as security]
            [org.healthsciencessc.consent.client.core :as services]
            [org.healthsciencessc.consent.commander.process.common :as common]
            
            [org.healthsciencessc.consent.commander.ui.actions :as actions]
            [org.healthsciencessc.consent.commander.ui.container :as container]
            [org.healthsciencessc.consent.commander.ui.form :as form]
            [org.healthsciencessc.consent.commander.ui.layout :as layout]
            [org.healthsciencessc.consent.commander.ui.list :as list]
            
            [org.healthsciencessc.consent.common.roles :as roles]
            [org.healthsciencessc.consent.common.tenancy :as tenancy]
            
            [ring.util.response :as rutil]
            [pliant.webpoint.request :as endpoint])
  (:use     [pliant.process :only [defprocess as-method]]))

(def fields [{:name :first-name :label "First Name"}
             {:name :middle-name :label "Middle Name"}
             {:name :last-name :label "Last Name"}
             {:name :gender :label "Gender" :type :singleselect :items [{:label "Unknown" :data ""}
                                                                        {:label "Female" :data "F"}
                                                                        {:label "Male" :data "M"}]}
             {:name :dob :label "Date Of Birth" :type :date}
             {:name :zipcode :label "Zip Code"}])

(defn consenter-name
  [consenter]
  (str (:last-name consenter) ", " (:first-name consenter) " " (:middle-name consenter)))

(defn- no-results?
  [resp]
  (= (:status (meta resp)) 404))

;; Former True Values #{"true" "true-label" "selected" "on"}
(defn- consented
  [consent]
  (cond
    (true? (:consented consent)) "Agree"
    (false? (:consented consent)) "Disagree"
    (nil? (:consented consent)) "Unanswered"
    :else (:consented consent)))

;; Register View Consent History Process
(defprocess view-consent-history
  [ctx]
  (let [user (security/current-user ctx)
        org-id (common/lookup-organization ctx)]
    (if (roles/can-manage-org-id? user org-id)
      (layout/render 
        ctx "Consent History - Search"
        (container/scrollbox 
          (form/dataform 
            (form/render-fields {} fields {})))
        (actions/actions
          (actions/pushform-action
            {:url "/view/consent/history/consenters" :params {} :label "Search"})
          (actions/back-action)))
      (ajax/forbidden))))
    
(as-method view-consent-history endpoint/endpoints "get-view-consent-history")

;; Register View Consent History Consenters Process
(defprocess view-consent-history-consenters
  [ctx]
  (let [user (security/current-user ctx)
        org-id (common/lookup-organization ctx)]
    (if (roles/can-manage-org-id? user org-id)      
      (let [params (into {} (filter (fn [[k v]] (not (empty? v))) (select-keys (:query-params ctx) (map :name fields))))
            consenters (services/find-consenters params)]
        (cond
          (no-results? consenters)
            (error/view-not-found {:message "No records found that match the entered criteria."})
          (meta consenters)
            (error/view-failure {:message "Unable to execute the search."} 500)
          :else
            (let [sorting (sort-by #(str (:last-name %) " " (:first-name %) " " (:middle-name %)) consenters)]
              (layout/render 
                ctx "Consent History - Search Results"
                (container/scrollbox 
                  (list/selectlist {:action :.detail-action}
                                   (for [n sorting]
                                     {:label (consenter-name n) :data (select-keys n [:id])})))
                (actions/actions 
                  (actions/details-action 
                    {:url "/view/consent/history/consents" 
                     :params {:consenter :selected#id}
                     :verify (actions/gen-verify-a-selected "Consenter")})
                  (actions/back-action))))))
      (ajax/forbidden))))
    
(as-method view-consent-history-consenters endpoint/endpoints "get-view-consent-history-consenters")

;; Register View Consent History Consents Process
(defprocess view-consent-history-consents
  [ctx]
  (let [user (security/current-user ctx)
        org-id (common/lookup-organization ctx)]
    (if (roles/can-manage-org-id? user org-id)
      (let [consenter-id (get-in ctx [:query-params :consenter])
            consents (services/get-consents consenter-id)]
        (if (meta consents)
          (rutil/not-found (:message (meta consents)))
          (layout/render ctx "Consent History - Consents"
                         (container/scrollbox 
                           (list/labelled-list {:columns 3 :title (tenancy/label-for-consenter nil (:organization consents))}
                                               [{:label "Consenter ID:" :data (:consenter-id consents)} {} {}
                                                {:label "Last Name:" :data (:last-name consents)}
                                                {:label "First Name:" :data (:first-name consents)}
                                                {:label "Middle Name:" :data (:middle-name consents)}
                                                {:label "Gender:" :data (:gender consents)}
                                                {:label "Date Of Birth:" :data (:dob consents)}
                                                {:label "Zip Code:" :data (:zipcode consents)}])
                           (list/select-table {:headers ["Location" "Date" "Protocol ""Policy" "Consented"]}
                                              (flatten (for [encounter (:encounters consents)]
                                                         (for [consent (:consents encounter)]
                                                           {:data {:consenter consenter-id 
                                                                   :location (get-in encounter [:location :id])
                                                                   :protocol-version (get-in consent [:protocol-version :id])
                                                                   :policy (get-in consent [:policy :id])
                                                                   :encounter (:id encounter)
                                                                   :consent (:id consent)}
                                                            :labels [(get-in encounter [:location :name]) 
                                                                     (:date encounter)
                                                                     (str (get-in consent [:protocol-version :protocol :name])
                                                                          " - Version " (get-in consent [:protocol-version :version]))
                                                                     (get-in consent [:policy :name])
                                                                     (consented consent)]})))))
                         (actions/actions 
                           (actions/back-action)))))
      (ajax/forbidden))))
    
(as-method view-consent-history-consents endpoint/endpoints "get-view-consent-history-consents")
