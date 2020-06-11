(ns
    ^{:doc "Wrap java.io.Closeable objects in a machanism that will eventually ensure they're closed."}
  jdt.closer
  (:require clojure.repl)
  (:require clojure.java.shell)
  (import java.io.Closeable)
  (import java.util.Vector)
  (import [java.lang.ref PhantomReference ReferenceQueue]))


(defonce ^{:private true
           :doc "Queue to receive PhantomReference subtypes when they're ready to GC."}
  reference-queue (ReferenceQueue.))

(defonce ^{:private true :doc "Synchronized collection to manage PhantomReference instances"}
  phantom-queue (Vector.))

(def ^{:private true :doc "Field with which to access the phantom object reference in a dirty way."}
  referent-field 
  (let [field (.getDeclaredField java.lang.ref.Reference "referent")]
    (.setAccessible field true)
    field))

(defn ensure-close
  "Ensure that a Closeable object will have .close invoked on it when it's GC'd"
  [obj]
  {:pre (instance? Closeable obj)}
  (let [phantom-reference
        (proxy [PhantomReference] [obj reference-queue])] ;second vector are constructor/super args
    ;;(println "ensure-close phref:" phantom-reference "Closeable" obj)
    (.add phantom-queue phantom-reference))
  obj)
    
(defonce ^{:private true :doc "Number of times we called closed on Closeables here.  Mostly for testing."}
  close-count (atom 0))

(defn- process-queue []
  (while true
    (let [reference (.remove reference-queue)
          obj (.get referent-field reference)]
      ;;(println "process-queue: got one!" reference obj)
      (try
        (when (instance? java.io.Flushable obj)
          (try
            ;; This can fail if the object has already been closed in a finalize method, that's okay
            ;; FileInputStream and FileOutputStream have finalize methods in java 1.7
            (.flush obj)
            (catch Exception e
              #_
              (clojure.repl/pst e))))   ;probably don't want to print the exception
        (.close obj) ;Closeable.close supposed to be idempotent, so no error if already closed
        (swap! close-count inc)
        (catch Exception e
          (clojure.repl/pst e)))       ;print it, close isn't suppposed to throw if already closed
      ;; This enables final removal from heap
      (.remove phantom-queue reference)))
  (println "Exiting " *ns* "process-queue"))

(defonce ^{:private true :doc "Process dead Closeables in the queue"}
  the-thread
  (doto (Thread. process-queue)
    (.setDaemon true)
    (.start)))
           
(defn- ctest1 []
  (let [x (ensure-close (clojure.java.io/writer "/tmp/foo"))
        count @close-count]
    (.write x "hello world")
    (println "test1a:" @close-count (clojure.java.shell/sh "ls"  "-l" "/tmp/foo"))
    (dotimes [i 10] (System/gc))
    (if (> @close-count count)
      (println "  ** unexpected, @close-count > count"))
    (println x)                         ;keep x alive
    (println "test1b:" @close-count (clojure.java.shell/sh "ls"  "-l" "/tmp/foo"))))

(defn ctest []
  (clojure.java.shell/sh "rm" "/tmp/foo")
  (let [count @close-count]
    (ctest1)
    (dotimes [i 10] (System/gc))
    (while (= count @close-count)
      (println "  ** unexpected, count == @close-count, trying again")
      (dotimes [i 10] (System/gc)))
    (println "test:" @close-count (clojure.java.shell/sh "ls"  "-l" "/tmp/foo"))))

;;(println "Caution: daemon *out* goes to *nrepl server* buffer in cider")

#_
(ctest)

#_
(dotimes [i 10] (ctest))

;; What about lazily creating and starting the thread based on the first call to ensure-close?
;; More tests.  Then wrap lazy directory or other type FS metods.

