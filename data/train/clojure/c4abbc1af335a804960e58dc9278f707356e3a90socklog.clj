(ns pallet.crate.socklog
  "A [pallet](https://palletops.com/) crate to install and configure socklog
for use with runit."
  (:require
   [clj-schema.schema :refer [def-map-schema map-schema optional-path
                              sequence-of]]
   [clojure.tools.logging :refer [debugf warnf]]
   [pallet.action :refer [with-action-options]]
   [pallet.actions
    :refer [directory exec-checked-script plan-when plan-when-not
            remote-directory remote-file remote-file-arguments symbolic-link
            wait-for-file]
    :as actions]
   [pallet.actions-impl :refer [service-script-path]]
   [pallet.action-plan :as action-plan]
   [pallet.actions.direct.service :refer [service-impl]]
   [pallet.api :refer [plan-fn] :as api]
   [pallet.contracts :refer [any-value check-spec*]]
   [pallet.crate :refer [assoc-settings defmethod-plan defplan get-settings
                         target-flag? update-settings]]
   [pallet.crate-install :as crate-install :refer [crate-install-settings]]
   [pallet.crate.initd :refer [init-script-path]]
   [pallet.crate.service :as service
    :refer [supervisor-config supervisor-config-map]]
   [pallet.stevedore :refer [fragment script]]
   [pallet.script.lib :refer [log-root file] :as lib]
   [pallet.utils :refer [apply-map]]
   [pallet.version-dispatch :refer [defmethod-version-plan
                                    defmulti-version-plan]]))

(defmulti socklog-schema
  (fn socklog-schema-eval [facility] facility))

(def-map-schema socklog-base-schema
   crate-install-settings
   [[:facility] keyword?
    [:user] string?
    [:log-user] string?
    [:service-name] string?
    [:supervisor] keyword?])

(defmethod socklog-schema :unix
  [_]
  (map-schema
   :strict
   socklog-base-schema
   [[:socket] string?]))

(defmethod socklog-schema :inet
  [_]
  socklog-base-schema)

(defmethod socklog-schema :klog
  [_]
  socklog-base-schema)

(defmethod socklog-schema :ucspi
  [_]
  socklog-base-schema)

(defmacro check-socklog-settings
  [m]
  `(let [m# ~m
         f# (:facility m#)]
    (check-spec* m# (socklog-schema f#)
                 (str "socklog-" (name f#) "-schema")
                 ~(:line (meta &form)) ~*file*)))

(defmulti default-settings
  "Provides default settings, that are merged with any user supplied settings."
  (fn default-settings-eval [facility] facility))

(defn default-settings-base
  [facility]
  {:user "nobody"
   :log-user "log"
   :supervisor :runit
   ;; :log-base (fragment (file (log-root) "socklog"))
   :service-name (str "socklog-" (name facility))})

(defmethod default-settings :default
  [facility]
  (default-settings-base facility))

(defmethod default-settings :unix
  [facility]
  (assoc (default-settings-base facility)
    :socket "/dev/log"))

(defmulti-version-plan settings-map [version settings])

(defmethod-version-plan
    settings-map {:os :debian-base}
    [os os-version version settings]
  (cond
   (:install-strategy settings) settings
   :else (assoc settings
           :install-strategy :packages
           :packages ["socklog"])))

(defn- facility-kw
  [facility]
  {:pre [(keyword? facility)]}
  (keyword (str "socklog-" (name facility))))

(defplan settings
  "Settings for socklog.  The :facility keyword must be one of
    :unix, :inet, :klog or :ucspi"
  [{:keys [facility] :as settings} & {:keys [instance-id] :as options}]
  {:pre [(#{:unix :inet :klog :ucspi} facility)]}
  (let [settings (merge (default-settings facility) settings)
        settings (settings-map (:version settings) settings)]
    (check-socklog-settings settings)
    (assoc-settings (facility-kw facility)
                    settings {:instance-id instance-id})
    (supervisor-config (facility-kw facility) settings (or options {}))))

;;; # User
(defplan user
  "Create the socklog users"
  [{:keys [facility instance-id] :as options}]
  (let [{:keys [user log-user]} (get-settings (facility-kw facility) options)]
    (debugf "Create socklog user %s log-user %s" user log-user)
    (actions/user user :system true :create-home false :shell :bash)
    (actions/user log-user :system true :create-home false :shell :bash)))

;;; # Install
(defplan install
  "Install socklog"
  [{:keys [facility instance-id] :as options}]
  (let [{:keys [log-user] :as settings}
        (get-settings (facility-kw facility) options)]
    (debugf "Install socklog settings %s" settings)
    (check-socklog-settings settings)
    (directory "/var/log/socklog" :mode "0755" :owner log-user)
    (directory "/var/log/socklog/main" :mode "0755" :owner log-user)
    (crate-install/install (facility-kw facility) instance-id)))

;;; ## Provide a configuration for the socklog daemon
(defmethod supervisor-config-map [:socklog-unix :runit]
  [_ {:keys [service-name log-user user socket] :as settings} options]
  {:service-name service-name
   :run-file {:content (str "#!/bin/sh\nexec 2>&1\nexec chpst -U "
                            user " socklog unix " socket)}
   :log-run-file {:content (str "#!/bin/sh\nexec chpst -u "
                                log-user " svlogd -t main/*")}})

(defmethod supervisor-config-map [:socklog-inet :runit]
  [_ {:keys [service-name log-user user] :as settings} options]
  {:service-name service-name
   :run-file {:content (str "#!/bin/sh\nexec 2>&1\nexec chpst -U "
                            user " socklog inet")}
   :log-run-file {:content (str "#!/bin/sh\nexec chpst -u "
                                log-user " svlogd -t main/*")}})

(defmethod supervisor-config-map [:socklog-klog :runit]
  [_ {:keys [service-name log-user user] :as settings} options]
  {:service-name service-name
   :run-file {:content (str "#!/bin/sh\nexec 2>&1\nexec chpst -U "
                            user " socklog klog")}
   :log-run-file {:content (str "#!/bin/sh\nexec chpst -u "
                                log-user " svlogd -t main/*")}})

(defmethod supervisor-config-map [:socklog-ucspi :runit]
  [_ {:keys [service-name log-user user] :as settings} options]
  {:service-name service-name
   :run-file {:content (str "#!/bin/sh\nexec 2>&1\nexec chpst -U "
                            user " socklog ucspi")}
   :log-run-file {:content (str "#!/bin/sh\nexec chpst -u "
                                log-user " svlogd -t main/*")}})



;;; # Run
(defplan service
  "Run the socklog service."
  [& {:keys [action facility if-flag if-stopped instance-id]
      :or {action :manage}
      :as options}]
  (let [{:keys [supervision-options] :as settings}
        (get-settings (facility-kw facility) {:instance-id instance-id})]
    (check-socklog-settings settings)
    (service/service settings (merge supervision-options
                                     (dissoc options :instance-id)))))

(defn server-spec
  "Returns a server-spec that installs and configures socklog."
  [{:keys [facility] :as settings} & {:keys [instance-id] :as options}]
  (let [options (assoc options :facility facility)]
    (api/server-spec
     :phases
     (merge
      {:settings (plan-fn
                   (apply-map pallet.crate.socklog/settings settings options))
       :install (plan-fn
                  (user options)
                  (install options))
       :configure (plan-fn
                    ;; (configure options)
                    ;; (apply-map service :action :enable options)
                    )
       :run (plan-fn
              (apply-map service :action :start options))}))))
