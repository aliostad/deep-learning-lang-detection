(ns pallet.crate.openstack.quantum
  (:require
    [clojure.string :as string]
    [pallet.actions :refer [exec-script packages remote-file service]]
    [pallet.api :as api]
    [pallet.crate :refer [defplan]]
    [pallet.crate.openstack.core :as core
     :refer [interface-str restart-network-interfaces restart-services template-file]]
    [pallet.crate.mysql :as mysql]))

(defplan add-bridge [bridge]
  (exec-script
    ~(format "if ! ovs-vsctl br-exists %1$s; then ovs-vsctl add-br %1$s; fi"
            bridge)))

(defplan add-port [bridge port]
  (exec-script
    ~(format "if ! ovs-vsctl list-ports %1$s | grep %2$s;
             then ovs-vsctl add-port %1$s %2$s;
             ifdown -a;
             ifup -a;
             fi"
            bridge port)))

(defn bridge-cfg
  [{{:keys [name iface port] :as bridge} :bridge :as interfaces}]
  (if bridge
    (let [bridge (into core/iface-sorted-map
                       {:iface "inet manual"
                        :up ["ifconfig $IFACE 0.0.0.0 up"
                             "ip link set $IFACE promisc on"]
                        :down ["ip link set $IFACE promisc off"
                               "ifconfig $IFACE 0.0.0.0 down"]})]
      (if (not= (interfaces iface) bridge)
        (assoc (dissoc interfaces :bridge)
               iface bridge
               name (interfaces iface))
        (dissoc interfaces :bridge)))
    interfaces))

(defn merge-net-bridge-cfg [interfaces str-content]
  (core/network-map->str
    (bridge-cfg (core/merge-network-interfaces interfaces str-content))))

(defplan open-vswitch [{{{:keys [name iface port]} :bridge :as interfaces} :interfaces}]
  (service "openvswitch-switch" :action :start)
  (add-bridge "br-int")
  (add-bridge "br-ex")
  (core/remote-manage-network-interfaces
    (partial merge-net-bridge-cfg interfaces))
  (restart-network-interfaces
    (conj (filterv string? (map first interfaces)) name)
    :if-flag "restart-network")
  (when port (add-port name iface)))

(defplan configure [{{:keys [user password]} :quantum
                     :as settings
                     :keys [mysql-root-pass]}]
  (mysql/create-user user password "root" mysql-root-pass)
  (mysql/create-database "quantum" "root" mysql-root-pass)
  (mysql/grant "ALL" "quantum.*" (format "'%s'@'%%'" user) "root" mysql-root-pass)
  (template-file "etc/quantum/api-paste.ini" settings "restart-quantum")
  (template-file "etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini"
                 settings
                 "restart-quantum")
  (template-file "etc/quantum/metadata_agent.ini" settings "restart-quantum")
  (template-file "etc/quantum/quantum.conf" settings "restart-quantum")
  (template-file "etc/quantum/l3_agent.ini" settings "restart-quantum")
  (restart-services :flag "restart-quantum"
                    "quantum-dhcp-agent" "quantum-l3-agent"
                    "quantum-metadata-agent"
                    "quantum-plugin-openvswitch-agent" "quantum-server"
                    "dnsmasq"))

(defn server-spec [settings & flags]
  (api/server-spec
    :phases {:install
             (api/plan-fn
               (packages :aptitude ["openvswitch-switch"
                                    "openvswitch-datapath-dkms"])
               (packages :aptitude
                         ["quantum-server" "quantum-plugin-openvswitch"
                          "quantum-plugin-openvswitch-agent" "dnsmasq"
                          "quantum-dhcp-agent""quantum-l3-agent"]))
             :configure (api/plan-fn
                          (apply open-vswitch settings flags)
                          (configure settings))}
    :extends [(core/server-spec settings)]))

(comment
  
  (assert
    (= (let [s "# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp"]
         (merge-net-bridge-cfg
           {:bridge {:name "br-ex" :iface "eth0" :port true}}
           s))
   "auto lo
  iface lo inet loopback

auto eth0
  iface eth0 inet manual
  up ifconfig $IFACE 0.0.0.0 up
  up ip link set $IFACE promisc on
  down ip link set $IFACE promisc off
  down ifconfig $IFACE 0.0.0.0 down

auto br-ex
  iface br-ex inet dhcp"))
  
  )
