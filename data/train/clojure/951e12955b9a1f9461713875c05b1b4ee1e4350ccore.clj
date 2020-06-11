(ns pallet.crate.openstack.core
  (:require
    [clojure.java.io :as io]
    [clojure.string :as string]
    [pallet.actions
     :refer [exec-checked-script exec-script package package-manager
             package-source packages plan-when remote-file remote-file-content
             service with-action-values]]
    [pallet.api :as api]
    [pallet.argument :refer [delayed]]
    [pallet.crate :as crate :refer [admin-user defplan]]
    [pallet.crate.automated-admin-user :refer [automated-admin-user]]
    [pallet.crate.etc-hosts :as etc-hosts]
    [pallet.crate.mysql :as mysql]
    [pallet.crate.sudoers :as sudoers]
    [pallet.node :as node]
    [pallet.script.lib :as lib]))

(defn private-ip []
  (node/private-ip (crate/target-node)))

(defn primary-ip []
  (node/primary-ip (crate/target-node)))

(defn export-creds-str [admin-user admin-pass ip]
  (format
    "export OS_TENANT_NAME=%1$s;
    export OS_USERNAME=%1$s;
    export OS_PASSWORD=%2$s;
    export OS_AUTH_URL=\"http://%3$s:5000/v2.0/\""
    admin-user
    admin-pass
    ip))

(defn local-file [path & substitutions]
  (let [filename (apply format path substitutions)
        r (io/reader (io/resource filename))
        tmp (io/as-file (str "/tmp/" filename))]
    (.mkdirs (io/as-file (.getParent tmp)))
    (io/copy r tmp)
    (.getCanonicalPath tmp)))

