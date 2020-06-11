(ns herald.use-cases.manage-user
  (:require [herald.db :as db]
            [taoensso.timbre :as log]
            [schema.core :as s]
            [schema.macros :as sm]
            [blancas.morph.monads :refer [either left right run-right]]
            [herald.models [user :as user-mdl]]
            [herald.schemas :refer [->HError]])
  (:import [blancas.morph.monads Either]))

(defn- unique-email?
  [email]
  ((comp nil? run-right)
    (user-mdl/get-by-email email)))

(defn to-user-data
  [email the-secret]
  {:email email
   :password the-secret
   :active true})

(sm/defn add-user :- Either
  [email :- s/Str
   password :- s/Str]
  (if-not (unique-email? email)
    (left
      (->HError (format "User with email `%s` already exists in DB." email) email))
    (either [new-user (user-mdl/create (to-user-data email password))]
      (do
        (log/error "Cant create new user.\n" new-user)
        (left (->HError "Failed to save new user." new-user)))
      ;;return users data if all went well
      (user-mdl/get-by-id (:id new-user)))))

(sm/defn authorize-or-signup :- Either
  [email :- s/Str
   password :- s/Str]
  (if (unique-email? email)
    (add-user email password)
    (either [user (user-mdl/get-by-email email)]
      (left (->HError "User with given email doesnt exists." user))
      (if (user-mdl/correct-login? (:id user) password)
        (right user)
        (left (->HError "Login failed - wrong credentials." user))))))


(sm/defn change-password :- Either
  "changes a password for existing iff previous password is correct
  returns: hash-map with updated data;"
  [user-id :- s/Int
   old-password :- s/Str
   new-password :- s/Str]
  (if-not (user-mdl/correct-login? user-id old-password)
    (left (->HError "Failed to change password - Current password doesnt match." nil))
    ;;-- change the password & return updated user data
    (user-mdl/update user-id
                     {:password (user-mdl/encrypt-password new-password)})))

(sm/defn deactivate-user :- Either
  [user-id :- s/Int
   password :- s/Str]
  (if (user-mdl/correct-login? user-id password)
    (user-mdl/update user-id {:active false})
    (left (->HError "Failed to close account - wrong password." user-id))))

