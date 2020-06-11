;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; o-O-o                 o   o         o  ;;
;;   |                   |\ /|         |  ;;
;;   |   o-o o-o o-o     | O | o  o  o-O  ;;
;;   |   |   |-' |-'     |   | |  | |  |  ;;
;;   o   o   o-o o-o     o   o o--o  o-o  ;;
;;                                        ;;
;; COPYRIGHT © 2010 Nathanael Cunningham  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; COPYRIGHT © 2010 Nathanael Cunningham, all rights reserved
;;  The use and distribution terms for this software are covered by the
;;  Eclipse Public License 1.0 (http://opensource.org/licenses/eclipse-1.0.php)
;;  which can be found in the file LICENSE at the root of this distribution.
;;  By using this software in any fashion, you are agreeing to be bound by
;;       the terms of this license.
;;  You must not remove this notice, or any other, from this software.



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; :doc Functions for working the account managment		       ;;
;;        process. Should be used from treemud.account file instead of ;;
;;        here. This is also where you modifiy the account managment   ;;
;;        process and the PC creation process.			       ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(ns treemud.account.manage
  (:refer-clojure :exclude [load])
  (:use [treemud.server comm util]
	treemud.account.file
	)
  (:require 
   [treemud.utils.passwd :as passwd]))


;(defn create-character [user]

(defn indexed
  "Returns a lazy sequence of [index, item] pairs, where items come
from 's' and indexes count up from zero.

(indexed '(a b c d)) => ([0 a] [1 b] [2 c] [3 d])
Taken from clojure.contrib 1.2 
https://github.com/arohner/clojure-contrib/blob/1.3-compat/src/main/clojure/clojure/contrib/seq_utils.clj"
  [s]
  (map vector (iterate inc 0) s))


(def account-menu-text
"
From here you can:
  [E]nter the mud,
  [C]reate a new character,
  [V]iew your account status, or
  [U]pdate your account.
What would you like to do? ")




(defn- account-menu-loop 
  "Returns which option the user choose."
  [user]
  (option-loop user account-menu-text ["enter" "create" "view" "update"]))

(defn- format-pc-table 
  "Makes a string holding a table of pcs in the account. Takes a seq
of pcs in the account, in order they are to be chosen from."
  [pcs]
  (if-not (empty? pcs)
    (reduce str 
	    (for [[n pc-data] (indexed (vals pcs))]
              (let [pc (first pc-data)]
                (format "%d - %s (%d %s %s)\n\r" 
                        (inc n) (:name pc)
                        (:level pc) (:race pc) (:class pc)))))))
  
(defn- select-character 
  "Lists the avalible PCs, then returns the one chosen. (IO)"
  [user]
    (let [pcs (load-pcs (:account user))]
      (if (or (not pcs) (empty? pcs))
	(do (sendln user "You don't have any characters...")
	    nil)
	(let [choice (option-loop user (str "Please select one of the following:\n\r"
					    (format-pc-table pcs))
				  (map str (range 1 (inc (count pcs)))))]
	  (nth (vals pcs) (dec (Integer. choice)))))))

(defn- valid-character-name?
  "Vaidates the chosen PC name."
  [input]
  (re-matches #"[A-Z][a-z']+(?: [A-Z][A-Za-z']+)*" input))


(defn- create-character 
  "Runs the user make all the nessesary character creation choices. Then once complete, returns the new PC."
  [user]
  ; go through all options, return new character, allow for aborts
  (let [name (query-loop user input "Please enter your character's full name:" 
			 (and (if-not (valid-character-name? input)
				(do (sendln user "Invalid name.")
				    false) true)
			      (if (pc-exists? input)
				(do (sendln user "Name already in use.")
				    false) true)))
	short  (loop [msg (promptln user "Please enter a short description:")]
		 (if (ask-yn user (format "Is '%s' correct?" msg))
		   msg
		   (recur (promptln user "Please enter a short description:"))))
        sex (option-loop user "Please choose your sex [male female]" ["male" "female"])
				
	race (option-loop user "Please choose a race [human elf dwarf gnome halfling hobbit]" ["human" "elf" "dwarf" "gnome" "halfling" "hobbit"])
	class (option-loop user "Please choose a class [fighter rouge wizard cleric]:" ["fighter" "rouge" "wizard" "cleric"])]
    (working-done user "Creating PC" 
		  
                  (create-pc (:account user) name {:short short :race race :class class :level 1 :sex (keyword sex)}))))
	
    
    
(def account-table "%s's Account
Email: %s
RPoints: %s
Characters: 
%s")

(defn- show-account-status
  "Shows the user his account information, including name email RPoints and characters."
  [user]
  ;; show email, score, characters in expanded view and any other data, then hold for enter.
  (sendln user (let [{:keys [name email rpoints]} @(:account user)]
		 (format account-table
			 name
			 email 
			 rpoints
			 (or (format-pc-table (load-pcs (:account user)))
			     "None.")))))

(defn- update-account 
  "Allows the user to update his password or email."
  [user]
					; allows the user to change his password or email.
    (letfn [(ask-update-choice [user]
			       (option-loop user "Would you like to change your:
 [Email]
 [Password]
 or just go [Back]?"
					    ["email" "password" "back"]))]
      (loop [choice (ask-update-choice user)]
	(condp = choice
	  "email"
	  (let [email (query-loop user input "And what is your new email?"
				  (if (valid-email? input)
				    input) "Invalid email...")]
	    (working-done user "Changing Email"
			  (dosync 
			   (save (commute (:account user) assoc :email email)))) 
	    (recur (ask-update-choice user)))
	  
	  "password"
	  (let [input (ask-password user)]
	    (working-done user "Changing Password"
			  (save (dosync
			   (commute (:account user)
				    assoc :passwd (passwd/passwd-hash (str (.substring name 3)
									   ":" input))))))
	    (recur (ask-update-choice user)))
	  "back"
	  nil))))






(defn manage-account 
  "The core function for running throug the parts of the user creation process."
  [user]

  (sendln user "Welcome %s" (:name @(:account user)))
  (loop  [option (account-menu-loop user)]
    (condp = option
      "enter"
      (if-let [character (select-character user)]
	 character
	(recur (account-menu-loop user)))
      "create"
      (if-let [character (create-character user)]
	character
	(recur (account-menu-loop user)))
      "view"
      (do (show-account-status user)
	  (recur (account-menu-loop user)))
      "update"
      (do (update-account user)
	  (recur (account-menu-loop user))))))

		      
	      
	       
