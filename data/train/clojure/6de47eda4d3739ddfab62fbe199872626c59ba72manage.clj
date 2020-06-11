;; Filename: manage.clj
;; Copyright (c) 2008-2017 Clement Trösa <iomonad@riseup.net>
;; 
;; Last-Updated: 05/18/2017 Thursday 19:35:02
;; Description: Manage bot state

(ns salmon.plugins.manage
  (:require [salmon.parse :as parse]
            [clojure.string :as str]))

(defn fn-manage [irc message]
  (let [nick (get message :nick)
        args (get message :params)]
    (if (parse/admin? nick)
      (let [cmd (nth args 2)]
        (case cmd
          "--stop" (System/exit 0) 
          (format "Task `%s` not found."))) ; Default
      (str "Error, you must be an administrator."))))

(def plugin {:name "manage"
             :desc {"manage" "Maintenance commands to manage bot state"}
             :commands {"manage" fn-manage}})
