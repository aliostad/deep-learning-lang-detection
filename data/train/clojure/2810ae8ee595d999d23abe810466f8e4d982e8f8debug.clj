;;temporary debugging session
(ns marathon.ces.debug
  (:require  [marathon.ces [engine :as engine]
                           [core :as core]]
             [marathon [analysis :as a]]
             [spork.sim.simcontext :as sim]
             [spork.entitysystem [store :as store]]
             [spork.util [io :as io]]))

(defn hpath [p] (str io/home-path p))
(def sdata (hpath "\\testdata-v2.xlsx"))


(in-ns 'marathon.ces.engine)
(defn partial-step
  "Primary state transition function for Marathon.  Threads the next day and
   an initial state through a series of transfer functions that address 
   high-level state transfers for supply, policy, demand, filling, and more. 
   Computes the resulting state - either the final state, or the initial state
   for the next step."
  ([day ctx]
   (->> ctx 
        (begin-day        day)  ;Trigger beginning-of-day logic and notifications.
        (manage-supply    day)  ;Update unit positions and policies.
        (manage-policies  day)  ;Apply policy changes, possibly affecting supply.
        (manage-demands   day)  ;Activate/DeActiveate demands, handle affected units.      
       ; (fill-demands     day)  ;Try to fill unfilled demands in priority order. 
       ; (manage-followons day)  ;Resets unused units from follow-on status. 
       ; (end-day day)           ;End of day logic and notifications.
        ))
  ([ctx] (partial-step (sim/get-time ctx) ctx)))
(in-ns 'marathon.ces.debug)



(def ctx (a/load-context sdata))

(comment 
(def uic "21_43429R000_NG")

;;brings us up to t 746, beginning
(def ctxpre (->> (a/marathon-stream ctx)
                 (a/frame-at 743)
                 (sim/advance-time)))
(def ctxfill (engine/partial-step ctxpre))
;;fill-demands results in outdated statedata.
(def ctxdep (marathon.ces.fill.demand/fill-demands
             (core/get-time ctxfill) ctxfill)) 

;;deploy-unit works...
(def ctxd (marathon.ces.deployment/deploy-unit
           ctxfill
           (store/get-entity ctxfill uic)
           446
           (store/get-entity ctxfill "1_Tangerine_43429R000_[746...754]")      
           (core/followon? (store/get-entity ctxfill uic))))

;;we're having similar problems at 1821->1825 now.
(def ctxpre (->> (a/marathon-stream ctx)
                 (a/day-before-error)
                 (second)
                 (sim/advance-time)))

;;time at 1825, begin-day now.
;;we are not filling followon demands, specifically
;;for dg moke, even though we have supply.
;;we're stopping when trying to fill violet, then
;;just leaving everything else on the table.
;;we should be able to fill moke 
(def ctxfill (engine/partial-step ctxpre))

(def uic23 "23_43429R000_NG")
;;unit 23 is apparently stuck at coco up until
;;703, even by 1825...
(def uic31 "31_43429R000_NG")
;;Looks like his problems arise at t=1825, after his deployment ends.
;;Policy change happens around 1801, he's probably deferred.

;;Problem appears to be re-entry.
(def p (marathon.ces.policy/get-policy "TAA19-23_RC12" (core/get-policystore ctxpre) ))
;;we "can-recover?" because our cycletime is less than duration expected...
;;Also, the policy template for RC15,  upon which policy p is bas

)
;;We're getting invalid deployer errors here:
(def uic "1_30715R200_AC" )
