(ns dev
  (:require [bigmouth.core :as bigmouth]
            [bigmouth.interaction :as interaction]
            [bigmouth.models.account :as account]
            [bigmouth.models.keystore :as keystore]
            [bigmouth.models.subscription :as subs]
            [bigmouth.test-runner :as runner]
            [clojure.pprint :refer [pp pprint]]
            [clojure.repl :refer :all]
            [clojure.spec.test.alpha :as t]
            [clojure.tools.namespace.repl :refer [refresh]]
            [org.httpkit.server :as server]
            [integrant.core :as ig]))

(def config
  {:configs/bigmouth {:use-https? false :local-domain "localhost:8080"}
   :repository/account {}
   :repository/keystore {}
   :repository/subscription {}
   :extension/interaction {}
   :app/context {:configs (ig/ref :configs/bigmouth)
                 :accounts (ig/ref :repository/account)
                 :keystore (ig/ref :repository/keystore)
                 :subscriptions (ig/ref :repository/subscription)
                 :interaction-handler (ig/ref :extension/interaction)}
   :app/handler {:context (ig/ref :app/context)}
   :adapter/http-kit {:port 8080 :handler (ig/ref :app/handler)}})

(defmethod ig/init-key :configs/bigmouth [_ configs]
  configs)

(defmethod ig/init-key :repository/account [_ _]
  (account/simple-in-memory-account-repository))

(defmethod ig/init-key :repository/keystore [_ _]
  (keystore/simple-in-memory-keystore))

(defmethod ig/init-key :repository/subscription [_ _]
  (subs/simple-in-memory-subscription-repository))

(defmethod ig/init-key :extension/interaction [_ _]
  (reify interaction/InteractionHandler
    (follow [this account target]
      (println account "just followed" target))
    (unfollow [this account target]
      (println account "just unfollowed" target))))

(defmethod ig/init-key :app/context [_ context]
  context)

(defmethod ig/init-key :app/handler [_ {:keys [context]}]
  (bigmouth/bigmouth-routes context))

(defmethod ig/init-key :adapter/http-kit [_ {:keys [handler] :as opts}]
  (server/run-server handler (dissoc opts :handler)))

(defmethod ig/halt-key! :adapter/http-kit [_ server]
  (server))

(def system nil)

(defn go []
  (t/instrument)
  (alter-var-root #'system (constantly (ig/init config))))

(defn stop []
  (when system
    (ig/halt! system)
    (t/unstrument)
    (alter-var-root #'system (constantly nil))))

(defn reset []
  (stop)
  (refresh :after 'dev/go))

(defn run-tests []
  (t/unstrument)
  (try
    (runner/run-tests :reporter :pretty)
    (finally
      (t/instrument))))
