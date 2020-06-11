;; Copyright (C) 2015, Jozef Wagner. All rights reserved.
;;
;; The use and distribution terms for this software are covered by the
;; Eclipse Public License 1.0
;; (http://opensource.org/licenses/eclipse-1.0.php) which can be
;; found in the file epl-v10.html at the root of this distribution.
;;
;; By using this software in any fashion, you are agreeing to be bound
;; by the terms of this license.
;;
;; You must not remove this notice, or any other, from this software.

(ns jogurt.util.cfg
  "Manage project's configuration."
  (:api dunaj)
  (:require [environ.core :as ec]
            [dunaj.string :as ds]))

(defn cfg :- {}
  "Returns config map. Merges contents of config.edn on a classpath
   with environment variables, that are fetched with environ and
   put under :env key."
  []
  (with-scope
    (let [conf (parse-whole edn (slurp "cp:config.edn"))
          env ec/env]
      (assoc conf :env env))))

(defn nget-in :- (Maybe Number)
  "Like get-in, but parses value with edn reader and asserts that
  it is a number. Does not parse default value. Allows nil values."
  ([cfg :- {}, ks :- Any]
   (nget-in cfg ks nil))
  ([cfg :- {}, ks :- Any, default-value :- (Maybe Number)]
   (let [ks (if (vector? ks) ks (->vec ks))]
     (when-let [v (get-in cfg ks default-value)]
       (cond
         (identical? v default-value) v
         (number? v) v
         :else (let [pv (parse-whole edn v)] 
                 (when-not (number? pv)
                   (throw (illegal-argument
                           "cannot parse value to number")))
                 pv))))))

(defn sget-in :- (Maybe String)
  "Like get-in, but coerces to string. Does not parse default value.
  Allows nil values."
  ([cfg :- {}, ks :- Any]
   (sget-in cfg ks nil))
  ([cfg :- {}, ks :- Any, default-value :- (Maybe String)]
   (let [ks (if (vector? ks) ks (->vec ks))]
     (when-let [v (get-in cfg ks default-value)]
       (cond
         (identical? v default-value) v
         (nil? v) v
         (string? v) v
         (canonical? v) (canonical v)
         :else (->str v))))))

(def bmap {"true" true "false" false
           "t" true "f" false
           "1" true "0" false
           "yes" true "no" false
           "on" true "off" false
           "enable" true "disable" false
           "enabled" true "disabled" false
           "default" :default})

(defn bget-in :- Boolean
  "Like get-in, but coerces to boolean. Does not parse default value.
  Defaults to false."
  ([cfg :- {}, ks :- Any]
   (bget-in cfg ks false))
  ([cfg :- {}, ks :- Any, default-value :- Boolean]
   (if-let [s (sget-in cfg ks nil)]
     (let [r (get bmap (ds/lower-case s))]
       (cond
         (nil? r) (throw (illegal-argument "value not recognized"))
         (identical? :default r) default-value
         :else r)))))

(defn bget :- Boolean
  "Like get, but coerces to boolean. Does not parse default value.
  Defaults to false"
  ([cfg :- {}, k :- Any]
   (bget-in cfg [k]))
  ([cfg :- {}, k :- Any, default :- Boolean]
   (bget-in cfg [k] default)))

(defn sget :- (Maybe String)
  "Like get, but coerces to string. Does not parse default value.
  Allows nil values."
  ([cfg :- {}, k :- Any]
   (sget-in cfg [k]))
  ([cfg :- {}, k :- Any, default :- (Maybe String)]
   (sget-in cfg [k] default)))

(defn nget :- (Maybe Number)
  "Like get, but coerces to number. Does not parse default value.
  Allows nil values."
  ([cfg :- {}, k :- Any]
   (nget-in cfg [k]))
  ([cfg :- {}, k :- Any, default :- (Maybe Number)]
   (nget-in cfg [k] default)))
