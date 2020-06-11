(ns angelic.util.experiments
  (:require [angelic.util :as util] [angelic.old  [search :as search]  [envs :as envs] [angelic :as angelic]])
  (:import [java.util HashMap]))


(defmulti setup-experiment-result (fn [experiment] (util/safe-get experiment :result-type)))

(defmulti make-experiment-result (fn [experiment setup-info timeout? memout? output printed init-ms ms mb] 
				    (util/safe-get experiment :result-type)))


(def *simple-experiment-result* ::SimpleExperimentResult)

(defstruct simple-experiment-result :class :experiment :commit-id :timeout? :memout? :output :printed :init-ms :ms :mb)

(defmethod setup-experiment-result ::SimpleExperimentResult [experiment] nil)

(defmethod make-experiment-result ::SimpleExperimentResult 
  [experiment setup-info timeout? memout? output printed init-ms ms mb]
  (struct simple-experiment-result ::SimpleExperimentResult 
	  experiment (util/git-commit-id) timeout? memout? output printed init-ms ms mb))


(def *planning-experiment-result* ::PlanningExperimentResult)

(defstruct planning-experiment-result 
  :class :experiment :commit-id :timeout? :memout? :output :printed :init-ms :ms :mb
  :next-count :ref-count :plan-count :op-count :pp-count)

(defmethod setup-experiment-result ::PlanningExperimentResult [experiment]
  (envs/reset-next-counter)
  (search/reset-ref-counter)
  (angelic/reset-progression-counters))

