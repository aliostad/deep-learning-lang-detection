(ns cosheet.expression-manager
  (:require (cosheet [task-queue :refer [new-priority-task-queue add-task
                                         run-all-pending-tasks
                                         run-some-pending-tasks]]
                     [utils :refer [dissoc-in update-in-clean-up
                                    swap-returning-both!
                                    swap-control-return!
                                    with-latest-value]]
                     [reporter :as reporter]
                     [mutable-map :as mm])))

;;; Trivial scheduler that just runs everything and returns the
;;; current value.

(defn current-value
  "Run computation on the reporter, returning the current value,
   rather than tracking dependencies."
  [expr]
  (if (reporter/reporter? expr)
    (let [data (reporter/data expr)
          expression (:expression data)]
      (if expression
        ((or (:trace data) identity)
         #(current-value (apply (fn [f & args] (apply f args))
                                (map current-value expression))))
        (do (when (and (:manager data) (not (reporter/attended? expr)))
              (reporter/set-attendee! expr :request (fn [key reporter] nil)))
            (reporter/value expr))))
    expr))

;;; Manage the (re)computation of reporters using a priority queue.

;;; The following fields are used in reporters, in addition to the
;;; standard reporter fields.
;;; Provided by the original creator of the reporter:
;;;         :expression The expression describing the computation that
;;;                     gives the value of this reporter 
;;;       :manager-type A keyword describing what kind of manager the
;;;                     reporter should have.
;;; Added by this manager:
;;;        :value-source A reporter whose value should be the value of this
;;;                      reporter if we have no needed-values.
;;;    :old-value-source The previous :value-source, if we know it and
;;;                      we haven't yet gotten a value from the
;;;                      current value source. This serves two
;;;                      purposes. If we don't yet have a current
;;;                      value source, and some of our arguments have
;;;                      just gone invalid, but not changed values,
;;;                      then this will become the value source again,
;;;                      if our arguments retake their last valid
;;;                      values. Second, we will generate demand for
;;;                      this reporter, causing its sub-computations
;;;                      to be kept active, so that if they
;;;                      were cached, they will be available for
;;;                      reuse by the subcomputations of the current
;;;                      value source.
;;; :arguments-unchanged Present, and equal to true, if we have not
;;;                      seen a valid value different from the ones
;;;                      used to compute old-value-source.
;;;       :needed-values A set of reporters whose values this reporter needs
;;;                      to evaluate its expression and that it doesn't have a
;;;                      valid value for. Not present if nothing is
;;;                      attending to the reporter.
;;;  :subordinate-values A map from reporters whose values this reporter needs
;;;                      to evaluate its expression to the last
;;;                      valid value it saw for them, even if they have gone
;;;                      invalid subsequently. Not present if nothing
;;;                      is attending to the reporter.
;;;     :further-actions A list of [function arg arg ...] calls that
;;;                      need to be performed. (These will never actually
;;;                      be stored in a reporter, but are added to the
;;;                      map before it is stored.)

;;; The computation is multi-threaded, but can avoid using locks and
;;; TSM because it just needs eventual consistency; it is just copying
;;; information. The danger is that in between a read and a copy in
;;; one thread, the data that was read will be changed, and another
;;; thread will complete a read and copy of the new information, only to
;;; have the first thread overwrite it with the stale information.
;;;
;;; Doing the read inside an atomic update operation for copying
;;; doesn't work. Consider the copied data starting out at A, and
;;; source value changing from A to B, and then back to A. An atomic
;;; swap! in the copy reads the copy's current value as A, then the function
;;; provided to the swap! reads the intermediate source value B and
;;; returns it. But before the swap! finishes, another thread sets the
;;; copy's value back to the final A. Now, when the original swap!
;;; goes to finish, it will see that the copy's value is still A, like
;;; it initially read, so the swap! succeeds, and sets the copy to the
;;; stale B.
;;;
;;; Instead, we check, after doing a copy, that the information that
;;; was copied still matches the latest information, and redo the copy
;;; if it doesn't.

;;; SUGGESTION: if it become important to pass around deltas, the way
;;; to do that is to have value information contain a promise of the
;;; next version of that value and the delta between those versions.
;;; Then, anything with a handle to an old value can chase the change
;;; path, while GC will get rid of change information for which there
;;; are no longer handles.

