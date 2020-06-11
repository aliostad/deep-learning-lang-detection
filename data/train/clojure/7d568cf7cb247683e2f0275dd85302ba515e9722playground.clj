(ns playground
	(:require
		[taoensso.timbre :as log]
		[clojure.test :refer :all])
	(:gen-class :main true))

(defn tests [] (do (use 'playground :reload-all) (run-tests)))

(def instruments {:eur_usd 4001 :gbp_usd 4002 :eur_gbp 4003})
(def instruments_by_id (clojure.set/map-invert instruments))

(defn err-log-fn [ag ex]
	(log/error (str "error occured in rates agent " ag ": " ex)))
(def rates (apply merge (map #(hash-map % (agent [] :error-handler err-log-fn)) (keys instruments))))
(defstruct rate :instr :price)
(defn add-rate [fx-rate]
	(send (rates (fx-rate :instr)) #(conj % (fx-rate :price))))
(defn purge-rates [] 
	(doseq [prices-agent (vals rates)]
		(send prices-agent (fn [init_state] []))))

(defn round [s n] 
	(.setScale (bigdec n) s java.math.RoundingMode/HALF_EVEN))
(def contract-size 10000)
(defn profit-and-loss [current-position]
	(round 2
		(*
			(- (current-position :current-price) (current-position :position-price) )
			(current-position :contracts)
			contract-size)))


(defn -main [& args]
	(do (log/info "here is main")))


(deftest should-create-frequency-map
	(is (= {1.8361 1 1.8362 2} (frequencies [1.8361 1.8362 1.8362]))))

(deftest should-calculate-profit-loss-of-current-position
	(is (= (round 2 0.1) (profit-and-loss {:contracts 1 :position-price 1.35511 :current-price 1.35512})))
	(is (= (round 2 0.2) (profit-and-loss {:contracts 2 :position-price 1.35511 :current-price 1.35512}))))

(deftest should-add-rate-and-purge-it
	(add-rate (struct rate :eur_usd 2.3))
	(is (= [2.3] (deref (rates :eur_usd))))
	(purge-rates)
	(is (= [] (deref (rates :eur_usd)))))

(deftest should-create-rate-as-structure
	(is (= 1.5 (:price (struct rate :eur_usd 1.5)))))

(deftest should-create-rates-history-as-map-of-instrument-to-agent
	(is (= (count instruments) (count rates))))

(deftest should-get-instrument_by_id
	(is (= :eur_usd (instruments_by_id 4001))))

