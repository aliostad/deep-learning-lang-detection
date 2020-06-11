(in-ns 'swank.loader)

(defvar- *exit-thread-gensym* (gensym))
(defn exit-thread
  ([]
    (awhen(current-thread-group)
      (.interrupt it))
    *exit-thread-gensym*)
  ([thread-group]
    (.interrupt thread-group)
    *exit-thread-gensym*))
(defn kill-and-exit-thread []
  (kill-lisp *lisp*) (jprintln "FATAL ERROR!")
  (exit-thread))

(defn- redirect-stream-helper [input-stream f args]
  (let [channel (nio input-stream)]
    (let [buf (allocate-byte-buffer 1024)]
      (loop []
        (if (not (and
                   (> (.available input-stream) 0)
                   (= (apply f (.read channel (clear buf)) buf args) *exit-thread-gensym*)))
          (do (Thread/sleep 100)
            (recur)))))))
            
(defn redirect-stream [input-stream f & args]
  (with-global-thread (nil nil true) [*lisp* *swank*]
    (redirect-stream-helper input-stream f args)))

(defn redirect-grouped-stream [input-stream thread-group f & args]
  (with-global-thread (nil thread-group true) [*lisp* *swank*]
    (redirect-stream-helper input-stream f args)))

(defn monitor-lisp-stream [i byte-buffer string-atom] 
  (if (< i 0)
    (exit-thread)
    (let [buf-str (to-string byte-buffer)
          s (str @string-atom buf-str)]
      (jprintln buf-str)
      (cond
        (find-fatal-error *lisp* buf-str) (kill-and-exit-thread)
        (re-find #"(?i)Swank started" s) (do (jprintln "Swank Started!!!") (exit-thread))
        :else (let [result (s/split-lines s)]
                (if (single? result)
                  (reset! string-atom "")
                  (reset! string-atom (last result))))))))


(defn startup-lisp-monitor [f]
  (let [grouped-thread (new-group-thread "Lisp Monitoring Threads")
        th1 (redirect-grouped-stream @(:input-stream *lisp*) grouped-thread
              monitor-lisp-stream (atom ""))
        th2 (redirect-grouped-stream @(:error-stream *lisp*) grouped-thread
              monitor-lisp-stream (atom ""))]
    (reset! (:error-thread *lisp*) th2)
    (reset! (:input-thread *lisp*) th1)
    grouped-thread))


