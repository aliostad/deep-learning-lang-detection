(ns cbfg.npr ; NPR stands for aNother Protocol for Replication, pronounced like UPR.
  (:require-macros [cbfg.act :refer [achan-buf act act-loop
                                     aput aput-close atake]]))

; TODO: What if the underlying bucket / collection is deleted, flushed or DDL modified?

(defprotocol NPRSnapshot
  (snapshot-rollback? [this])
  (snapshot-items [this])
  (snapshot-next-sq [this]
    "The next snapshot after this one should start at next-sq"))

(defprotocol NPRStreamRequest
  "Methods to help form NPR protocol messages"
  (stream-request-snapshot-beg-msg [this snapshot])
  (stream-request-snapshot-end-msg [this snapshot])
  (stream-request-snapshot-item-msg [this snapshot item])
  (stream-request-rollback-msg [this rollback-info])
  (stream-request-start-sq [this]))

(defprotocol NPRServer
  "Methods than an NPR protocol server must implement"
  (server-take-snapshot [this actx stream-request prev-snapshot]))

(defprotocol NPRClient
  "Methods than an NPR protocol client must implement"
  (client-stream-request-msg [this actx token])
  (client-rollback [this actx stream-request rollback-msg])
  (client-snapshot-beg [this actx stream-request snapshot-beg])
  (client-snapshot-end [this actx stream-request snapshot-beg snapshot-end])
  (client-snapshot-item [this actx stream-request snapshot-beg snapshot-item]))

(defn handle-npr-server-stream-request [actx server stream-request-in to-client-ch]
  (act-loop npr-server-session actx
            [stream-request stream-request-in
             snapshot (server-take-snapshot server actx stream-request-in nil)
             num-snapshots 0]
            (cond
             (nil? snapshot)
             (aput-close npr-server-session to-client-ch
                         (assoc stream-request :status :ok))

             (snapshot-rollback? snapshot)
             (aput-close npr-server-session to-client-ch
                         (stream-request-rollback-msg stream-request snapshot))

             :else
             (when (aput npr-server-session to-client-ch
                         (stream-request-snapshot-beg-msg stream-request snapshot))
               (doseq [item (snapshot-items snapshot)]
                 (aput npr-server-session to-client-ch
                       (stream-request-snapshot-item-msg stream-request snapshot item)))
               (when (aput npr-server-session to-client-ch
                           (stream-request-snapshot-end-msg stream-request snapshot))
                 (recur stream-request
                        (server-take-snapshot server actx stream-request snapshot)
                        (inc num-snapshots)))))))

(defn npr-client-stream-loop [actx client stream-request snapshot-beg-in out from-server-ch]
  (act-loop npr-client-stream-loop actx
            [stream-request stream-request
             snapshot-beg nil
             r snapshot-beg-in
             num-snapshots 0
             num-items 0]
            (cond
             (nil? r)
             (aput-close npr-client-stream-loop out {:status :closed})

             (= (:status r) :ok)
             (aput-close npr-client-stream-loop out {:status :ok})

             (and snapshot-beg
                  (= (:status r) :part)
                  (= (:sub-status r) :snapshot-item))
             (if-let [err (client-snapshot-item client
                                                npr-client-stream-loop
                                                stream-request
                                                snapshot-beg r)]
               (aput-close npr-client-stream-loop out err)
               (recur stream-request snapshot-beg
                      (atake npr-client-stream-loop from-server-ch)
                      num-snapshots (inc num-items)))

             (and snapshot-beg
                  (= (:status r) :part)
                  (= (:sub-status r) :snapshot-end))
             (if-let [err (client-snapshot-end client
                                               npr-client-stream-loop
                                               stream-request
                                               snapshot-beg r)]
               (aput-close npr-client-stream-loop out err)
               (recur stream-request nil
                      (atake npr-client-stream-loop from-server-ch)
                      (inc num-snapshots) num-items))

             (and (nil? snapshot-beg)
                  (= (:status r) :part)
                  (= (:sub-status r) :snapshot-beg))
             (if-let [err (client-snapshot-beg client
                                               npr-client-stream-loop
                                               stream-request r)]
               (aput-close npr-client-stream-loop out err)
               (recur stream-request r
                      (atake npr-client-stream-loop from-server-ch)
                      num-snapshots num-items))

             (and (nil? snapshot-beg)
                  (= (:status :rollback)))
             (aput-close npr-client-stream-loop out
                         (client-rollback client
                                          npr-client-stream-loop
                                          stream-request r))

             :else
             (aput-close npr-client-stream-loop out {:status :unexpected-msg}))))

(defn start-npr-client-stream [actx client token to-server-ch from-server-ch]
  (let [out (achan-buf actx 1)
        stream-request (client-stream-request-msg client actx token)]
    (act npr-client-stream actx
         (aput npr-client-stream to-server-ch stream-request)
         (npr-client-stream-loop npr-client-stream client stream-request
                                 (atake npr-client-stream from-server-ch)
                                 out from-server-ch))
    out))
