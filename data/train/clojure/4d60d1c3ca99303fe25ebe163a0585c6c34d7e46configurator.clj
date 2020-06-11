(ns pointslope.elements.configurator
  "A component to manage application configuration.
  Once this component has been added to the system map,
  all loaded configuration items are located under the
  settings key of the configurator component. However, it
  is recommended to use read-setting which will throw an 
  exception if the value is not found."
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [com.stuartsierra.component :as component]
            [environ.core :as system]
            [immuconf.config :as cfg]))

;; --- helper functions ---

(defn- environment-keyword
  "Normalizes the environment name into a keyword.
  Defaults to :dev if no value is found."
  [env-name]
  (if-not env-name
    :dev
    (keyword (str/replace env-name #"\"" ""))))

(defn- find-resource-files
  "Returns the sequence of configuration files that will be read for
  the given environment."
  [files]
  (let [xform (comp
               (map io/resource)
               (remove nil?))]
    (sequence xform files)))

(defn- load-config
  "Loads configuration from EDN resource files."
  [files]
  (let [resources (find-resource-files files)]
    (when (seq resources)
      (apply cfg/load resources))))

;; --- component implementation --- 

(defrecord Configurator [settings env files]
  component/Lifecycle
  (start [this]
    (cond settings
          this

          (and env (seq files))
          (assoc this :settings (load-config files))

          :else
          (throw
           (ex-info
            "Missing required configuration"
            {:message "Both an APP_ENV and sequence of config file paths are required"
             :env env :files files}))))
  
  (stop [this]
    (if-not settings
      this
      (assoc this :settings nil))))

;; --- public api ---

(defn new-configurator
  "Creates a new Configuration component for an environment (defaults
  to the value of the APP_ENV) environment variable. You may provide
  a list of files that are on the resource path. Otherwise, the defaults 
  of [config/base.edn config/{app_env}.edn] will be used."
  ([]
   (let [app-env  (environment-keyword (system/env :app-env))
         env-conf (str "config/" (name app-env) ".edn")]
     (new-configurator app-env "config/base.edn" env-conf)))

  ([env-kw & base-files]
   (map->Configurator {:env env-kw :files base-files})))

(defn read-setting
  "Attempts to find the configuration setting value
  specified by the key-path in the settings collection
  of the given configurator.
  
  Example: assuming a started configurator component is 
  located under the :config key of a Pedestal request map...
  
  (read-setting (get-in ctx [:request :config]) :timeouts :read)"
  [configurator & key-path]
  (apply cfg/get (:settings configurator) key-path))
