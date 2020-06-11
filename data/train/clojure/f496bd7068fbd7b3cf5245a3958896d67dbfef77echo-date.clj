(ns softserv.examples.echo-date
  (:use [softserv :only (defservice defhandler create-server)])
  (:import [java.io BufferedReader BufferedWriter InputStreamReader]))

(defn echo-date-parser [s]
  (binding [*in* (BufferedReader.
                  (InputStreamReader.
                   (.getInputStream s)))]
    (let [l (read-line)]
      (assoc {:data l} :type (if (= l "date") :date :echo)))))

(defservice echo-date :type echo-date-parser)

(defhandler echo-date :echo
  [s req]
  (binding [*out* (BufferedWriter.
                   (OutputStreamWriter.
                    (.getOutputStream s)))]
    (with-shutdown s
      (println (:data req)))))

(defhandler echo-date :date
  [s req]
  (Thread/sleep 10000)
  (binding [*out* (BufferedWriter.
                   (OutputStreamWriter.
                    (.getOutputStream s)))]
    (with-shutdown s
      (println (str (java.util.Date.))))))

(create-server :port 20000 :service echo-date :size 10))

