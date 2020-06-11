(ns pallet.crate.openstack.nova
  (:require
    [pallet.actions
     :refer [exec-script packages]]
    [pallet.api :as api]
    [pallet.crate :refer [defplan]]
    [pallet.crate.openstack.core :as core
     :refer [restart-services template-file]]
    [pallet.crate.mysql :as mysql]))

(defplan configure-kvm []
  (template-file "etc/libvirt/qemu.conf" nil "restart-kvm")
  (exec-script "if virsh net-list | grep default ; then virsh net-destroy default; virsh net-undefine default; fi")
  (template-file "etc/libvirt/libvirtd.conf" nil "restart-kvm")
  (template-file "etc/init/libvirt-bin.conf" nil "restart-kvm")
  (template-file "etc/default/libvirt-bin" nil "restart-kvm")
  (restart-services :flag "restart-kvm" "dbus" "libvirt-bin"))

(defplan configure-nova [{{:keys [user password] :as nova} :nova
                          :keys [mysql-root-pass]
                          :as settings}]
  (mysql/create-user user password "root" mysql-root-pass)
  (mysql/create-database "nova" "root" mysql-root-pass)
  (mysql/grant "ALL" "nova.*" (format "'%s'@'%%'" user) "root" mysql-root-pass)
  (template-file "etc/nova/api-paste.ini" settings "restart-nova")
  (template-file "etc/nova/nova.conf" settings "restart-nova")
  (template-file "etc/nova/nova-compute.conf" nil "restart-nova")
  (exec-script "nova-manage db sync")
  (restart-services :flag "restart-nova"
                    "nova-api" "nova-cert" "nova-compute" "nova-conductor"
                    "nova-consoleauth" "nova-novncproxy" "nova-scheduler"))

(defn server-spec [settings]
  (api/server-spec
    :phases {:install (api/plan-fn
                        (packages :aptitude ["kvm" "libvirt-bin" "pm-utils"])
                        (packages :aptitude
                                  ["nova-api" "nova-cert" "novnc"
                                   "nova-consoleauth" "nova-scheduler"
                                   "nova-novncproxy" "nova-doc"
                                   "nova-conductor" "nova-compute-kvm"]))
             :configure (api/plan-fn
                          (configure-kvm)
                          (configure-nova settings))}
    :extends [(core/server-spec settings)]))
