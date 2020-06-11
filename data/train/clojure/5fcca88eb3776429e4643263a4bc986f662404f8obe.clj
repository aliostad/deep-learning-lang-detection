;;namespace for obsolete toys...
(ns marathon.ces.obe)

;;from marathon.ces.engine

 ;;When we simulate, starting from a GUI, we usually want to tell the user if there are any anomolies in
 ;;the data.  Specifically, if there is no supply or no demand, we inform the user, requiring verification
 ;;before simulating.
(defn get-user-verification [state & [suppress]]
  (do (println "get-user-verification is currently a stub!  We need to add interface hooks here.  Messages will still print.")
      (if (zero? (-> state :supplystore :unitmap   count)) (println "No Supply Loaded.  Continue With Simulation?"))
      (if (zero? (-> state :demandstore :demandmap count)) (println "No Demand Loaded.  Continue With Simulation?"))
      true))


;; Uses the event stream provided by simcontext, to broadcast the availability of each element of the simstate.
;; Allows interested observers, who require access across different domains, to bind to the components, making
;; local processing easier to reason about.

(defn notify-watches [simctx & [ctx simname & _]]
  (let [ctx     (or ctx simctx)
        state   (:state simctx)
        simname (or simname (:name state))]
    (->> ctx 
        (sim/trigger-event :WatchDemand simname simname "" (:demandstore state))
        (sim/trigger-event :WatchSupply simname simname "" (:supplystore state))
        (sim/trigger-event :WatchTime simname simname ""   (:scheduler ctx))
        (sim/trigger-event :WatchPolicy simname simname "" (:policystore state))
        (sim/trigger-event :WatchParameters simname simname "" (:parameters state))
        (sim/trigger-event :WatchFill simname simname "" (:fillstore state)))))


;;Notify interested parties of the existence of the GUI.
(defn notifyUI [ui ctx]
  (sim/trigger-event :WatchGUI "" "" "GUI Attached" ui ctx))



;This is just a handler that gets added, it was "placed" in the engine object
;in the legacy VBA version.  __TODO__ Relocate or eliminate engine-handler.
(defn engine-handler
  "Forces all entities in supply to be brought up to date."
  [ctx edata]
  (if (= (:type edata) :update-all-units)
    (supply/update-all ctx) ;from marathon.sim.supply
    (throw (Exception. (str "Unknown event type " edata)))))


(defn initialize-control
  "Registers a default handler for updating all units in the supplystore
   after an :update-all-units event."
  [ctx]
  (sim/add-listener :Engine 
      (fn [ctx edata name] (engine-handler ctx edata)) [:update-all-units] ctx))

;;original version, new version is cut down.
(defn initialize-sim
  "Given an initial - presumably empty state - and an optional upper bound on 
   on the simulation time - lastday - returns a simulation context that is 
   prepared for processing, with default time horizons and any standard 
   preconditions applied."
  [ctx & [lastday]]
    (->> ctx
        (start-state)
;        (assoc-in  [:state :time-start] (now))
;        (assoc-in  [:state :parameters :work-state] :simulating)
        (set-time lastday)
        ;(notify-watches) 
        (initialize-control)
        (supply/manage-supply 0)
        (policy/manage-policies 0)))
;;Legacy....
;;New version focuses on streams and data, rather than imperative
;;logging.
(defn initialize-output 
  "Sets the output path for output streams in the outputstore.
   Currently a stub...We can let an event handler deal with 
   setting up the outputstore.  There are probably other 
   entities interested in knowing about output setup 
   prior to a run."
  [ctx]
  (do (println "initialize-output is currently a stub.")
      (sim/trigger-event :initialize-output :Engine :Engine "Initialized output" nil ctx)))


(defn check-truncation
  "Legacy function that checks to see if the simulation can be truncated, i.e. 
   cut short.  Typically, we take the minimum time of 
   [latest-demand-end-time  simulation-end-time], but there are other phenomena
   that may cause us to advance the end time of the simulation."
  [ctx] 
  (if (and (-> ctx :state :truncate-time ) (-> ctx :state :found-truncation))
    (-> (sim/trigger-event :all :Engine :Engine 
           (str "Truncated the simulation on day " (sim/get-time ctx) ", tfinal is now : " 
                (sim/get-final-time ctx)) nil ctx) 
        (assoc-in [:state :found-truncation] true))
    ctx))
