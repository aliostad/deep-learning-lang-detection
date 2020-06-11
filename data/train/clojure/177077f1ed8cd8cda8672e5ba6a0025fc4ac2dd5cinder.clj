(ns pallet.crate.openstack.cinder
  (:require
    [pallet.actions :refer [exec-script packages remote-file]]
    [pallet.api :as api]
    [pallet.crate :refer [defplan]]
    [pallet.crate.openstack.core :as core
     :refer [restart-services template-file]]
    [pallet.crate.mysql :as mysql]))

(defplan configure [{{:keys [user password] :as cinder} :cinder
                     :keys [mysql-root-pass]
                     :as settings}]
  (remote-file "/etc/default/iscsitarget"
               :content "ISCSITARGET_ENABLE=true"
               :flag-on-changed "restart-iscsi")
  (restart-services :flag "restart-iscsi" "iscsitarget" "open-iscsi")
  (mysql/create-user user password "root" mysql-root-pass)
  (mysql/create-database "cinder" "root" mysql-root-pass)
  (mysql/grant "ALL" "cinder.*" (format "'%s'@'%%'" user) "root" mysql-root-pass)
  (template-file "etc/cinder/api-paste.ini" settings "restart-cinder")
  (template-file "etc/cinder/cinder.conf" settings "restart-cinder")
  (exec-script "cinder-manage db sync")
  (exec-script
"if ! fdisk -l /dev/loop2 | grep '/dev/loop2p1'; then
dd if=/dev/zero of=cinder-volumes bs=1 count=0 seek=2G;
losetup /dev/loop2 cinder-volumes;
echo \"n\np\n1\n\n\nt\n8e\nw\n\" | fdisk /dev/loop2 || partprobe;
pvcreate /dev/loop2;
vgcreate cinder-volumes /dev/loop2;
fi;")
  (restart-services :flag "restart-cinder"
                    "cinder-api" "cinder-scheduler" "cinder-volume"))

(defn server-spec [settings]
  (api/server-spec
    :phases {:install (api/plan-fn
                        (packages :aptitude
                                  ["cinder-api" "cinder-scheduler"
                                   "cinder-volume" "iscsitarget"
                                   "open-iscsi" "iscsitarget-dkms"]))
             :configure (api/plan-fn (configure settings))}
    :extends [(core/server-spec settings)]))
