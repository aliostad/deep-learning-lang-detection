(ns supertone.studio.inst
  (:require [overtone.sc.server                 :only [ensure-connected!]
                                                :refer :all]
            [overtone.sc.machinery.synthdef     :only [load-synthdef]
                                                :refer :all]
            [overtone.sc.machinery.server.comms :only [with-server-sync]
                                                :refer :all]
            [overtone.sc.bus                    :refer :all]
            [overtone.sc.node                   :refer :all]
            [overtone.sc.ugens                  :refer :all]
            [overtone.studio.core               :refer :all]
            [overtone.studio.inst               :refer :all]
            [supertone.util                     :as util]
            [supertone.studio.bus               :as bus]
            [supertone.studio.audio             :as audio]
            [supertone.studio.control           :as control]
            [supertone.studio.fx                :as fx]))

(def nil-id -1000)

(definst mono-pass
  [in-bus nil-id]
  (in in-bus))

(definst stereo-pass
  [in-bus nil-id]
  (in in-bus 2))

(definst sawboy
  [freq {:default 200 :min 2 :max 20000 :step 1}]
  [(saw freq) (saw freq)])

(defn library
  "List the instruments available to add."
  []
  (:instruments @studio*))

(defn old-name
  "Get instrument's old name."
  [name]
  (-> (audio/inst-get name)
    (:sdef)
    (:name)
    (clojure.string/split #" ")
    (first)
    (clojure.string/split #"/")
    (last)))

(defn control-nodes
  "Get a vector of synths controlling an instrument parameter."
  [name pname]
  (or (get-in @audio/inst-control* [name pname]) []))

(defn nodes
  "Get a vector of active nodes associated with an instrument."
  [name]
  (or (get @audio/inst-nodes* name) []))

(defn param-list
  "List instrument parameter names."
  [name]
  (remove
    #{"in-bus"}
    (:args (audio/inst-get name))))

(defn param
  "Get instrument parameter."
  [name pname]
  (let [a         (:value (audio/param-map-synth (audio/inst-get name) pname))
        ctl-nodes (control-nodes name pname)]
    (if (empty? ctl-nodes)
      (if (nil? a) nil (float @a))
      (control-bus-get
        (int (node-get-control (first ctl-nodes) :in-bus1))))))

(defn param!
  "Set instrument parameter."
  [name pname value]
  (let [inst      (audio/inst-get name)
        ctl-nodes (control-nodes name pname)]
    (swap!
      (:value (audio/param-map-synth (audio/inst-get name) pname))
      (constantly value))
    (if (empty? ctl-nodes)
      (ctl inst pname value)
      (control-bus-set!
        (int (node-get-control (first ctl-nodes) :in-bus1))
        value))))

(defn param-reset!
  "Reset instrument parameter to default value."
  [name pname]
  (param!
    name
    pname
    (:default (audio/param-map-synth (audio/inst-get name) pname))))

(defn param-delta!
  "Change instrument parameter based on step size."
  [name pname delta]
  (let [all     (audio/param-map-synth (audio/inst-get name) pname)
        min-val (:min all)
        max-val (:max all)
        step    (:step all)]
    (util/delta
      [name pname]
      param
      param!
      min-val
      max-val
      step
      delta)))

(defn in-bus
  "Get instrument input bus."
  [name]
  (param name "in-bus"))

(defn in-busses
  "Get instrument input bus vector."
  [name]
  (bus/float-range (in-bus name) (:n-chans (audio/inst-get name))))

(defn out-bus
  "Get instrument output bus."
  [name]
  (node-get-control (:mixer (audio/inst-get name)) :out-bus))

(defn out-busses
  "Get instrument output bus vector."
  [name]
  (bus/float-range (out-bus name) (:n-chans (audio/inst-get name))))

(defn in-bus!
  "Set instrument input bus."
  [name bus]
  (let [bus2     (if bus bus nil-id)
        io-other (audio/inst-io-remove
                   (audio/inst-io name)
                   :in
                   (in-busses name))]
    (when (in-bus name)
      (param! name "in-bus" (float bus2))
      (when
        (audio/inst-io-swap!
          name
          (audio/inst-io-into io-other :in (in-busses name)))
        (audio/sort-node-tree!)))))

(defn out-bus!
  "Set instrument output bus."
  [name bus]
  (let [bus2     (if bus bus nil-id)
        io-other (audio/inst-io-remove
                   (audio/inst-io name)
                   :out
                   (out-busses name))]
    (ctl (:mixer (audio/inst-get name)) :out-bus bus2)
    (when
      (audio/inst-io-swap!
        name
        (audio/inst-io-into io-other :out (out-busses name)))
      (audio/sort-node-tree!))))

(defn control-add!
  "Add a control bus to an instrument parameter."
  [name pname bus]
  (control/mix-add!
    audio/inst-control*
    [name pname]
    bus
    (control-nodes name pname)
    (nodes name)
    param))

(defn control-remove!
  "Remove a control node from an instrument parameter."
  [name pname ctl-node]
  (control/mix-remove!
    audio/inst-control*
    [name pname]
    ctl-node
    (control-nodes name pname)
    (nodes name)
    param
    param!))

(defn control-clear!
  "Clear all control nodes from an instrument parameter."
  [name pname]
  (dorun (map
    #(control-remove! name pname %)
    (control-nodes name pname))))

(defn control-amt-get
  "Get control magnitude."
  [ctl-node]
  (audio/control-amt-get ctl-node))

(defn control-amt-set
  "Set control magnitude."
  [ctl-node amt]
  (audio/control-amt-set ctl-node amt))

(defn control-amt-reset
  "Set control magnitude to zero."
  [ctl-node]
  (audio/control-amt-reset ctl-node))

(defn control-amt-delta
  "Change instrument control magnitude based on step size."
  [name pname ctl-node delta]
  (let [all     (audio/param-map-ctl (audio/inst-get name) pname)
        min-val (:min all)
        max-val (:max all)
        big-val (- max-val min-val)
        step    (:step all)]
    (util/delta
      [ctl-node]
      control-amt-get
      control-amt-set
      (* big-val -1)
      big-val
      step
      delta)))

(defn- sdef-set-bus
  [sdef bus]
  (update
    (update sdef :constants #(conj (take (- (count %) 1) %) bus))
    :ugens
    (fn [u]
      (concat
        (take (- (count u) 1) u)
        [(update
          (update
            (update
              (last u)
              :arg-map
              #(assoc % :bus (int bus)))
            :orig-args
            #(conj (rest %) (int bus)))
          :args
          #(conj (rest %) bus))]))))

(defn add!
  "Add a new instrument by duplicating an instrument from library.
   Usage: (add! \"mono-pass\" \"example\")"
  [old-name new-name]
  (when (audio/inst-get new-name)
    (throw (Exception. (str "Instument already exists: " new-name))))
  (ensure-connected!)
  (let [old-name# old-name
       new-name# new-name
       old-inst# (get (library) old-name#)
       n-chans#  (:n-chans old-inst#)
       inst-bus# (bus/audio n-chans#)
       container-group# (with-server-sync
                          #(group (str "Inst " new-name# " Container")
                                  :tail (:instrument-group @studio*))
                          "whilst creating an inst container group")

       instance-group#  (with-server-sync
                          #(group (str "Inst " new-name#)
                                  :head container-group#)
                          "whilst creating an inst instance group")

       fx-group#  (with-server-sync
                    #(group (str "Inst " new-name# " FX")
                            :tail container-group#)
                    "whilst creating an inst fx group")

       imixer#    (inst-mixer n-chans#
                              [:tail container-group#]
                              :in-bus inst-bus#)

       sdef#      (update
                    (sdef-set-bus (:sdef old-inst#) (bus/bus-id inst-bus#))
                    :name
                    #(str % " " new-name#))
       arg-names# (:args old-inst#)
       params#    (map #(assoc % :value (atom (:default %)))
                       (:params old-inst#))
       fx-chain#  []
       volume#    (atom DEFAULT-VOLUME)
       pan#       (atom DEFAULT-PAN)
       inst#      (with-meta
                    (overtone.studio.inst.Inst. new-name# params# arg-names#
                           sdef# container-group# instance-group# fx-group#
                           imixer# inst-bus# fx-chain#
                           volume# pan# n-chans#)
                    {:overtone.helpers.lib/to-string #(str (name (:type %))
                                                           ":"
                                                           (:name %))})]
   (load-synthdef sdef#)
   (swap! audio/inst-store* assoc new-name# inst#)
   (swap! audio/inst-control* assoc new-name# {})
   (swap! audio/inst-nodes* assoc new-name# [])
   (swap! audio/fx-store* assoc new-name# [])
   (swap! audio/fx-control* assoc new-name# {})
   (let [in-vec  (in-busses new-name#)
         out-vec (out-busses new-name#)]
     (swap! audio/inst-io* assoc new-name# {:in in-vec :out out-vec}))
   (audio/sort-node-tree!)
   inst#))

 (defn rename!
   "Rename an instrument."
   [name new-name]
   (when (audio/inst-get new-name)
     (throw (Exception. (str "Instument already exists: " new-name))))
   (let [inst       (audio/inst-get name)
         inst-ctl   (get @audio/inst-control* name)
         inst-nodes (get @audio/inst-nodes* name)
         fx         (get @audio/fx-store* name)
         fx-ctl     (get @audio/fx-control* name)
         io         (get (audio/inst-io) name)
         index      (.indexOf (audio/node-order) name)]
     (swap! audio/inst-store* dissoc name)
     (swap! audio/inst-control* dissoc name)
     (swap! audio/inst-nodes* dissoc name)
     (swap! audio/fx-store* dissoc name)
     (swap! audio/fx-control* dissoc name)
     (swap! audio/inst-io* dissoc name)
     (swap! audio/inst-store* assoc new-name inst)
     (swap! audio/inst-control* assoc new-name inst-ctl)
     (swap! audio/inst-nodes* assoc new-name inst-nodes)
     (swap! audio/fx-store* assoc new-name fx)
     (swap! audio/fx-control* assoc new-name fx-ctl)
     (swap! audio/inst-io* assoc new-name io)
     (swap! audio/node-order* #(assoc % index new-name))
     inst))

(defn remove!
  "Remove an instrument."
  [name]
  (let [inst (audio/inst-get name)]
    (dorun (map
      (partial fx/remove! name)
      (audio/fx-list name)))
    (dorun (map
      (partial control-clear! name)
      (param-list name)))
    (swap! audio/inst-store* dissoc name)
    (swap! audio/inst-control* dissoc name)
    (swap! audio/inst-nodes* dissoc name)
    (swap! audio/fx-store* dissoc name)
    (swap! audio/fx-control* dissoc name)
    (swap! audio/inst-io* dissoc name)
    (bus/free (:bus inst))
    (node-free* (:group inst))
    nil))

(defn node-add!
  "Add a synth node for an instrument."
  [name]
  (let [inst-node ((audio/inst-get name))]
    (dorun (map
      #(when-let [ctl-nodes (seq (control-nodes name %))]
         (node-map-controls*
           inst-node
           [% (int (node-get-control (last ctl-nodes) :out-bus))]))
      (param-list name)))
    (swap! audio/inst-nodes* update name
      #(into % [inst-node]))
    inst-node))

(defn node-remove!
  "Remove a synth node for an instrument."
  [name inst-node]
  (node-free* inst-node)
  (swap! audio/inst-nodes* update name
    #(into [] (remove #{inst-node} %)))
  nil)

(defn node-clear!
  "Clear all synth nodes for an instrument."
  [name]
  (dorun (map (partial node-remove! name) (nodes name))))

(defn add-to-bus!
  "Add an instrument and connect it to input and output busses.
   Bus arguments can be nil."
  [old-name new-name in-bus out-bus]
  (let [inst (add! old-name new-name)]
    (in-bus! new-name in-bus)
    (out-bus! new-name out-bus)
    inst))

(defn- stereo?
  "Check if an instrument or a bus is stereo."
  [n]
  (cond
    (string? n) (> (:n-chans (audio/inst-get n)) 1)
    (float? n) (bus/alloc-audio-id? n 2)
    :else (throw (Exception. (str "Unknown type: " n)))))

(defn pass-in!
  "Route the input of an instrument or a bus through a freshly created pass."
  ([n new-name] (pass-in! n new-name (if (stereo? n) :stereo :mono)))
  ([n new-name channels]
   (let [stereo (= channels :stereo)
         old-name (if stereo "stereo-pass" "mono-pass")
         inst (add! old-name new-name)
         bus (bus/bus-id (bus/audio (if stereo 2 1)))]
     (cond
       (string? n) (let [in (in-bus n)]
                     (out-bus! new-name bus)
                     (in-bus! new-name in)
                     (in-bus! n bus))
       (float? n) (let [in (filter
                             #(= (out-bus %) (float n))
                             (audio/inst-list))]
                    (in-bus! new-name bus)
                    (dorun (map #(out-bus! % bus) in))
                    (out-bus! new-name n))
       :else (throw (Exception. (str "Unknown type: " n)))))))

(defn pass-out!
  "Route the output of an instrument or a bus through a freshly created pass."
  ([n new-name] (pass-out! n new-name (if (stereo? n) :stereo :mono)))
  ([n new-name channels]
   (let [stereo (= channels :stereo)
         old-name (if stereo "stereo-pass" "mono-pass")
         inst (add! old-name new-name)
         bus (bus/bus-id (bus/audio (if stereo 2 1)))]
     (cond
       (string? n) (let [out (out-bus n)]
                     (in-bus! new-name bus)
                     (out-bus! new-name out)
                     (out-bus! n bus))
       (float? n) (let [out (filter
                              #(= (in-bus %) (float n))
                              (audio/inst-list))]
                    (out-bus! new-name bus)
                    (dorun (map #(in-bus! % bus) out))
                    (in-bus! new-name n))
       :else (throw (Exception. (str "Unknown type: " n)))))))

;; Temporary helper functions

(defn wipe
  "Clear all audio processing."
  []
  (dorun (map remove! (audio/inst-list)))
  (dorun (map
    bus/free-audio-id
    (drop (:n-channels bus/hardware) @bus/bus-audio*))))
