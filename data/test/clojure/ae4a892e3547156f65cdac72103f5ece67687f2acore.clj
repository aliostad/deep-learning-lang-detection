(ns sicp-examples.core)


;; Chapter 3

;; 3.1

(defn make-accumulator
  [initial-value]
  (let [i (atom initial-value)]
    (fn [increment]
      (swap! i (partial + increment)))))

;; 3.2

(defn make-monitored
  [f]
  (let [initial-count (atom 0)]
    (fn [dispatch]
      (cond (= 'reset-count dispatch)
            (swap! initial-count (constantly 0))
            (= 'how-many-calls? dispatch)
            @initial-count
            :else
            (do
              (swap! initial-count inc)
              (f dispatch))))))

;; 3.3

(defn make-account
  [initial-balance secret-password]
  (let [balance (atom initial-balance)]
    (fn [dispatch offered-password]
      (cond (not= secret-password offered-password)
            "Incorrect Password"
            (= dispatch 'withdraw)
            (fn [amount]
              (if (>= @balance amount)
                (do
                  (swap! balance #(- % amount))
                  @balance)
                "Insufficient Funds"))
            (= dispatch 'deposit)
            (fn [amount]
              (swap! balance (partial + amount))
              @balance)))))

;; 3.4

(defn call-the-cops!
  []
  (println "Cops have been called"))

(defn make-account
  [initial-balance secret-password]
  (let [balance                     (atom initial-balance)
        incorrect-password-attempts (atom 0)]
    (fn [dispatch offered-password]
      (cond (not= secret-password offered-password)
            (do (swap! incorrect-password-attempts inc)
                (when (= @incorrect-password-attempts 7)
                  (do (call-the-cops!)
                      (reset! incorrect-password-attempts 0)))
                "Incorrect Password")
            (= dispatch 'withdraw)
            (fn [amount]
              (if (>= @balance amount)
                (do
                  (swap! balance #(- % amount))
                  @balance)
                "Insufficient Funds"))
            (= dispatch 'deposit)
            (fn [amount]
              (swap! balance (partial + amount))
              @balance)))))