(defmethod make-experiment-result ::PlanningExperimentResult 
  [experiment setup-info timeout? memout? output printed init-ms ms mb]
  (struct planning-experiment-result ::PlanningExperimentResult 
	  experiment (util/git-commit-id) timeout? memout? output printed init-ms ms mb
	  (util/sref-get envs/*next-counter*)
	  (util/sref-get search/*ref-counter*)
	  (util/sref-get search/*plan-counter*)
	  (util/sref-get angelic/*op-counter*)
	  (util/sref-get angelic/*pp-counter*)
	  ))
  

(defstruct experiment 
  :class :name :parameters :namespace :init-form :form :warmup-time :max-seconds :max-mb :memory-instrument? :result-type)

(defn make-experiment 
  "init-form and form are clojure forms to be eval'd; the results of init-form will be bound to var 
   init for the execution of form."
  [name parameters namespace init-form form warmup-time max-seconds max-mb memory-instrument? result-type]
  (struct experiment ::Experiment name parameters namespace init-form form warmup-time max-seconds max-mb memory-instrument? result-type))

(defmulti run-experiment :class)

(defmethod run-experiment ::Experiment [experiment]
  (let [{:keys [namespace init-form form warmup-time max-seconds max-mb memory-instrument?]} 
	experiment]
    (when memory-instrument? (util/assert-is (identity max-mb)))
    (when max-mb (util/assert-is (identity max-seconds)))
    (when-not (find-ns namespace) (require namespace))
    (let [init-f (binding [*ns* (find-ns namespace)]
		   (eval `(fn [] ~init-form)))
	  f      (binding [*ns* (find-ns namespace)]
		   (eval `(fn [~'init] ~form)))]
      (when warmup-time (util/warm-up (with-out-str (f (init-f))) warmup-time))
      (let [setup-info (setup-experiment-result experiment)
	    [[init init-printed] init-ms] (util/get-time-pair (util/with-out-str2 (init-f)))
	    result 
	    (cond memory-instrument?
		    (util/time-and-memory-instrument (util/with-out-str2 (f init)) max-seconds max-mb)
		  max-mb
		    (util/time-and-memory-limit      (util/with-out-str2 (f init)) max-seconds max-mb)
		  max-seconds
		    (util/time-limit                 (util/with-out-str2 (f init)) max-seconds)
		  :else
                    (util/get-time-pair (util/with-out-str2 (f init))))]
	(let [timeout? (= result :timeout)
	      memout?  (= result :memout)
	      valid-result (when-not (or timeout? memout?) result)
	      [[output printed] ms mb] valid-result]
	  (make-experiment-result experiment setup-info timeout? memout? output 
				  (str init-printed "------------\nEnd init\n-------------" printed)
				  init-ms ms mb))))))

(defn write-experiment [experiment clj-file out-file]
  (spit clj-file
    (util/str-join "\n"
      `[(~'ns ~(gensym "exp") (:use   ~'angelic.util.experiments ~'angelic.util))
	(spit ~out-file (run-experiment '~experiment))
;	(System/exit 0) 
        ])))

  ; Take: some implicit representation of params (ordered!) and a fn that returns 
   ; [init-form form] given 
  ; Seqable map is fine.  
  ; [[param-name [param-vals]] [param-name [param-vals]]...]
  ; Want : cross-product, val-specific (nested), union
  ; Vals should be allowed to be colls too.  
  ; Params are symbols

 ; p-set -> [:union p-set*]   ; distinct sets
 ; p-set -> [:product p-set*] ; distinct vars
 ; p-set -> [var [val*] [nested-val*]]        
 ; nested-val   -> [val p-set]

(defn parameter-set-instantiations [p-set]
  (let [[head & tail] p-set]
    (cond (= head :union)
	    (let [results (apply concat (map parameter-set-instantiations tail))]
	      (util/assert-is (apply distinct? results))
	      results)
	  (= head :product)
	    (for [insts (apply util/cartesian-product (map parameter-set-instantiations tail))]
	      (do (util/assert-is (util/distinct-elts? (mapcat keys insts)))
		  (apply merge insts)))
	  :else 
	    (let [[vals nested-vals] tail]
	      (util/assert-is (util/distinct-elts? (concat vals (map first nested-vals))))
	      (concat 
		(for [val vals] {head val})
		(for [[val p-set] nested-vals
		      inst        (parameter-set-instantiations p-set)]
		  (do (util/assert-is (not (contains? inst head)))
		      (assoc inst head val))))))))

(comment 
  (parameter-set-instantiations '[:product [z [1] [[2 [y [#{} {}]]]]] [:union [a [b c d]] [b [a b c]]]])
  )

(defn parameter-set-tuples [p-set init-fn form-fn]
  (for [inst (parameter-set-instantiations p-set)]
    [inst (init-fn inst) (form-fn inst)]))

(defn make-experiment-set 
  "init-fn and form-fn take parameter sets and return executable forms."
  [name p-set init-fn form-fn namespace warmup-time max-seconds max-mb memory-instrument? result-type]
  (vec 
   (for [[params init-form form] (parameter-set-tuples p-set init-fn form-fn)]    
     (make-experiment name params namespace init-form form warmup-time max-seconds max-mb memory-instrument? result-type))))


(defn run-experiment-set [es]
  (print (count es))
  (doall
   (for [e es]
     (do (print ".")
	 (run-experiment e)))))



(def *default-run-dir* (util/base-local "runs/"))

(defn run-experiment-set! "Run and write to disk."
  ([es] (run-experiment-set! es *default-run-dir*))
  ([es run-dir] (run-experiment-set! es run-dir 0 (count es)))
  ([es min max] (run-experiment-set! es *default-run-dir* min max))
  ([es run-dir min max]
     (let [new-dir (str run-dir (:name (first es)))
           in-dir  (str new-dir "/in")
           out-dir (str new-dir "/out")]
       (util/mkdirs in-dir out-dir)
       (print (count es))
       (doseq [[i e] (subvec (vec (util/indexed es)) min max)]
         (let [out-file (str out-dir "/" i ".txt")]
           (print ".")
           (write-experiment e (str in-dir "/" i ".clj") out-file)
           (spit out-file (run-experiment e)))))))

(defn write-experiment-set 
  ([es] (write-experiment-set es *default-run-dir*))
  ([es run-dir] (write-experiment-set es run-dir 0 (count es)))
  ([es min max] (write-experiment-set es *default-run-dir* min max))
  ([es run-dir min max]
  (util/assert-is (> (count es) 0))
  (let [new-dir (str run-dir (:name (first es)))
	in-dir  (str new-dir "/in")
	out-dir (str new-dir "/out")]
;    (when (util/file-exists? new-dir) (throw (IllegalArgumentException. "Run-dir already exists")))
    (util/mkdirs in-dir out-dir)
    (doall
    (for [[i e] (subvec (vec (util/indexed es)) min max)]
      (let [clj-file (str in-dir "/" i ".clj")]
	(write-experiment e clj-file (str out-dir "/" i ".txt"))
	clj-file))))))

(defn write-experiment-set-results
  ([results] (write-experiment-set-results results *default-run-dir*))
  ([results run-dir]
  (write-experiment-set (map :experiment results))
  (let [new-dir (str run-dir (:name (:experiment (first results))))
	out-dir (str new-dir "/out")]
    (doseq [[i e] (util/indexed results)]
      (spit       (str out-dir "/" i ".txt") e))
    results)))

(defn read-experiment-set-results 
  ([es] (read-experiment-set-results es *default-run-dir*))
  ([es run-dir]
     (let [new-dir (str run-dir (:name (first es)))
	   out-dir (str new-dir "/out")]
;       (doall
	(for [i (range (count es))
	      :let [file-name (str out-dir "/" i ".txt")]
	      :when (if (.exists (java.io.File. file-name)) true 
			(println "Warning:" file-name "missing"))]
	  (do #_(println file-name) (util/read-file file-name)))))) ;)


(defn experiment-result->map [er]
  (let [experiment (:experiment er)
	parameters (:parameters experiment)]
    (util/merge-disjoint 
     parameters
     (util/merge-disjoint (dissoc (into {} experiment) :parameters :class)
			  (dissoc (into {} er)         :experiment :class)))))
  
(defn experiment-set-results->dataset [results]
  (map experiment-result->map results))



(comment 
  (run-experiment-set (make-experiment-set "test" '[:product [:x [1 2 3]] [:y [3 4 5]]] (fn [m] (:x m)) (fn [m] `(+ ~'init ~(:y m))) 'user nil 2 1 nil *simple-experiment-result*))  )


(defn smart-file [id size rep]
  (str id "-" size "-" rep))

(defn try-read-file [s] 
  (when (util/file-exists? s)
    (try (util/read-file s)
         (catch Exception e (println "Error reading" s e)))))

(defn smart-runner
  "Take a map from id to [make-experiment size-count rep-count] tuples,
   where make-experiment takes a size in (range size-count) and rep in ..., 
   an experiment scheduling function that takes a name and clojure file to run,
   a bool indicating if this is a continuation of an old run, and a run dir.
   Stops running when more than half fail."
  [job-map schedule! & [continue? run-dir]]
  (let [run-dir (or run-dir (str *default-run-dir* "thesis/"))
        in-dir  (str run-dir "in/")
	out-dir (str run-dir "out/")
        run-data (HashMap.)]
    (when-not continue?
      (util/mkdirs in-dir out-dir)
      (doseq [[id [maker size-count rep-count]] job-map
              size (range size-count)
              rep  (range rep-count)]
        (let [file (smart-file id size rep)]
          (write-experiment (maker size rep) (str in-dir file ".clj") (str out-dir file ".txt"))))
      (println "Done setting up experiment."))
    (while (not (every?
                 (fn [[id [_ size-count rep-count]]]
                   (= (first (get run-data id)) size-count))
                 job-map))
      (doseq [[id [_ size-count rep-count]] job-map]
        (let [[cur-size data] (get run-data id [0 nil])]
          (when (< cur-size size-count)
            (when (nil? data)
              (if (util/file-exists? (str out-dir (smart-file id cur-size 0) ".txt"))
                (println  id cur-size "CONTINUE (appears already started; waiting for results)")
                (do (println id cur-size "STARTING")
                    (dotimes [rep rep-count]
                      (let [f (smart-file id cur-size rep)]
                        (spit (str out-dir f ".txt") [])
                        (schedule! f (str in-dir f ".clj")))))))
           (let [results (for [rep (range rep-count)]
                           [rep (try-read-file (str out-dir (smart-file id cur-size rep) ".txt"))])
                 counts  (frequencies (for [[_ r] results] (when (seq r) (if (seq (:output r)) :success :fail))))]
             (doseq [[rep r] results]
               (when (and (not (seq (get data rep))) (seq r))
                 (println id cur-size rep "RUN COMPLETED" (if (seq (:output r)) "SUCCESS" "FAIL")
                          (if (:timeout? r) "timeout" "") (if (:memout? r) "memout" "")
                          " (overall:" counts ")"
                          (second (:output r)))))
             (cond (>= (get counts :success 0) (/ rep-count 2))
                   (do (println id (inc cur-size) (if (= (inc cur-size) size-count) "FINISHED" "NEXT ROUND") "******************")
                       (.put run-data id [(inc cur-size) nil]))

                   (> (get counts :fail 0) (/ rep-count 2))
                   (do (println id cur-size "FAILED ********************")
                       (.put run-data id [size-count nil]))

                   :else (.put run-data id [cur-size (into {} results)]))))))
      (print ".")
      (Thread/sleep 1000))))

(defn read-smart-results 
  [es run-dir]
  (into {}
        (for [[id [_ size-count rep-count]] es]
          [id
           (filter seq
                   (for [s (range size-count)]
                     (for [r (range rep-count)
                           :let [res (try-read-file (str run-dir "out/" (smart-file id s r) ".txt"))]
                           :when (seq res)]
                       (experiment-result->map res))))])))

(defn local-test-runner [exps]
  (let [d (str "/tmp/run" (rand-int 1000) "/")]
    (println d)
    (smart-runner exps #(load-file %2) false d)))

(defn test-smart-runner []
  (smart-runner
   {"test"
    [(fn [sz rep]
       (make-experiment "test" {} 'angelic.util.experiments
                        `(* ~sz 1000)
                        `(do (Thread/sleep (int ~'init)) ["YAY"])
                        nil 2 nil nil ::SimpleExperimentResult))
     5 3]
    "fee"
    [(fn [sz rep]
       (make-experiment "test" {} 'angelic.util.experiments
                        `(+ (* ~sz 200) (* ~rep 1000))
                        `(do (Thread/sleep (int ~'init)) ["YAY"])
                        nil 2 nil nil ::SimpleExperimentResult))
     5 3]}
   #(do (println "----------scheduling" %1) (load-file %2))
   false
   "/tmp/foo/"))

; Args is seq of [param-map init-form form] tuples
	   
