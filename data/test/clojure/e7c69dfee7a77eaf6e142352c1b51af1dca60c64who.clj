(ns steggybot.plugins.who
  "Asks who people are"
  (:require [steggybot.db :as db]
            [steggybot.parse :refer [extract-word]]
            [datomic.api :as datomic]))

(def who-is-query '[:find ?e :in $ ?nick :where [?e :who.entry/nick ?nick]])

(defn find-entry [db nick]
  (when-let [[id] (->> db
                       (datomic/q who-is-query db nick)
                       first)]
    (datomic/entity db id)))

(defmulti handle-who
  (fn [_ c _] c))

(defmethod handle-who "add" [irc _ message]
  (def conn (db/get-conn irc))
  (def db (datomic/db conn))
  (when-let [[who-nick message] (extract-word message)]
    (def desc (:text message))
    (def entry (find-entry db who-nick))
    (if (and entry
             (= (:who.entry/submitter entry) who-nick)
             (not= who-nick (:nick message)))
      "cannot override a user's self-definition"
      (do @(datomic/transact conn [{:db/id (datomic/tempid :db.part/who)
                                    :who.entry/nick who-nick
                                    :who.entry/submitter (:nick message)
                                    :who.entry/desc desc}])
          (str "added " who-nick " as " desc " (by " (:nick message) ")")))))

(defmethod handle-who "is" [irc _ message]
  (def conn (db/get-conn irc))
  (def db (datomic/db conn))
  (when-let [[who-nick _] (extract-word message)]
    (if-let [entry (find-entry db who-nick)]
      (str who-nick " is " (:who.entry/desc entry))
      (str "no entry for " who-nick "."))))

(defmethod handle-who "added" [irc message _ rest]
  (def conn (db/get-conn irc))
  (def db (datomic/db conn))
  (when-let [[who-nick _] (extract-word message)]
    (if-let [entry (find-entry db who-nick)]
      (str "entry for " who-nick " was added by " (:who.entry/submitter entry))
      (str "no entry for " who-nick "."))))

(def plugin {:author "jneen"
             :doc {"who" "manage user descriptions"
                   "who-is" ".who is <person> : print <person>'s description"
                   "who-add" ".who add <person> <desc> : record who <person> is"
                   "who-added" ".who added <person> : print the user who set <person>'s description"}
             :schema "who.edn"
             :commands {"who" (fn [irc message]
                                (->> (extract-word message)
                                  (concat [irc])
                                  (apply handle-who)))}})
