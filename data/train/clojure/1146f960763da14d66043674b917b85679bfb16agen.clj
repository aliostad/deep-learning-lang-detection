(ns nn.gen
  (:refer-clojure)
  (:refer msl)
  (:refer nn.comp))

;; edge constants
(def e :nn-dep)				;edge for dependencies
(def pe :nn-prev-dep)			;edge for previous state dependency

;; code gen constants
(def env 'env)
(def zs 'zs)


;; INFS -> CREATING GRAPH STRUCTURE
(defn inf->node [inf]
  (graph/assoc-edges (agent inf) [e pe]))
(defn infs->nodes [infs]
  (map inf->node infs)) 

(defn typ? [inf typ]
  (= (:nn-typ @inf) typ))
(defn typ->nodes [ns typ]
  (filter #(typ? % typ) ns))
(defn id->node [ns id]
  (find-first #(= (:nn-id @%) id) ns))
(defn ids->nodes [ns ids]
  (map #(id->node ns %) ids))

;; wiring the edges
(defn node->dep-connect-deps [n ns]
  (doseq [dn (ids->nodes ns (:nn-dep-ids @n))]
    (graph/n->n dn n e)))
(defn node->prev-connect-deps [n ns]
  (if (:nn-prev-id @n)
    (graph/n->n (id->node ns (:nn-prev-id @n)) n pe)))
(defn node->dep-prev-connect-deps [n ns]
  (node->dep-connect-deps n ns)
  (node->prev-connect-deps n ns))
(defn nodes->dep-prev-connected-nodes [ns]
  (doseq [n ns]
    (node->dep-prev-connect-deps n ns)))

;; assign fields 
(defn sleep-till-field-nil [n f]
  (while (nil? (get @n f))
	 (Thread/sleep 5)))

(defn nnid->nnsym [nnid]
  (symbol (str "nn-sym-" (str nnid))))
(defn node->assign-nnsym [n]
  (send n assoc :nn-sym (nnid->nnsym (:nn-id @n)))
  (sleep-till-field-nil n :nn-sym))
(defn nodes->assign-nnsym [ns]
  (doseq [n ns] (node->assign-nnsym n)))

;; overall
(defn infs->connected-nnsym-nodes [infs]
  (let [ns (infs->nodes infs)]
    (nodes->dep-prev-connected-nodes ns)
    (nodes->assign-nnsym ns)
    ns))


;; add code to a node
(defn code-not-assigned? [n]
  (not (:nn-code @n)))
(defn n->code [n]
  ((:nn-code-f @n) (map #(:nn-code @%) (graph/n-ins n e))))
(defn assign-code [n c]
  (send n assoc :nn-code c)
  (sleep-till-field-nil n :nn-code))

;; selecting the starting nodes (they will be the root nodes at the end)
(defn deps-are-codes? [n]
  (every? #(:nn-code @%) (graph/n-ins n e)))
(defn referred-more-than-one? [n]
  (> (count (graph/n-ous n e)) 1))
(defn referred-by-prev-state? [n]
  (seq (graph/n-ous n pe)))

;; export codes to the repos
;; problems could be the agent manner of the graph.. :O  ->  nil check before commit could be good..
(defn node->export-to-sym-codes [n ssse]
  (assoc ssse :sym-codes (conj (:sym-codes ssse) [(:nn-sym @n) (:nn-code @n)])))
(defn node->change-code-to-sym [n]
  (assign-code n (:nn-sym @n)))
(defn node->transplant-to-sym-codes [n ssse]
  (let [ssse (node->export-to-sym-codes n ssse)]
    (node->change-code-to-sym n)
    ssse))

(defn node->manage-transplant-to-sym-codes [n ssse]
  (if (or (referred-more-than-one? n) (referred-by-prev-state? n))
    (node->transplant-to-sym-codes n ssse)
    ssse))

(defn node->sign-to-start-state [n ssse]
  (assoc ssse :start-state (conj (:start-state ssse) (:nn-start-state @n))))
(defn node->sign-to-state-syms [n ssse]
  (assoc ssse :state-syms (conj (:state-syms ssse) (:nn-sym @n))))
(defn state-syms->index-of-node [ssse n]
  (index (reverse (:state-syms ssse)) (:nn-sym @n)))

(defn exp-env-node->export-to-key-codes [n ssse]
  (assoc ssse :exp-key-codes (conj (:exp-key-codes ssse) [(:nn-export-key @n) (:nn-code @n)])))

;; code collapses
;; f: n x ssse -> ssse 
(defn state->code-collapse [n ssse]
  (assign-code n (n->code n))
  (node->manage-transplant-to-sym-codes n ssse))
(defn const->code-collapse [n ssse]
  (assign-code n (:nn-param @n))
  (node->manage-transplant-to-sym-codes n ssse))
(defn prev-state->code-collapse [n ssse]
  (let [pn (first (graph/n-ins n pe))]
    (let [ssse (node->sign-to-state-syms pn ssse)
	  _ (assign-code n `(nth ~zs ~(state-syms->index-of-node ssse pn)))
	  ssse (node->sign-to-start-state n ssse)
	  ssse (node->manage-transplant-to-sym-codes n ssse)]
      ssse)))
(defn env-import->code-collapse [n ssse]
  (assign-code n `(get ~env ~(:nn-import-key @n)))
  (node->manage-transplant-to-sym-codes n ssse))
(defn env-export->code-collapse [n ssse]
  (let [in (first (graph/n-ins n e))
	_ (assign-code n (:nn-code @in)) 
	ssse (node->manage-transplant-to-sym-codes n ssse)
	ssse (exp-env-node->export-to-key-codes n ssse)]
    ssse))

;; have a structure 
;; ssse:		     
;; sym-codes state-syms start-state exp-key-codes
(defn ssse-init []
  {:sym-codes (list)			;[[sym - code-expression] ..]
   :state-syms (list)			;[sym | that prev-state-mentioned ..]
   :start-state (list)			;[zs0-values ..] 
   :exp-key-codes (list)})		;[key - export-code-expression] ..]
;; (defn node->code-collapse [n sym-codes state-syms start-state exp-key-codes] 
;;   (cond (typ? n :const) (const->code-collapse n sym-codes)
;; 	(typ? n :prev-state) (prev-state->code-collapse n sym-codes state-syms start-state)
;; 	(typ? n :state) (state->code-collapse n sym-codes)
;; 	(typ? n :env-import) (env-import->code-collapse n sym-codes)
;; 	(typ? n :env-export) (env-export->code-collapse n sym-codes exp-key-codes)))
(defn node->code-collapse [n ssse]
  (cond (typ? n :const) (const->code-collapse n ssse)
	(typ? n :prev-state) (prev-state->code-collapse n ssse)
	(typ? n :state) (state->code-collapse n ssse)
	(typ? n :env-import) (env-import->code-collapse n ssse)
	(typ? n :env-export) (env-export->code-collapse n ssse)))


(defn nodes->code-collapse-ssse [ns]
  ;; (let [sym-codes (agent (list))	;sym and the corresp code expression
  ;; 	state-syms (agent (list))	;syms of the nodes which previous states referred
  ;; 	start-state (agent (list))
  ;; 	exp-key-codes (agent (list))]	;export key code expressions

    ;; collapse all node 
  (loop [[n & ns] ns
	 ssse (ssse-init)]
    ;; (println "jo" (count ns) (map #(vector (:nn-typ @%)) ns))
    (if n
      (if (deps-are-codes? n) 
	(recur ns (node->code-collapse n ssse))
	(recur (concat ns [n]) ssse))
      ssse)))
(defn nodes->code-collapse [ns]
  (let [ssse (nodes->code-collapse-ssse ns)]
    [(reverse (:sym-codes ssse))
     (reverse (:state-syms ssse))
     (reverse (:start-state ssse))
     (reverse (:exp-key-codes ssse))]))


(defn upd-f-code [sym-codes state-syms exp-key-codes]
  `(fn [~env ~zs] 
     (let [~@(reduce concat sym-codes)]
       [(assoc ~env ~@(reduce concat exp-key-codes))
	(vector ~@state-syms)])))

;; woot.. I made it =D 
(defn infs->zs0-upd-f [infs]

  ;; (println "IFIFI")
  ;;   (doseq [i infs]
  ;;     (println i)) 

  (let [ns (infs->connected-nnsym-nodes infs)
	[sym-codes state-syms start-state-values exp-key-codes] (nodes->code-collapse ns)]

    ;; (println "NO PROBLEMO :D")
    ;; (doseq [i infs]
    ;;   (println i))
    ;; (println (count ns))
    ;; (doseq [i (concat sym-codes exp-key-codes state-syms start-state-values)]
    ;;   (println i))

    ;; (println (upd-f-code sym-codes state-syms exp-key-codes))

    [start-state-values (eval (upd-f-code sym-codes state-syms exp-key-codes))]))
