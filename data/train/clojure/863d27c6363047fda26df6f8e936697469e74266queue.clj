(ns ekahau.queue
  (:import
    [java.util.concurrent BlockingQueue LinkedBlockingQueue]))

;; Sequence from queue

(defn seq-from-blocking-queue
  "Creates a sequence from java.util.concurrent.BlockingQueue. Sequence
  ends when a terminator element specified by terminator? functions is
  reached."
  ([^BlockingQueue queue]
    (seq-from-blocking-queue queue #(= :terminator %)))
  ([^BlockingQueue queue terminator?]
    (take-while (complement terminator?) (repeatedly #(.take queue)))))

;; Functions that manage a queue in an atom ;;

(defn create-queue-atom
  "Creates an atom that tracks a queue and its open/closed state.
  Atom state is a hash-map with the following keys:
    :queue  - blocking queue itself 
    :opened - is a sequence that drains the queue has been created?
    :closed - is a terminator value has sent to the queue?"
  ([]
    (create-queue-atom (LinkedBlockingQueue. 32)))
  ([^BlockingQueue queue]
    (atom {:queue queue
           :opened false
           :closed false})))

(defn open-queue-as-seq!
  "Returns a sequence that gets its values from the queue of a given atom.
  Only one queue can be created per atom and therefor subsequent calls with
  the same atom will return nil."
  [queue-atom]
  (let [new-seq-atom (atom nil)]
    (swap! queue-atom
      (fn [value]
        (if-not (:opened value)
          (do
            (reset! new-seq-atom (seq-from-blocking-queue (:queue value)))
            (assoc value :opened true))
          value)))
    @new-seq-atom))

(defn close-queue!
  "Closes the queue by adding terminator value to the queue. The sequence
  draining the queue will get all the values that were put in the queue before
  the terminator."
  [queue-atom]
  (swap! queue-atom
    (fn [value]
      (if (:opened value)
        (if (:closed value)
          value
          (do
            (.put ^BlockingQueue (:queue value) :terminator)
            (assoc value :closed true)))
        (assoc value :opened true :closed true)))))
