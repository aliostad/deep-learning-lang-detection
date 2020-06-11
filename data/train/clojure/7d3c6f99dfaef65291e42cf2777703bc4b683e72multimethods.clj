(in-ns 'lisp.loader)
;;;;;;;;;;;;MULTIMETHODS
;;;;;;;;;;;;
(defmulti find-fatal-error lisp-type)
(defmethod find-fatal-error :default [lisp st]
  (re-find (re-pattern (:fatal-error lisp)) st))

(defmulti new-lisp (fn [& args] (first args)))
(defmethod new-lisp  :default [lisp-type exe args env]
  (mk-lisp-structure
    :type lisp-type
    :fatal-error "fatal error"
    :process-builder (new-process-builder exe args env)))


(defmulti start-lisp lisp-type)
(defmethod start-lisp :default [lisp-implementation]
  (let [process (.start (:process-builder lisp-implementation))]
    (merge lisp-implementation {:process process
                                :output-stream (DataOutputStream. (.getOutputStream process))
                                :input-stream (agent (.getInputStream process))
                                :error-stream (agent (.getErrorStream process))})))

;;;;;;;;;;;
;;;;;;;;;;