(ns user
  (:require [spoon.core :refer :all]
            [spoon.nodes :refer :all]
            [spoon.environments :refer :all]
            [spoon.organizations :refer :all]
            [spoon.search :as search]
            [cheshire.core :as json]
            [clojure.pprint :refer :all]
            [clojure.set :as set]
            [clojure.test :refer [run-tests run-all-tests]]
            [environ.core :refer [env]]))

(def ^:dynamic *client-config*
  (let [client-name (or (env :chef-client-name) (System/getProperty "user.name"))
        client-key (or (env :chef-client-key) (str (System/getProperty "user.home") "/.chef/" client-name ".pem"))
        chef-server (or (env :chef-server-host) "manage.chef.io")]
    (spoon.core/client-info chef-server client-name client-key)))

(defmacro with-chef-server [chef-server & body]
  `(binding [*client-config* (assoc *client-config* :chef-server-host chef-server)]
     ~@body))

(defn flip-node-environment
  "Modifies an existing node's environment to the one specified."
  [org node environment]
  (spoon.nodes/update-node-environment org node environment *client-config*))
