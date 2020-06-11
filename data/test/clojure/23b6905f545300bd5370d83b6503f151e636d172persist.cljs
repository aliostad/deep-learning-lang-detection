(ns golem.persist
  (:use [golem.analytics :only [stringify]]))

; persistence api, should be backend neutral
; need to be able to manage object storages/collections
; and key/value management, use JSON for now
; inital targets indexedDB browser, CouchDB server

(defn send-msg [msg cb]
  (.sendMessage backend (clj->js msg) cb))

(defn- upgrade-db! [ev]
  (let [db (.. ev -target -result)]
    (js/alert "Upgrading db!")
    (.createObjectStore db "page-content" (clj->js {:keyPath "url"}))))


(defn open-db
  "Expects a map for :db in state and in it
   :name of the db, :version as long and optionally
   callbacks for success and error."
  [state & cbs]
  (let [{:keys [db]} @state
        {:keys [name version]} db
        [onsucc onerr] cbs
        req (.open js/indexedDB name version)]
    (set! (.-onsuccess req)
          (fn [e] (swap! state
                        #(assoc-in % [:db :handle]
                                   (.-result req)))
            (if onsucc (onsucc e))))
    (set! (.-onerror req) onerr)
    (set! (.-onupgradeneeded req) upgrade-db!)
    nil))

(defn start-db! [state]
  (open-db state))


(defn trans!
  "Creates a transaction handle to access an
   object store. Parameters are db for the IndexedDB,
   stores for all stores taking part in the transaction
   the mode and optionally a callback for success and error."
  ([db stores]
     (trans! db stores :readonly))
  ([db stores mode & cbs]
     (let [mode (if (keyword? mode) (name mode) mode)
           stores (clj->js stores)
           [oncomp onerr] cbs
           trans (.transaction db stores mode)]
       (set! (.-oncomplete trans) oncomp)
       (set! (.-onerror trans) onerr)
       trans)))


(defn add! [trans store data]
  (let [objstore (.objectStore trans store)]
    (doall (map #(.add objstore (clj->js %)) data))))


(defn curse! [trans store & cbs]
  (let [[onsucc onerr] cbs
        objstore (.objectStore trans store)
        cursor (.openCursor objstore)]
    (set! (.-onsuccess cursor) onsucc)
    (set! (.-onerr cursor) onerr)
    nil))

; TODO proper error handling
(defn put! [db store entries]
  (let [entries (if-not (seq? entries) [entries] entries)
        trans (trans! db [store] :readwrite)]
    (add! trans store entries)))


(defn get! [db store keys]
  (let [keys (if-not (seq? keys) [keys] keys)
        trans (trans! db [store] :readwrite)]
    (add! trans store entries)))