;;; TODO: Priorities need to be implemented. Specifically, the
;;; priority of the arguments for a reporter must be higher (lower
;;; value) than the priority of a reporter returned as its value. That
;;; ensures that the arguments will be re-evaluated before the
;;; returned reporter is, since they may cause the returned reporter
;;; to become irrelevant. Further, propagation of invalid information
;;; should also be done by priority, so that it won't propagate to a
;;; reporter that ends up being irrelevant. That propagation still
;;; needs to be higher than for recomputation of the otherwise same
;;; priority, so that recomputations won't happen on stale
;;; information. Also, mutable stores need to hook into the task queue
;;; so their reporters work the same way.

;;; TODO: Approximations need to be implemented.
;;; They logically unfold the dependency graph, with only the last
;;; unfolding being kept around, but all unfoldings being invalidated
;;; when a non-monotonic input changes or a monotonic input changes in
;;; a non-monotonic way.
;;; It uses a map, :approximations
;;;     whose keys are reporters that our
;;;     value depends on, where only a lower bound on their value
;;;     was used in computing our value. The values in the map are a
;;;     pair of [which iteration of that value was used, and which
;;;     iteration of the reporter's value we need as input if our
;;;     value is to be used in the next iteration]. The latter is reset
;;;     to 0 whenever there is a non-monotonic change to an input,
;;;     because that invalidates all iterations that went through
;;;     this reporter.


;;; The manager data record contains all the information that the
;;; various expression managers need.
;;; By making it a record, we can define our own print-method, to
;;; avoid infinite loops when it is printed out. (The queue will
;;; contain references back to the manager data record.)
(defrecord ExpressionManagerData
    [queue      ; A task-queue of pending tasks.
     manage-map ; A map from :manager-type of a reporter to a
                ; function that takes a reporter and a manager data,
                ; does any needed preparation for putting the reporter
                ; under management, and sets its manager.
     cache      ; A mutable map from expression to reporter.
                ; (present if cache reporters are supported.)
     ])

(defmethod print-method ExpressionManagerData [s ^java.io.Writer w]
  ;; Avoid huge print-outs.
  (.write w "<ExpressionManagerData>"))

(defn update-new-further-action
  "Given a map, add an action to the further actions.
   This is used to request actions that affect state elsewhere than
   in the map. They will be done immediately after the map is stored back,
   in the order in which they were requested."
  [data & action]
  (update-in data [:further-actions] (fnil conj []) (vec action)))

(defn modify-and-act
  "Atomically call the function on the reporter's data.
   The function should return the new data for the reporter,
   which may also contain a temporary field, :further-actions with
   a list of actions that should be performed."
  [reporter f]
  (let [actions (swap-control-return!
                 (reporter/data-atom reporter)
                 (fn [data] (let [new-data (f data)]
                              [(dissoc new-data :further-actions)
                               (:further-actions new-data)])))]
    (doseq [action actions]
      (apply (first action) (rest action)))))

(def eval-expression-if-ready)
(def manage)
(def update-old-value-source)

(defn update-value
  "Given the data from a reporter, and the reporter, set the value in the data,
  and request the appropriate propagation."
  [data reporter value]
  (if (= value (:value data))
    data
    (-> data
        (assoc :value value)
        (update-new-further-action reporter/inform-attendees reporter))))

(defn copy-value-callback
  [[_ to] from]
  (with-latest-value [value (reporter/value from)]
    (modify-and-act
     to
     (fn [data] (if (= (:value-source data) from)
                  (cond-> (update-value data to value)
                    (reporter/valid? value)
                    ;; We have finished computing a value,
                    ;; so the old source is not holding
                    ;; onto anything useful.
                    (update-old-value-source to nil))
                  data)))))

(defn null-callback
  [key reporter]
  nil)

(defn register-copy-value
  "Register the need to copy (or not copy) the value from
   the first reporter to become the value of the second."
  [from to]
  (with-latest-value
    [callback (let [data (reporter/data to)]
                (cond (= (:value-source data) from) [copy-value-callback]
                      (= (:old-value-source data) from) [null-callback]))]    
    (apply reporter/set-attendee!
           from (list :copy-value to) callback)))

(defn update-value-source
  "Given the data from a reporter, and the reporter, set the value-source
   to the given source, and request the appropriate registrations.
   If the optional keyword :old true is passed,
   update the old-value-source, rather than value-source."
  [data reporter source & {:keys [old]}]
  ;; We must only set to non-nil if there are attendees for our value,
  ;; otherwise, we will create demand when we have none ourselves.
  (assert (or (nil? source) (reporter/data-attended? data)))
  (let [source-key (if old :old-value-source :value-source)
        original-source (source-key data)]
    (if (= source original-source)
      data
      (reduce
       (fn [data src]
         (update-new-further-action data register-copy-value src reporter))
       (if source
         (assoc data source-key source)
         (dissoc data source-key))
       ;; Add the new source before removing any old one, so that any
       ;; subsidiary reporters common to both will always have demand.
       (filter identity [source original-source])))))

