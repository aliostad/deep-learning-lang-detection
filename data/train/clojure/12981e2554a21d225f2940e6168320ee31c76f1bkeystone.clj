(ns pallet.crate.openstack.keystone
  (:require
    [clojure.string :as string]
    [pallet.actions
     :refer [exec-script package remote-file service]]
    [pallet.api :as api]
    [pallet.crate :refer [defplan]]
    [pallet.crate.mysql :as mysql]
    [pallet.crate.openstack.core :as core]))

(defn exec-script-with-export [export-str script]
  (let [cmd (format "%s; %s; " export-str script)]
    (exec-script ~cmd)))

(defplan configure [{{:keys [user password] :as keystone} :keystone
                     :keys [admin-pass mysql-root-pass]
                     :as settings}]
  (mysql/create-user user password "root" mysql-root-pass)
  (mysql/create-database "keystone" "root" mysql-root-pass)
  (mysql/grant "ALL" "keystone.*" (format "'%s'@'%%'" user) "root" mysql-root-pass)
  (core/template-file "etc/keystone/keystone.conf" settings "restart-keystone")
  (remote-file "/tmp/keystone_basic.sh"
               :template "scripts/keystone_basic.sh"
               :values settings
               :literal true
               :owner "root"
               :group "root"
               :mode "0755")
  (remote-file "/tmp/keystone_endpoint_basic.sh"
               :template "scripts/keystone_endpoints_basic.sh"
               :values settings
               :literal true
               :owner "root"
               :group "root"
               :mode "0755")
  (service "mysql" :action :restart)
  (service "keystone" :action :restart)
  (exec-script "keystone-manage db_sync")
  (exec-script "sh /tmp/keystone_basic.sh")
  (exec-script "sh /tmp/keystone_endpoint_basic.sh"))

(defplan export-creds [admin-pass]
  (let [export (format
                 "export OS_TENANT_NAME=admin
                  export OS_USERNAME=admin
                  export OS_PASSWORD=%s
                  export OS_AUTH_URL=\"http://%s:5000/v2.0/\""
                 admin-pass
                 (core/primary-ip))]
    (exec-script ~export)))

(defn server-spec [{admin-pass :admin-pass :as settings}]
  (api/server-spec
    :phases
    {:install (api/plan-fn (package "keystone"))
     :configure (api/plan-fn
                  (configure settings))}
    :extends [(core/server-spec settings)]))
