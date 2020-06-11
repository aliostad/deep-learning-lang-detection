(ns clojure-socket-echo.core
	(:use server.socket))
(import '[java.io BufferedReader InputStreamReader OutputStreamWriter])

(defn echo-server []
  (letfn [(echo [in out]
                    (binding [*in* (BufferedReader. (InputStreamReader. in))
                              *out* (OutputStreamWriter. out)]
                      (loop []
                        (let [input (read-line)]
                          (print input)
                          (flush))
                        (recur))))]
    (create-server 8080 echo)))
(defn -main []
  (echo-server))