(defn template-file [resource values & [flag]]
  (apply remote-file
         (str \/ resource)
         `(~@(if values
               [:template resource :values values]
               [:local-file (local-file resource)])
           ~@(when flag [:flag-on-changed flag]))))

(defn restart-services [& [flag? flag & more :as services]]
  (if (= :flag flag?)
    (doseq [svc more]
      (service svc :action :restart :if-flag flag))
    (doseq [svc services]
      (service svc :action :restart))))

(defplan debconf-grub []
  (package-manager
    :debconf
    "grub-pc grub-pc/kopt_extracted boolean false"
    "grub-pc grub2/kfreebsd_cmdline string"
    "grub-pc grub2/device_map_regenerated note"
    "grub-pc grub-pc/install_devices multiselect /dev/sda "
    "grub-pc grub-pc/postrm_purge_boot_grub boolean false"
    "grub-pc grub-pc/install_devices_failed_upgrade boolean true"
    "grub-pc grub2/linux_cmdline string"
    "grub-pc grub-pc/install_devices_empty boolean false"
    "grub-pc grub2/kfreebsd_cmdline_default string quiet"
    "grub-pc grub-pc/install_devices_failed boolean false"
    "grub-pc grub-pc/install_devices_disks_changed multiselect /dev/sda "
    "grub-pc grub2/linux_cmdline_default string"
    "grub-pc grub-pc/chainload_from_menu.lst boolean true"
    "grub-pc grub-pc/hidden_timeout boolean false"
    "grub-pc grub-pc/mixed_legacy_and_grub2 boolean true"
    "grub-pc grub-pc/timeout string 2"))

(defplan bootstrap []
  (remote-file "/etc/hosts"
               :template "etc/hosts"
               :values {:hostname (node/hostname (crate/target-node))}
               :mode "0644"
               :owner "root"
               :group "root")
  (remote-file "/etc/apt/sources.list"
               :local-file (local-file "etc/apt/sources.list")
               :owner "root"
               :group "root"
               :mode "0644")
  (package-manager :update)
  (packages :aptitude ["ubuntu-cloud-keyring" "python-software-properties"
                       "software-properties-common" "python-keyring"]))

(def interface-snip
  "
auto %1$s
iface %1$s inet static
address %2$s
netmask %3$s")

(defn interface-str [[iface {:keys [address netmask gateway dns-nameservers]}]]
  (let [s (format interface-snip iface address netmask)
        s (if gateway
            (str s "\ngateway " gateway)
            s)]
    (if dns-nameservers
      (str s "\ndns-nameservers "
           (if (string? dns-nameservers)
             dns-nameservers
             (string/join " " dns-nameservers)))
      s)))

(defplan restart-network-interfaces [ifaces & {:keys [if-flag]}]
  (plan-when (lib/flag? (keyword if-flag))
    (doseq [iface ifaces]
      (exec-checked-script "interfaces: up->down->up"
                           (format "ifdown %1$s; ifup %1$s" iface)))))

;; by Chouser: from clojure.contrib.map-utils
(defn deep-merge-with
  "Like merge-with, but merges maps recursively, applying the given fn
only when there's a non-map at a particular level.

(deepmerge + {:a {:b {:c 1 :d {:x 1 :y 2}} :e 3} :f 4}
{:a {:b {:c 2 :d {:z 9} :z 3} :e 100}})
-> {:a {:b {:z 3, :c 3, :d {:z 9, :x 1, :y 2}}, :e 103}, :f 4}"
  [f & maps]
  (apply
    (fn m [& maps]
      (if (every? map? maps)
        (apply merge-with m maps)
        (apply f maps)))
    maps))

(def iface-sorted-map
  (sorted-map-by (fn [a b]
                   (let [m {:iface 0
                            :address 1
                            :netmask 2
                            :gateway 3
                            :broadcast 4
                            :up 5
                            :down 6
                            :pre-up 99}]
                     (< (m a 50) (m b 51))))))

(def iface-order-map
  (sorted-map-by (fn [a b]
                   (letfn [(order [x]
                             (cond (not (string? x)) 100
                                   (.startsWith x "lo") 0
                                   (.startsWith x "eth")
                                   (+ 1 (Integer. (string/replace x #"eth" "")))
                                   (.startsWith x "en")
                                   (+ 1 (Integer. (string/replace x #"en" "")))
                                   :default 99))]
                     (< (order a) (order b))))))

(defn parse-network-str [str-content]
  (let [lines (remove #(re-seq #"(?:^#)|(?:^\s*$)" %)
                      (string/split str-content #"\n"))
        ifaces (partition-all 2 (partition-by #(.startsWith % "auto") lines))]
    (into iface-order-map
          (map (fn [[[auto] iface]]
                 (when iface
                   (let [label (string/replace auto #"^auto\s+" "")
                         iface (into iface-sorted-map
                                     (reduce (partial merge-with vector)
                                             (map (fn [setting]
                                                    (let [[k & settings]
                                                          (string/split
                                                            (string/trim setting) #"\s")]
                                                      {(keyword k)
                                                       (string/join " " settings)}))
                                                  iface)))
                         [k value] (first iface)
                         value (string/join " "(rest (string/split value #"\s")))]
                     {label (assoc iface k value)})))
               ifaces))))

(defn merge-network-interfaces [m str-content]
  (deep-merge-with
    (fn [_ b] b)
    (parse-network-str str-content)
    m))

(defn str-settings-line [iface [k setting]]
  (let [setting (if (sequential? setting) setting [setting])]
    (string/join \newline
                 (map (fn [s]
                        (if (= k :iface)
                          (format "  %s %s %s" (name k) iface s)
                          (format "  %s %s" (name k) s)))
                      setting))))

(defn network-map->str [m]
  (string/join
    "\n\n"
    (map (fn [[iface spec]]
           (format "auto %s\n%s"
                   iface
                   (string/join \newline
                                (map (partial str-settings-line iface) spec))))
         m)))

;(prn (= {"eth1" (into iface-sorted-map
      ;{:iface "inet manual"
       ;:up ["ifconfig $IFACE 0.0.0.0 up"
            ;"ip link set $IFACE promisc on"]
       ;:down ["ip link set $IFACE promisc off"
              ;"ifconfig $IFACE 0.0.0.0 down"]})}

;(parse-network-str "auto eth1
  ;iface eth1 inet manual
  ;up ifconfig $IFACE 0.0.0.0 up
  ;up ip link set $IFACE promisc on
  ;down ip link set $IFACE promisc off
  ;down ifconfig $IFACE 0.0.0.0 down")))

(defplan remote-manage-network-interfaces
  "Manage the /etc/network/interfaces file, optionally keeping/modifying the
  existing content of the file.

  Args:
  - partial-fn: a function that when passed the string content of the file,
                returns a modified (or not, as the case may be) version."
  [partial-fn]
  (when partial-fn
    (let [interfaces (remote-file-content "/etc/network/interfaces")
          interfaces (with-action-values [interfaces] (partial-fn interfaces))]
      (remote-file "/etc/network/interfaces"
                   :content (delayed [_] @interfaces)
                   :literal true
                   :overwrite-changes true
                   :flag-on-changed "restart-network"))))

(defplan configure-networking [interfaces]
  ;(remote-file "/etc/network/interfaces"
               ;:template "etc/network/interfaces"
               ;:values {:interfaces
                        ;(string/join \newline (map interface-str interfaces))}
               ;:flag-on-changed "restart-network")
  (remote-manage-network-interfaces
    #(network-map->str (merge-network-interfaces interfaces %)))
  (restart-network-interfaces (filterv string? (map first interfaces))
                              :if-flag "restart-network"))

(defplan mysql-install [mysql-root-pass]
  (mysql/mysql-server mysql-root-pass)
  (package "python-mysqldb"))

(defplan mysql-configure []
  (remote-file "/etc/mysql/my.cnf"
               :local-file (local-file "etc/mysql/my.cnf")
               :flag-on-changed "restart-mysql")
  (service "mysql" :action :restart :if-flag "restart-mysql"))

(defn server-spec [{:keys [automated-admin? interfaces mysql-root-pass] :as settings}]
  (api/server-spec
    :phases
    {:bootstrap (api/plan-fn
                  (bootstrap)
                  (when automated-admin? (automated-admin-user))
                  (sudoers/sudoers
                    {}
                    {:default {:env_keep "SSH_AUTH_SOCK"}}
                    {(:username (admin-user))
                     {:ALL {:run-as-user :ALL :tags :NOPASSWD}}
                     "cinder" {:ALL {:run-as-user :ALL :tags :NOPASSWD}}
                     "glance" {:ALL {:run-as-user :ALL :tags :NOPASSWD}}
                     "keystone" {:ALL {:run-as-user :ALL :tags :NOPASSWD}}
                     "nova" {:ALL {:run-as-user :ALL :tags :NOPASSWD}}
                     "quantum" {:ALL {:run-as-user :ALL :tags :NOPASSWD}}}))
     :install
     (api/plan-fn
       (package-source "openstack-grizzly"
                       :aptitude {:url "http://ubuntu-cloud.archive.canonical.com/ubuntu"
                                  :scopes ["main"]
                                  :release "precise-updates/grizzly"})
       (package-manager :update)
       (debconf-grub)
       (package-manager :upgrade)
       (debconf-grub)
       (exec-script "apt-get -y dist-upgrade")
       (mysql-install mysql-root-pass)
       (packages :aptitude ["rabbitmq-server" "ntp" "vlan" "bridge-utils"]))
     :configure
     (api/plan-fn
       (remote-file "/etc/environment"
                    :template "etc/environment"
                    :values settings
                    :literal true)
       (exec-script "source /etc/environment")
       (when (seq (dissoc interfaces :bridge)) 0
         (configure-networking interfaces))
       (exec-script (str "sed -i "
                         "'s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' "
                         "/etc/sysctl.conf"))
       (exec-script "sysctl net.ipv4.ip_forward=1")
       (mysql-configure))}))

  ;(remote-file
    ;"/etc/apt/sources.list.d/openstack-grizzly.list"
    ;:content (str "deb http://ubuntu-cloud.archive.canonical.com/ubuntu "
                  ;"precise-updates/grizzly main"))
