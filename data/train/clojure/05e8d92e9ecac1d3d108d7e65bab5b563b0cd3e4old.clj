(import '(java.net ServerSocket))
(import '(java.io InputStreamReader))
(import '(java.io BufferedReader))

(println "Connecting on port 5000")
(def server-socket (ServerSocket. 5000))

(println "Connected.")
(def client-socket (. server-socket accept))

(def out-stream (. client-socket getOutputStream))

(def in-stream 
  (BufferedReader. 
    (InputStreamReader.
      (. client-socket getInputStream))))

;(loop [in-line line]
;  (if (not (nil? line)))
;    (println line)
;    (recur line))

;(defn listen
;  ([] (listen (. in-stream readLine)))
;  ([line]
;    (if (not (nil? line)) (println line))
;    (recur (listen (. in-stream readLine)))
;  )
;)

(loop [line (. in-stream readLine)]
  (if (not (nil? line)) (println line))
  (recur [line (. in-stream readLine)]))

;(listen [])

(. out-stream close)
(. in-stream close)
(. client-socket close)
(. server-socket close)
(println "Disconnected.")