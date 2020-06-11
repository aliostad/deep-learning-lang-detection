(ns com.webtalk.storage.persistence.schema
  (:gen-class)
  (:require [com.webtalk.storage.persistence.config :as config]
            [com.webtalk.storage.persistence.util   :as util]
            [clojurewerkz.cassaforte.client         :as cclient]
            [clojurewerkz.cassaforte.cql            :as cql]
            [clojurewerkz.cassaforte.query          :as query]))

(def tables-definitions
  {
   "users" {
            :user_id :varint
            :email :varchar
            :full_name :varchar
            :username :varchar
            :team_trainer :boolean
            :phone :varchar
            :position :varchar
            :avatar_url :varchar
            :enable_sms :boolean
            :type :varchar
            :city :varchar
            :job_title :varchar
            :former_job_title :varchar
            :former_place_of_employment :varchar
            :place_of_employment :varchar
            :start_date :int
            :start_date_year :int
            :end_date :int
            :end_date_year :int
            :location :varchar
            :occupation :varchar
            :industry :varchar
            :seeking_job :boolean
            :degree :varchar
            :field_of_study :varchar
            :school_name :varchar
            :primary-key [:user_id]
            }

   "entries" {
              :owner_id :varint
              :entry_id :varint
              :group_id :varint
              :type :varchar
              :title :varchar
              :text_content :text
              :url_content :varchar
              :file_content :varchar
              :primary-key [:owner_id :entry_id]
              }

   "requested_invitations" {
                            :requested_invitation_id :varint
                            :email :varchar
                            :phone :varchar
                            :enable_sms :boolean
                            :primary-key [:requested_invitation_id :email]
                            }
   "invitations" {
                  :invitation_id :varint
                  :email :varchar
                  :inviter_id :varint
                  :primary-key [:invitation_id :inviter_id]
                  }

   "user_followings" {
                      :user_id :varint
                      :following_id :varint
                      :primary-key [:user_id :following_id]
                      }

   "referrer" {
               :user_id :varint
               :referred_user_id :varint
               :primary-key [:user_id :referred_user_id]
               }

   "user_timeline" {
                    :user_id :varint
                    :entry_id :varint
                    :owner_id :varint
                    :primary-key [:user_id :entry_id]
                    }

   "groups" {
             :user_id :varint
             :group_id :varint
             :name :varchar
             :primary-key [:user_id, :group_id]
             }

   "user_groups" {
                  :user_id :varint
                  :group_id :varint
                  :grouped_user_id :varint
                  :group_name :varchar
                  :primary-key [:user_id :group_id]
                  }

   "customer_stripe_accounts" {
                               :user_id :varint
                               :stripe_id :varchar
                               :email :varchar
                               :statement_descriptor :varchar
                               :display_name :varchar
                               :timezone :varchar
                               :details_submitted :boolean
                               :charges_enabled :boolean
                               :transfers_enabled :boolean
                               :default_currency :varchar
                               :country :varchar
                               :managed :boolean  ; this must be true or we are not able to manage their account under wt
                               :primary-key [:user_id :stripe_id]
                               }

   "customer_payments" {
                        :user_id :varint
                        :stripe_id :varchar
                        :created :varint
                        :livemode :boolean
                        :paid :boolean
                        :status :varchar
                        :amount :varint
                        :currency :varchar
                        :refunded :varchar
                        :primary-key [:user_id :stripe_id]
                        }

   
   "customer_transfers" {
                         :user_id :varint
                         :stripe_id :varchar
                         :created :varint
                         :date :varint
                         :livemode :boolean
                         :amount :varint
                         :currency :varchar
                         :reversed :boolean
                         :status :varchar
                         :type :varchar
                         :primary-key [:user_id :stripe_id]
                         }
   })

(defn auto-table-options
  "Checks for compound keys and returns the clustering-column

   Example: (auto-table-options {
                                 :user_id :uuid
                                 :email :varchar
                                 :full_name :varchar
                                 :username :varchar
                                 :primary-key [:user_id, :email]
                                 })
   Will return :email"

  [columns]
  (let [clustering-column (second (columns :primary-key))]
    (when-not  (nil? clustering-column)
      {:clustering-order [[clustering-column :desc]]})))

(defn create-tables
  "Create all the defined tables within tables

   Example: (create-tables tables)"

  [tables]
  (let [conn (cclient/connect (config/cassandra-hosts))
        keyspace (config/keyspace)]
    ;; Create main keyspace
    (util/create-keyspace conn keyspace {:replication
                                          {:class "SimpleStrategy"
                                           :replication_factor (config/replication-factor)}})
    
    (cql/use-keyspace conn keyspace)

    ;; force lazy evaluation of map to ensure the side effects of create tables
    (dorun
     (map (fn [[table-name cols]]
            (let [options (auto-table-options cols)]
              (util/create-table conn table-name cols options)))
          tables-definitions))
    (cclient/disconnect conn)))

(defn clean-up
  "Clean all columnfamilies that are given in tables

   tables: [:t1, :t2, ...]
   Example: (clean-up tables)"

  [tables]
  (let [conn (cclient/connect (config/cassandra-hosts) (config/keyspace))]
    (dorun
     (map #(util/drop-table conn %) tables))
    (cclient/disconnect conn)))
