(ns bakers.core
  (:require
   [clojure.core.async :as async]
  (:gen-class)))

(defn set-fib-value
  [customer value]
  (reset! (:fib-of-n customer) value))

(defn fib [n]
  (if (> n 1)
    (+ (fib (- n 1)) (fib (- n 2)))
    1
    )
  )

(defn serve [server customer servers]
  (let [n (:n customer)
        ]
    (async/go
      (set-fib-value customer (fib n))
      (swap! (:customers-served server) conj (:id customer))
      (async/>! servers server)
    )
    )
  )

(defrecord Customer
  [id n fib-of-n server])

(defn make-customer [id]
  (let [n (+ 30 (rand-int 10))
        customer (->Customer id n (atom nil) (atom nil))]
    (add-watch (:fib-of-n customer) id
               (fn [key atom old-value new-value]
                 (println (str "Customer " key " changed from " old-value " to " new-value "."))))
    customer))

(defrecord Server
  [id customers-served])

(defn make-server [id]
  (let [server (->Server id (atom []))]
    (add-watch (:customers-served server) id
               (fn [key atom old-value new-value]
                 (println (str "Server " key " has now served " new-value "."))))
    server))

(defn add-served-customer [server customer-id n]
  (swap! (:customers-served server) conj {:customer-id customer-id, :n n}))

(defn make-customers [num customers]
  (if (> num 0)
    (async/go (async/>! customers (make-customer num)))
    )
  (if (> num 0)
   (make-customers (- num 1) customers)
    )
  customers

  )

(defn make-servers [num servers]
  (println "making servers")
  (if (> num 0)
    (async/go (async/>! servers (make-server num)))

    )
  (if (> num 0)
   (make-servers (- num 1) servers)
    )
  servers
  )

(defn manage-bakery
  [num-servers num-customers]
  (let [customers (make-customers num-customers (async/chan))
        servers (make-servers num-servers (async/chan))
        pairs (async/map (fn [customer server]
                           {:customer customer,
                            :server server,
                            :server-channel servers})
                         [customers servers])]
    (loop []
      (when-let [{server :server, customer :customer, servers :server-channel}
                 (async/<!! pairs)]
        (async/go
         (serve server customer servers))
        (recur)))
    )
  )


(defn -main []
  (println "main")
  (manage-bakery 3 10))
