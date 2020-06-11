
(require '[com.twinql.clojure.http :as http])
(require '[work.core :as work])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Exception-free wrapper for clojure.http component.
;

(defn try-get
  "Wrapper for the com.twinql.clojure.http component. Returns 
  either valid clojure.http response, or the empty response.
  Requires URL, proxy host and port, clojure.http connection
  manager, timeout in ms, and the User-Agent string."
  [url host port ccm timeout browser]
  (try
    (http/get url
              :as :string
              :connection-manager ccm
              :parameters (http/map->params
                            {:default-proxy (http/http-host :host host :port port)
                             :so-timeout timeout
                             :connection-timeout timeout
                             :user-agent browser}))
    (catch Exception e {:code 0 :reason "" :content "" :headers {}})))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Proxy discovering stuff. Requires the list of proxies in
; data/proxy-list.txt.
;
; Accesses the echo server "http://xformstest.org/cgi-bin/echo.sh"
; via each of the listed proxies.
;
; Tries to find the proof of proxy being 1) valid, 2) anonymous -
; a string like "REMOTE_ADDR=212.92.245.244" in the response.
;
; Produces the file "proxies.txt" which contains valid anonymous
; proxies for later work.
;
; Warning: (discover) is a lengthy operation; 1 minute or so.
; It complains a lot on the servers; that's all right.
;

(defn- split-proxy [x]
  (let [pair (re-seq #"[^:]+" x)]
    [ (first pair) (Integer/valueOf (second pair)) ]))

(defn- check-proxy
  "Checks the proxy to be able to access xformstest.org diring the
  specified timeout and to provide its IP to the server, instead
  of local IP."
  [host port ccm timeout]
  (let [result (try-get "http://xformstest.org/cgi-bin/echo.sh"
                        host port ccm timeout "Mozilla/4.0 (compatible)")
        retval (and
                 (= (:code result) 200)
                 (re-find
                   (re-pattern (str "REMOTE_ADDR=" host))
                   (:content result)))]
    (if retval
      (println (str [host port] "       OK."))
      (println (str [host port])))
    retval))

(defn discover
  "Examines proxies from data/proxy-list.txt who manage to proove
  that they are valid and anonymous during the specified timeout,
  and writes the valid proxies to proxies.txt"
  [timeout]
  (let [proxy-list (re-seq #"\S+" (slurp "data/proxy-list.txt"))
        candidates (vec (map split-proxy proxy-list))]
    (http/with-connection-manager
      [ccm :thread-safe]

      (defn- valid-proxy? [[host port]] ; something curryish. Lambdas are harder to read.
        (check-proxy host port ccm timeout))

      (let [valid-proxies
            (vec
              (work/filter-work valid-proxy? candidates 200))]
        (println (count valid-proxies) " valid proxies found.")
        (println "Writing file 'proxies.txt'.")
        (spit "proxies.txt" valid-proxies)
        (println "Done.")))))

; (discover 1000)
; (discover 500)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Stuff to select random User-Agent strings according to distribution
; of browsers in the wild.
;

(defn weighted-iter
  "Takes an array of weights (that is, frequencies), and returns a fn
  which returns a random integer which lies in (range (count weights))
  and is distributed according to the weights."
  [weights]
  (let [part-sums   (vec (reductions + (map float weights)))
        total-sum   (last part-sums)
        total-num   (count weights)
        index-range (range total-num)]
    (fn [] 
      (let [scaled-rand (* (rand) total-sum)
            index       (first (filter #(<= scaled-rand (get part-sums %)) index-range))]
        (if (nil? index)
          (dec total-num)
          index)))))

; (let [f (weighted-iter [1 2 3])]
;   (dotimes [_ 1000] (prn (f))))

(let [agent-pairs (partition 2 (load-file "data/agent-pairs.txt"))
      user-agents (vec (map second agent-pairs))
      agent-iter  (weighted-iter (map first agent-pairs))]
  (defn weighted-random-user-agent []
    (user-agents (agent-iter))))

; (dotimes [_ 20]
;   (prn (weighted-random-user-agent))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Insistent anonymous fetching function. Tries to push the request
; through each of the (unreliable) proxies. Randomly orders the proxies
; for better overall throughput. Returns a valid clojure.http response
; on success, nil on failure (that is, when neither of the proxies
; managed to service the request during the specified timeout).
;

(defn insist-get [url ccm proxies timeout]
  (let [shuffled-proxies (shuffle proxies)
        num-proxies (count proxies)]
    (loop [pos 0]
      (if (>= pos num-proxies)
        nil
        (let [the-proxy (shuffled-proxies pos)
              [host port] the-proxy
              user-agent (weighted-random-user-agent)
              result (try-get url host port ccm timeout user-agent)]
          (if (= (:code result) 200)
            result
            (recur (inc pos))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; parallel fetcher itself
;

(defn pa-fetch [urls proxies timeout]

  (http/with-connection-manager
    [ccm :thread-safe]

    (defn- getter [url] ; something curryish. Lambdas are harder to read.
      (insist-get url ccm proxies timeout))

    (work/map-work getter urls 200)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 
;; The top-level stuff.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Discovering proxies
;

(def timeout 1000)    ; proxies are far away and busy.

(time (discover timeout))

;
; Loading alive proxies for use
;
(def proxies (load-file "proxies.txt"))

;
; Parallel test
;

(doseq [num-urls [50 100 200]]
  (let [urls (repeat num-urls "http://www.example.com/")]
    (time
      (def responses
        (pa-fetch urls proxies timeout)))
    (prn (map :code responses))  ; should be (200 200 200 ... 200)
    ))

