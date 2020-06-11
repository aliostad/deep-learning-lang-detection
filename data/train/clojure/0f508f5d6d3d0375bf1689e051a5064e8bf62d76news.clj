(ns blueprints.models.news
  (:require [clojure.spec :as s]
            [datomic.api :as d]
            [toolbelt.core :as tb]
            [toolbelt.datomic :as td]
            [toolbelt.predicates :as p]))


;; =============================================================================
;; Transactions
;; =============================================================================


(s/def ::avatar p/entity?)
(s/def ::action keyword?)
(s/def ::title string?)


(defn create
  "Create a new news item."
  [account content & {:keys [avatar action title]}]
  (tb/assoc-when
   {:db/id           (d/tempid :db.part/starcity)
    :news/account    (td/id account)
    :news/content    content
    :news/dismissed  false
    :news/created-at (java.util.Date.)}
   :news/title title
   :news/avatar (or (when-some [a avatar] (td/id a)) [:avatar/name :system])
   :news/action action))

(s/fdef create
        :args (s/cat :account p/entity?
                     :content string?
                     :opts (s/keys* :opt-un [::avatar ::action ::title]))
        :ret (s/keys :req [:news/account :news/content :news/dismissed :news/created-at]
                     :opt [:news/title :news/avatar :news/action]))


(defn dismiss
  "Mark `news` item as dismissed."
  [news]
  {:db/id          (td/id news)
   :news/dismissed true})

(s/fdef dismiss
        :args (s/cat :news p/entity?)
        :ret map?)


(defn welcome [account]
  (create account
          "This is your primary gateway to Starcity. For now you can <b>manage your rent and payment information</b>, but there's a lot more coming; stay tuned for updates!"
          :title "Welcome to your member dashboard!"))


(def autopay-action
  :account.rent.autopay/setup)


(defn autopay [account]
  (create account
          "Just link your bank account and you'll never have to worry about missing a rent payment."
          :action autopay-action
          :title "Set up Automatic Rent Payments"))


;; =============================================================================
;; Queries
;; =============================================================================


(defn by-action
  "Look up a news item by its `action`."
  [db account action]
  (->> (d/q '[:find ?e .
              :in $ ?action ?account
              :where
              [?e :news/action ?action]
              [?e :news/account ?account]]
            db action (:db/id account))
       (d/entity db)))

(s/fdef by-action
        :args (s/cat :db p/db? :account p/entity? :action keyword?)
        :ret (s/or :entity p/entityd? :nothing nil?))
