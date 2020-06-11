;;this is a demonstration of how to do a marathon
;;run, to replicate the results submitted.
(ns marathon.run
  (:require [marathon         [analysis :as a]]
            [marathon.ces     [core :as core]]
            [marathon.visuals [patches :as patches]]
            [marathon.project :as project]
            [spork.util       [io :as io]]))

(defn hpath [p] (str io/home-path p))

(def ep (hpath "\\srm\\notionalbase.xlsx"))

(defn build-patches
  "Given a path to a processed run directory, renders the 
   processed history into a stylized HTML file.  The styling 
   is compatible with web browsers, and can be imported to 
   Excel.  The visualization looks like a unit 'patch chart'."
  [rootpath]
  (do (println [:building-patches (str rootpath "patches.htm")])
      (try (patches/locations->patches rootpath)
           (catch Exception e
             (println [:skipping-patches :no-location-samples])))))

(defn do-run
  "Given two paths to folders - a path to a marathon project 
   [from-path], and a path to post results to [target-path] - 
   computes the marathon history for the run, producing results 
   into the target path.  Default outputs will be derived from 
   the simulation history, including a compressed history."
  [from-path target-path]
  (do (a/spit-history! (a/marathon-stream from-path) target-path)
      (build-patches target-path)))

;;so, naively, auditing a project is provided by project/audit-project.
;;that just spits out the so-called static tables.  We could change the
;;order of computation and compute our fillgraph up front, rather than
;;from context only...
;;Another idea is to define a one-time atom.
;;After the first deref, we free.  So, we keep the project loaded
;;until we've loaded the context.
(defn do-audited-run
  "Given two paths to folders - a path to a marathon project 
   [from-path], and a path to post results to [target-path] - 
   computes the marathon history for the run, producing results 
   into the target path.  Default outputs will be derived from 
   the simulation history, including a compressed history."
  [from-path target-path]
  (core/debugging 
   (do (a/spit-history!
        (a/marathon-stream from-path :audit? true :audit-path target-path :events? true)
        target-path)
       (build-patches target-path))))

(def root "C:\\Users\\1143108763.C\\Documents\\srm\\cleaninput\\runs\\")
(def root "C:\\Users\\tspoon\\Documents\\srm\\tst\\notionalv2\\")

(def srm "srmbase.xlsx")
(def arf "arfbase.xlsx")
(defn strip [x] (first (clojure.string/split x #"\.")))

;;this is probably our primary api.
(defn run-cases
  "Given a sequence of paths to case files, processes each case in turn per
   do-run.  Assumes that the output directory is intended to be a subdirectory 
   identical to the name of the file being processed.  Thus, blah.xlsx would 
   have its output in ./blah/... "
  ([folder xs]
   (doseq [x xs]
     (println [:running x])
     (let [nm  (strip    x)
           in  (str folder x)
           out (str folder nm "\\")
           _   (io/hock (str out "timestamp.txt") (System/currentTimeMillis))]
       (do-audited-run in out))))
  ([xs] (run-cases root xs)))

(defn examine-project
  "Given a path to a valid MARATHON project, will load the project into a 
   simulation context, and present a tree-based view of the initial state.
   Useful for exploring the simulation state data structure, and debugging."
  [path]
  (core/visualize-entities 
   (a/load-context path)))





(comment ;testing
  ;;Worked without legacy records...
  (def maxbase (hpath "\\Documents\\srm\\tst\\notionalv2\\maxbase.xlsx"))
 ; (project/audit-project maxbase "C:\\Users\\tspoon\\Documents\\srm\\tst\\notionalv2\\maxbase\\")
;  (run-cases "C:\\Users\\tspoon\\Documents\\srm\\tst\\notionalv2\\" ["maxbase.xlsx"])
  (do-audited-run maxbase (hpath "\\Documents\\srm\\tst\\notionalv2\\maxbase\\"))
  
  (do-run ep (hpath "\\srm\\newtest\\"))
  (def h
    (a/load-context (hpath "\\Documents\\srm\\cleaninput\\runs\\srmbase.xlsx")))
  (def sdata (hpath "\\testdata-v2.xlsx"))

  (require '[marathon.ces [engine :as engine]])
  (require '[spork.sim.simcontext :as sim])
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
  (in-ns 'marathon.run)
  
;;This is just a helper to translate from craig's encoding for
;;srm policy positions.
(def translation
  {"MA, DA" "MA_DA_C1"
   "MD, DA" "MD_DA_C1"
   "MA, NDA" "MA_NDA_C1"
   "Ready"   "R_C2"
   "PB"      "PB_C3"
   "MP, NDA"  "MP_NDA_C3"
   "PT"       "PT_C4"
   "MP, DA"   "MP_DA_C1"})
  )