(def clear-old-value-source)

(defn update-old-value-source
  [data reporter source]
  (cond-> (update-value-source data reporter source :old true)
    (not (nil? source))
    ;; We want to keep demand for the old source, but we don't need to
    ;; keep demand for its old source.
    (update-new-further-action clear-old-value-source source)
    (nil? source)
    (dissoc :arguments-unchanged)))

(defn clear-old-value-source
  [reporter]
  (modify-and-act
   reporter
   (fn [data] (update-old-value-source data reporter nil))))

(defn copy-subordinate-callback
  [to from md]
  (with-latest-value [value (reporter/value from)]
    (modify-and-act
     to
     (fn [data]
       (let [same-value
             (= value (get-in data [:subordinate-values from] ::not-found))]
         (if (or (not (reporter/data-attended? data))
                 (not (contains? data :needed-values))
                 (if (contains? (:needed-values data) from)
                   (= value reporter/invalid)
                   same-value))
           data
           ;; A value that we care about changed.
           ;; We are invalid until the recomputation runs,
           ;; which may not be for a while.
           (let [current-source (:value-source data)
                 newer-data (cond-> (update-value data to reporter/invalid)
                              current-source
                              ;; We must do the copy from source to
                              ;; old-source before clearing source,
                              ;; so the old source always has attendees.
                              (#(-> %
                                    (update-old-value-source to current-source)
                                    (assoc :arguments-unchanged true)
                                    (update-value-source to nil))))]
             (if (reporter/valid? value)
               (let [new-data
                     (cond-> (update-in newer-data [:needed-values] disj from)
                       (not same-value)
                       (#(-> %
                             (assoc-in [:subordinate-values from] value)
                             (dissoc :arguments-unchanged))))]
                 (if (empty? (:needed-values new-data))
                   (if (:arguments-unchanged new-data)
                     ;; We have re-confirmed all old values for
                     ;; the old source. Make it current again.
                     (-> new-data
                         (update-value-source to (:old-value-source new-data))
                         (update-old-value-source to nil))
                     ;; Some value changed. Schedule recomputation.
                     (apply update-new-further-action new-data 
                            add-task (:queue md)
                            [eval-expression-if-ready to md]))
                   new-data))
               (update-in newer-data [:needed-values] conj from)))))))))

