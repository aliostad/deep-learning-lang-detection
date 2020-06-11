(ns storable.compound-key
  "Helps manage compound keys in Datomic."
  (:require [datomic.api :as d]))

(defprotocol CompoundKey
  (find-existing [this] "Return arguments for d/q that represents a query to find an existing entity."))

(defn create-or-update-tx [ck]
  [[:storable.compound-key/create-or-update (into {} ck) (find-existing ck)]])

(defn create-or-update! [conn ck]
  (d/transact conn (create-or-update-tx ck)))

(def create-or-update-db-fn [{:db/id (d/tempid :db.part/user)
                              :db/ident :storable.compound-key/create-or-update
                              :db/fn (d/function {:lang "clojure"
                                                  :params '[db entity finder]
                                                  :code '(if-let [eid (ffirst (apply q (first finder) db (rest finder)))]
                                                           [(merge entity {:db/id eid})]
                                                           [entity])})}])

(comment 
  ;; This is an exmaple for how to implement a compound-key
  ;; find-existing function. Probably could use a macro to help make
  ;; defining this easier.
  ;;
  ;; NOTE: You must add into your database the create-or-update-db-fn
  (defrecord JobHistory []
    CompoundKey
    (find-existing [this] 
      `[[:find ~'?e 
         :in ~'$ ~'?sub-req-id ~'?sub-id
         :where 
         [~'?e :job-history/sub-req-id ~'?sub-req-id]
         [~'?e :job-history/sub-id ~'?sub-id]]
        ~(:job-history/sub-req-id this)
        ~(:job-history/sub-id this)]))
  
  ;; Now, you can treat this as a compound key as follows:
  (create-or-update! conn (map->JobHistory {:job-history/sub-req-id 1 :job-history/sub-id 1 :job-history/note "Hi"}))

  ;; This will update the existing entity instead of creating a new one.
  (create-or-update! conn (map->JobHistory {:job-history/sub-req-id 1 :job-history/sub-id 1 :job-history/note "Bye"})))
