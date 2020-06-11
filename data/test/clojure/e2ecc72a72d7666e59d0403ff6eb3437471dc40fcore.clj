(ns async-pipeline.core
  (:require [clojure.core.async :as async :refer [go >! <!]]
            [clojure.pprint :refer [pprint]]))

(def ^:dynamic *debug* false)

(defn print-debug
  [& msgs]
  (when *debug*
    (->> (map (fn [msg]
                (if (string? msg)
                  msg
                  (with-out-str
                    (pprint msg))))
              msgs)
         (apply str "DEBUG: ")
         (print))))

(defmacro if-recv
  [[name take-expr :as binding] conseq alt]
  `(let ~binding
     (if-not (nil? ~name)
       ~conseq
       ~alt)))

(defmacro when-recv
  [[name take-expr :as binding] & conseq]
  `(if-recv ~binding
     (do ~@conseq)
     nil))

(defmacro go-try
  "Like `clojure.core.async/go`, but exceptions through in the body
  will be returned on the go block's channel in the form
  `[:thrown EXCEPTION]`."
  [& body]
  `(go
     (try
       ~@body
       (catch Throwable t#
         [:thrown t#]))))

(defn chain-procs
  [procs top-in top-out chan-thunk]
  (loop [[proc & remaining] procs
         proc-data []
         cur-in top-in
         cur-out (chan-thunk)]
    (let [proc-data (conj proc-data {:proc proc
                                     :in cur-in
                                     :out (if (empty? remaining)
                                            top-out
                                            cur-out)})]
      (if (empty? remaining)
        proc-data
        (recur remaining proc-data cur-out (chan-thunk))))))

(defn start-procs!
  [proc-data]
  (doall (map (fn [{:keys [proc in out]}]
                (print-debug "starting proc " proc)
                (proc in out))
              proc-data)))

(defn manage-processes!
  "Start and manage a set of proceeses, putting returned error values
  onto `err-port` and restarting processes when they die. Returns a
  control channel that, if closed, indicates that all processes should
  be killed. (This means closing all channels.)
  "
  [proc-data err-port]
  (let [ctrl (async/chan)]
    (go
      (loop [cs (start-procs! proc-data)
             chan->proc (zipmap cs proc-data)]
        (let [[msg ch] (async/alts!! (conj cs ctrl))]
          (condp = ch
            ctrl (do (print-debug "shutting down procs\n")
                     (print-debug "closing " err-port)
                     (async/close! err-port)
                     (doseq [{:keys [in out]} proc-data]
                       (print-debug "closing " in)
                       (async/close! in)
                       (print-debug "closing " out)
                       (async/close! out)))

            (let [{:keys [proc in out] :as proc-data} (chan->proc ch)]
              (print-debug "restarting proc " proc)
              (let [new-proc-chan (proc in out)]
                (when-not (nil? msg)
                  (>! err-port msg))
                (recur (conj (remove #(= % ch) cs) new-proc-chan)
                       (assoc (dissoc chan->proc ch)
                         new-proc-chan proc-data))))))))
    ctrl))

(defn pipeline
  "Constructs a process pipeline by stringing together a series of
  processes using channels returned from chan-thunk. A four-tuple of
  channels is returned: `[in out err ctrl]`. Messages should be put
  into `in` and received from `out` after processing. Errors will
  appear on `err`.

  A process is a binary function that accepts two arguments, a read
  port and a write port, and processes messages received from the read
  port, writing them to the write port. Processes should loop and
  continuously read so long as they do not encounter errors.

  A process signals an error by exiting its loop and returning an
  error value, which will appear on `err`. The process will be
  automatically restarted. (This will also occur in the event of an
  exception, in which case the message `[:thrown EXCEPTION]` will be
  put onto `err`.)

  The entire pipeline can be closed by closing `ctrl`.
  "
  [chan-thunk & procs]
  (let [[in out err] (repeatedly 3 chan-thunk)
        proc-chain (chain-procs procs in out chan-thunk)
        ctrl (manage-processes! proc-chain err)]
    [in out err ctrl]))