(defn register-copy-subordinate
  "Register the need to copy (or not copy) the value from the first reporter
  for use as an argument of the second."
  [from to md]
  (with-latest-value
    [callback (let [data (reporter/data to)]
                (when (or (contains? (get data :needed-values #{}) from)
                          (contains? (:subordinate-values data) from))
                  [copy-subordinate-callback md]))]
    (apply reporter/set-attendee! from to callback)))

(defn eval-expression-if-ready
  "If all the arguments for an eval reporter are ready, and we don't have
  a value, evaluate the expression."
  [reporter md]
  (modify-and-act
   reporter
   (fn [data]
     (if (or
          ;; It is possible that we lost demand for this reporter
          ;; since the request to evaluate it was queued, but our
          ;; manager hasn't been informed yet, so this fact is not
          ;; reflected in :needed-values.
          (not (reporter/data-attended? data))
          ;; It is possible to get several eval-expression-if-ready
          ;; queued up for the same reporter. In that case, the first
          ;; one to run will do the evaluations, and the later ones
          ;; will notice that the value is valid, and not bother to
          ;; re-evaluate.
          (reporter/valid? (:value data))
          ;; We don't run if we still need values, or if
          ;; :needed-values is nil, which means that
          ;; nobody is attending to the reporter.
          (not= (:needed-values data) #{}))
       data
       (let [value-map (:subordinate-values data)
             application (map #(get value-map % %) (:expression data))
             value (apply (first application) (rest application))]
         (if (reporter/reporter? value)
           (-> data
               ;; We have to set our value source first, so we
               ;; generate demand for the new value, before we
               ;; manage it.
               (update-value-source reporter value)
               (update-new-further-action manage value md))
           (-> data
               (update-value reporter value)
               (update-value-source reporter nil)
               (update-old-value-source reporter nil))))))))

(defn eval-manager
  "Manager for an eval reporter."
  [reporter md]
  (modify-and-act
   reporter
   (fn [data]
     (if (= (reporter/data-attended? data) (contains? data :needed-values))
       data
       (let [subordinates (set (filter reporter/reporter? (:expression data)))
             new-data (reduce
                       (fn [data subordinate]
                         (update-new-further-action
                          data
                          register-copy-subordinate
                          subordinate reporter md))
                       (update-value data reporter reporter/invalid)
                       subordinates)]
         (if (reporter/data-attended? new-data)
           (-> new-data
               (assoc :needed-values subordinates)
               (assoc :subordinate-values {})
               (update-new-further-action
                add-task (:queue md)
                eval-expression-if-ready reporter md))
           (-> new-data
               (dissoc :needed-values)
               (dissoc :subordinate-values)
               (update-value-source reporter nil)
               (update-old-value-source reporter nil))))))))

(defn manage-eval
  "Have the reporter managed by the eval-manager,
   and manage the terms of its expression."
  [reporter md]
  (reporter/set-manager! reporter eval-manager md)
  ;; We manage the subexpressions after we set our manager. It gives
  ;; them demand, so they will have demand they need before they are
  ;; managed.
  (doseq [term (:expression (reporter/data reporter))]
    (manage term md)))

(defn cached-eval-manager
  "Manager for an eval reporter that is also stored in the cache."
  [reporter md]
  (when (not (reporter/attended? reporter))
    (mm/dissoc-in! (:cache md)
                   [(:expression (reporter/data reporter))]))
  (eval-manager reporter md))

(defn ensure-in-cache
  "Get or make an cached-eval reporter for the given expression in the cache.
  It may not be managed."
  [expression original-name md]
  (mm/update-in!
   (:cache md) [expression]
   #(or % (apply reporter/new-reporter
                 :expression expression
                 :manager-type :cached-eval
                 (when original-name [:name ["cached" original-name]])))))

(defn cache-manager
  "Manager that looks up the value of a reporter's expression in a cache of
  reporters."
  ;; TODO: Add manage-cache, which will replace cache reporters in the
  ;; expression with their cached-eval reporters, to canonicalize the
  ;; expression before it is used.
  [reporter md]
  (let [data (reporter/data reporter)
        expression (:expression data)
        cache (:cache md)]
    ;;; ensure-in-cache has side-effects, which can't run inside a
    ;;; swap!, so we have to use with-latest-value.
    (with-latest-value [attended (reporter/attended? reporter)]
      (let [value-source (when attended
                           (ensure-in-cache
                            expression (:name data) md))]
        (modify-and-act
         reporter
         (fn [data]
           (update-value-source data reporter
                                ;; Might have stopped being attended.
                                (when (reporter/data-attended? data)
                                  value-source))))
        ;; We can't manage the source until the registration is done,
        ;; or its manager will take it out of the cache.
        (when value-source
          (manage value-source md))))))

(defn new-expression-manager-data
  "Create the manager data for a caching evaluator."
  ([] (new-expression-manager-data 0))
  ([worker-threads]
   (map->ExpressionManagerData
    {:cache (mm/new-mutable-map)
     :queue (new-priority-task-queue worker-threads)
     :manage-map {:cache (fn [r m] (reporter/set-manager!
                                    r cache-manager m))
                  :eval manage-eval
                  :cached-eval (fn [r m] (reporter/set-manager!
                                          r cached-eval-manager m))}})))

(defn manage
  "Assign the manager to the reporter
  and to any reporters referenced by its expression."
  [reporter md]
  (when (reporter/reporter? reporter)
    (let [data (reporter/data reporter)
          manager-type (:manager-type data)]
      (when (and manager-type (not (:manager data)))
        (let [manage-fn (manager-type (:manage-map md))]
          (assert manage-fn (format "Unknown manager type: %s" manager-type))
          (manage-fn reporter md))))))

(defn request
  "Request computation of a reporter, returning the reporter."
  [r md]
  (reporter/set-attendee! r :computation-request (fn [key value] nil))
  (manage r md)
  r)

(defn unrequest
  "Remove request for omputation of a reporter."
  [r md]
  (reporter/set-attendee! r :computation-request nil))

(defn compute
  "Do all pending computations, or if the second argument is provided,
   all or that many, which ever comes first."
  ([md]
   (run-all-pending-tasks (:queue md)))
  ([md max-tasks]
   (run-some-pending-tasks (:queue md) max-tasks)))

(defn computation-value
  "Given a possible reporter, compute its value and return it."
  [r md]
  (if (reporter/reporter? r)
    (do (request r md)
        (compute md)
        (reporter/value r))
    r))



