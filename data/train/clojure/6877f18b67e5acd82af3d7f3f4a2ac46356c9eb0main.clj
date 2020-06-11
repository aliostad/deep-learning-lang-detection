;Brandon Stock, Dillon Stenberg, and Bailey Denzer

(ns BakersClojure.main
(:require [clojure.core.async
             :as async
             :refer [>! <! >!! <!! go chan buffer close! thread
                     alts! alts!! timeout]]))

(defrecord Customer
  [id n fib-of-n server])

(defn make-customer [id]
  (let [n (+ 30 (rand-int 10))
        customer (->Customer id n (atom nil) (atom nil))]
    (add-watch (:fib-of-n customer) id
               (fn [key atom old-value new-value]
                 (println (str "Customer " key " changed from " old-value " to " new-value "."))))
    customer))

(defn put-customer [customer customers]
  (Thread/sleep (rand-int 100))
  (>!! customers (make-customer customer)))

(defn put-customers [num-customers customers]
  (doseq [customer-id (range num-customers)]
    (put-customer customer-id customers))
  (close! customers))


(defn make-customers [num-customers]
    (let [customers (chan)]
        (future (put-customers num-customers customers))
      customers))

(defn set-fib-value
  [customer value]
  (reset! (:fib-of-n customer) value))

(defn fib [n]
  (case n
    0 0
    1 1
    (+ (fib (- n 1))
       (fib (- n 2)))))

(defrecord Server
  [id customers-served])

(defn make-server [id]
  (let [server (->Server id (atom []))]
    (add-watch (:customers-served server) id
               (fn [key atom old-value new-value]
                 (println (str "Server " key " has now served " new-value "."))))
    server))

(defn make-servers [num-servers]
  (let [servers (chan)]
   (doseq [server-id (range num-servers)]
           (go (>! servers (make-server server-id))))
    servers))


(defn add-served-customer [server customer-id n]
  (swap! (:customers-served server) conj {:customer-id customer-id, :n n}))

(defn serve [server customer server-channel]
  (let [result (fib (:n customer))]
    (set-fib-value customer result)
    (add-served-customer server (:id customer) (:n customer))
    (go (>! server-channel server))
    result))


(defn manage-bakery
  [num-servers num-customers]
  (let [customers (make-customers num-customers)
        servers (make-servers num-servers)
        pairs (async/map (fn [customer server]
                           {:customer customer,
                            :server server,
                            :server-channel servers})
                         [customers servers])]
    (loop []
      (when-let [{server :server, customer :customer, servers :server-channel}
                 (<!! pairs)]
        (go
         (serve server customer servers))
        (recur)))))



(defn -main []
  (manage-bakery 20 200))
