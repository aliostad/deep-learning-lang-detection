(ns badge-displayer.db.queries 
  (:use [datomic.api :only [q db] :as d])
  (:require [badge-displayer.db.manage-datomic :refer [uri]]))

(defn pull-all-users
  []  
  "Pulls all users."
  (d/q '[:find (pull ?u [*])
         :where [?u :user/email]]
       (d/db (d/connect uri))))

(defn find-user
  [username]  
  "Finds the user based on the username."
  (d/q '[:find [?u ?username ?first-name ?last-name ?email]
         :in $ ?username
         :where       
           [?u :user/email ?email]
           [?u :user/username ?username]
           [?u :user/first-name ?first-name]
           [?u :user/last-name ?last-name]]
         (d/db (d/connect uri))
         username))

(defn pull-collection
  [username collection-name]  
  "Pulls a user's collection with its badges."
  (d/q '[:find (pull ?a [*]) 
         :in $ ?username ?collection-name
         :where  
         [?u :user/username ?username]
         [?c :collection/name ?collection-name]
         [?c :collection/user ?u]        
         [?a :assertion/uid]]
       (d/db (d/connect uri))
       username collection-name))

(defn pull-all-badges-of-user
  [username]
  "Pulls all badges of a user."
  (d/q '[:find (pull ?a [*])
         :in $ ?username       
         :where
         [?u :user/username ?username]
         [?c :collection/user ?u]
         [?a :assertion/uid]]
       (d/db (d/connect uri))
       username))
