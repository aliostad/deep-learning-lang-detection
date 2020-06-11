(ns river.seq

  ^{
    :author "Roman Gonzalez"
  }

  (:refer-clojure :exclude
    [take take-while drop drop-while reduce first peek])

  (:require [clojure.core :as core])

  (:use river.core))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ## Utility Functions
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn- span [pred xs]
  ((core/juxt #(core/take-while pred %) #(core/drop-while pred %)) xs))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ## Consumers
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn take
  "Returns a seq of the first `n` elements in the stream, or all items if
  there are fewer than `n`. When `buffer` is given, the result is going
  to be concatenated to it."
  ([n0]
    (take [] n0))
  ([buffer0 n0]
    (letfn [
      (consumer [buffer n stream]
        (cond
          (eof? stream) (yield buffer eof)
          (empty-chunk? stream) (continue #((take buffer n) %))
          :else
            (let [taken-elems (concat buffer (core/take n stream))
                  new-size    (- n (count stream))]
              (if (> new-size 0)
                (continue #(consumer taken-elems new-size %))
                (yield taken-elems (core/drop n stream))))))
    ]
    #(consumer buffer0 n0 %))))

(defn take-while
  "Returns a seq of successive items from the stream while `(pred stream-item)`
  returns true. When `buffer` is given, the result is going to be concatenated
  to it."
  ([pred] (take-while [] pred))
  ([buffer0 pred]
    (letfn [
      (consumer [buffer stream]
        (cond
          (eof? stream) (yield buffer eof)
          (empty-chunk? stream) (continue #(consumer buffer %))
          :else
            (let [taken-elems (core/take-while pred stream)
                  remainder   (core/drop-while pred stream)
                  new-buffer  (concat buffer taken-elems)]
              (cond
                (empty? remainder)
                  (continue #(consumer new-buffer %))
                :else
                  (yield new-buffer remainder)))))
    ]
    #(consumer buffer0 %))))

(defn drop
  "Drops from the stream the first `n` elements."
  [n0]
  (letfn [
    (consumer [n stream]
      (cond
        (eof? stream) (yield nil stream)
        (empty-chunk? stream) (continue #(consumer n %))
        :else
          (let [new-n (- n (count stream))]
            (if (> new-n 0)
              (continue #(consumer new-n %))
              (yield nil (core/drop n stream))))))
  ]
  #(consumer n0 %)))

(defn drop-while
  "Drops elements from the stream until `(pred stream-item)` returns a falsy
  value."
  [pred]
  (fn consumer [stream]
    (cond
     (eof? stream) (yield nil eof)
     (empty-chunk? stream) (continue #(consumer %))
     :else
       (let [new-stream (core/drop-while pred stream)]
         (if (not (empty? new-stream))
           (yield nil new-stream)
           (continue #(consumer %)))))))

(defn consume
  "Consumes all the stream and returns it in a seq, when `buffer` is given,
  the result is going to bo concatenated to it."
  ([] (consume []))
  ([buffer]
    (take-while buffer (constantly true))))

(defn reduce
  "Consumes the stream item by item supplying each of them to the `f` function.
  `f` should receive two arguments, the accumulated result and the current
  element from the stream, if no `zero` is provided, then it will use the
  first element of the stream as the zero value for the accumulator."
  ([f]
    (fn consumer [stream]
      (cond
        (eof? stream) (yield nil eof)
        (empty-chunk? stream) (continue #(consumer %))
        :else
          ((reduce f (core/first stream)) (core/rest stream)))))
  ([f zero0]
    (letfn [
      (consumer [zero stream]
        (cond
          (eof? stream) (yield zero eof)
          (empty-chunk? stream) (continue #(consumer zero %))
          :else
            (let [new-zero (core/reduce f zero stream)]
              (continue #(consumer new-zero %)))))
    ]
    #(consumer zero0 %))))

(def first
  "Returns the first item from the stream, when stream has reached EOF this
  consumer will yield a nil value."
  (fn consumer [stream]
    (cond
      (eof? stream) (yield nil eof)
      (empty-chunk? stream) (continue consumer)
      :else
        (yield (core/first stream) (core/rest stream)))))

(def peek
  "Returns the first item in the stream without actually removing it, when the
  stream has reached EOF it will yield a nil value."
  (fn consumer [stream]
    (cond
      (eof? stream) (yield nil eof)
      (empty-chunk? stream) (continue consumer)
      :else
        (yield (core/first stream) stream))))

(defn zip
  "Multiplexes the stream into multiple consumers, each of the consumers
  will be feed with the stream that this consumer receives, this will return
  a list of consumer of yields/continuations."
  [& inner-consumers]
  (letfn [
    (consumer [inner-consumers stream]
      (cond
        (eof? stream)
        (yield (map (comp :result produce-eof) inner-consumers)
               stream)

        (empty-chunk? stream)
        (continue #(consumer inner-consumers %))

        :else
          (continue
            #(consumer (for [c inner-consumers]
                            (ensure-done c stream))
                       %))))]
  #(consumer inner-consumers %)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ## Producers
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defn produce-seq
  "Produces a stream from a seq, and feeds it to the given consumer,
  when `chunk-size` is given the seq will be streamed every `chunk-size`
  elements, it will stream 8 items per chunk by default when not given."
  ([a-seq] (produce-seq 8 a-seq))
  ([chunk-size a-seq0]
    (fn producer [consumer0]
      (loop [consumer consumer0
             a-seq    a-seq0]
        (cond
          (yield? consumer) consumer
          (continue? consumer)
          (let [[input remainder] (core/split-at chunk-size a-seq)
                next-consumer (consumer input)]
            (if (empty? remainder)
              (continue next-consumer)
              (recur next-consumer remainder))))))))

(defn produce-iterate
  "Produces an infinite stream by applying the `f` function on the zero value
  indefinitely. Each chunk is going to have `chunk-size` items, 8 by default."
  ([f zero]
    (produce-iterate 8 f zero))
  ([chunk-size f zero]
    (produce-seq chunk-size (core/iterate f zero))))

(defn produce-repeat
  "Produces an infinite stream that will have the value `elem` indefinitely.
  Each chunk is going to have `chunk-size` items, 8 by default."
  ([elem] (produce-repeat 8 elem))
  ([chunk-size elem]
    (produce-seq chunk-size (core/repeat elem))))

(defn produce-replicate
  "Produces a stream that will have the `elem` value `n` times. Each chunk is
  going to have `chunk-size` items, 8 by default."
  ([n elem] (produce-replicate 8 n elem))
  ([chunk-size n elem]
    (produce-seq chunk-size (core/replicate n elem))))

(defn produce-generate
  "Produces a stream with the `f` function, `f` will likely have side effects
  because it will return a new value each time. When the `f` function returns
  a falsy value, the function will stop producing values to the stream."
  [f]
  (fn producer [consumer]
    (if-let [result (f)]
      (if (continue? consumer)
        (recur (consumer [result]))
        consumer)
      consumer)))

(defn- unfold [f zero]
  (if-let [whole-result (f zero)]
    (let [[result new-zero] whole-result]
      (cons result (core/lazy-seq (unfold f new-zero))))
    []))

(defn produce-unfold
  "Produces a stream with the `f` function, `f` will be a function that
  receives an initial `zero` value, and it will return a tuple with a result
  and a \"new `zero`\", the result will be fed to the consumer. The stream
  will stop when the `f` function returns a falsy value. Each chunk is going
  to have `chunk-size` items, 8 by default."
  ([f zero] (produce-unfold 8 f zero))
  ([chunk-size f zero]
    (produce-seq chunk-size (unfold f zero))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; ## Filters
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defn mapcat*
  "Transform the stream by applying function `f` to each element in the stream.
  `f` will be a function that receives an item and will return a seq, the
  resulting seqs will be later concatenated and streamed to the consumer."
  [f]
  (letfn [
    (feed-inner-loop [inner-consumer [item & items :as stream]]
      (cond
      (empty-chunk? stream) [inner-consumer stream]
      (yield? inner-consumer) [inner-consumer stream]
      (continue? inner-consumer)
        (recur (inner-consumer (f item))
               items)))

    (outer-consumer [inner-consumer stream]
      (cond

      (yield? inner-consumer)
        (yield inner-consumer stream)

      (continue? inner-consumer)
        (cond

        (eof? stream)
          ;(yield (inner-consumer stream) stream)
          (yield inner-consumer stream)

        (empty-chunk? stream)
          (continue #(outer-consumer inner-consumer %))

        :else
          (let [[inner-consumer remainder] (feed-inner-loop inner-consumer
                                                            stream)]
            (recur inner-consumer remainder)))
      :else
        (throw
          (Exception.
            "mapcat*: invalid consumer (not yield nor continue)"))))]

  (fn to-outer-consumer [inner-consumer]
    (continue #(outer-consumer inner-consumer %)))))

(defn map*
  "Transform the stream by applying function `f` to each element in the stream.
  `f` will be a function that receives an item and return another of a
  (possibly) different type that later will be streamed to the consumer."
  [f]
  (fn to-outer-consumer [inner-consumer]
    ((mapcat* (comp vector f)) inner-consumer)))

(defn filter*
  "Removes elements from the stream by using the function `pred`. `pred` will
  receive an element from the stream and will return a boolean indicating if
  the element should be kept in the stream or not. The consumer will be
  feed with the elements of the stream in which `pred` returns true."
  [pred]
  (fn to-outer-consumer [inner-consumer]
    ((mapcat* (comp #(core/filter pred %) vector)) inner-consumer)))

(defn drop-while*
  "Works similarly to the `drop-while` consumer, it will drop elements from
  the stream until `pred` holds false, at that point the consumer will be feed
  with the receiving stream."
  [pred]
  (letfn [
    (outer-consumer [inner-consumer stream]
      (cond

        (yield? inner-consumer)
          (yield inner-consumer stream)

        (continue? inner-consumer)
          (cond
          (eof? stream)
            (yield (inner-consumer stream) stream)

          (empty-chunk? stream)
            (continue #(outer-consumer inner-consumer %))

          :else
            (let [new-stream (core/drop-while pred stream)]
               (if (not (empty-chunk? new-stream))
                 (yield (inner-consumer new-stream) [])
                 (continue #(outer-consumer inner-consumer %)))))
        :else
          (throw
            (Exception.
              "drop-while*: invalid consumer (not yield nor continue)"))))]

  (fn to-outer-consumer [inner-consumer]
    (continue #(outer-consumer inner-consumer %)))))

(defn isolate*
  "Prevents the consumer from receiving more stream than the specified in
  `n`, as soon as `n` elements had been feed, the filter will stream an `eof`
  to the consumer."
  [n]
  (letfn [
    (outer-consumer [total-count inner-consumer stream]
      (cond

      (yield? inner-consumer)
        (yield inner-consumer stream)

      (continue? inner-consumer)
        (cond

        (eof? stream)
          (yield inner-consumer eof)

        (empty-chunk? stream)
          (continue #(outer-consumer total-count
                                     inner-consumer
                                     %))
        :else
          (let [stream-count (count stream)
                total-count1 (- total-count stream-count)]

            (if (> stream-count total-count)
              (yield (inner-consumer (core/take total-count stream))
                     (core/drop total-count stream))

              (continue #(outer-consumer total-count1
                                         (inner-consumer stream)
                                         %)))))
      :else
        (throw
          (Exception.
            "isolate*: invalid consumer (not yield nor continue)"))))]

  (fn to-outer-consumer [consumer]
    (continue #(outer-consumer n consumer %)))))

(defn require*
  "Throws an exception if there is not at least `n` elements streamed to
  the consumer."
  [n]
  (letfn [
    (outer-consumer [total-count inner-consumer stream]
      (cond

      (yield? inner-consumer)
        (yield inner-consumer stream)

      (continue? inner-consumer)
        (cond

        (eof? stream)
          (if (> total-count 0)
            (throw (Exception. "require*: minimum count wasn't satisifed"))
            (yield inner-consumer stream))

        (empty-chunk? stream)
          (continue #(outer-consumer total-count
                                     inner-consumer
                                     %))

        :else
          (let [total-count1 (- total-count (count stream))]
            (if (<= total-count 0)
              (yield (inner-consumer stream) [])
              (continue #(outer-consumer total-count1
                                         (inner-consumer stream)
                                         %)))))
      :else
        (throw
          (Exception.
            "require*: invalid consumer (not yield nor continue)"))))]

  (fn to-outer-consumer [inner-consumer]
    (continue #(outer-consumer n inner-consumer %)))))

(defn stream-while*
  "Streams elements to the consumer until the `f` function returns a falsy
  for item in the stream."
  [f]
  (letfn [
    (outer-consumer [inner-consumer stream]
      (cond
      (yield? inner-consumer)
        (yield inner-consumer stream)

      (continue? inner-consumer)
        (cond
        (eof? stream)
        (yield (inner-consumer stream) stream)

        (empty-chunk? stream)
        (continue #(outer-consumer inner-consumer %))

        :else
        (let [[to-feed to-drop] (span f stream)]
          (if (empty? to-drop)
            (continue #(outer-consumer (inner-consumer to-feed) %))
            (yield (inner-consumer to-feed) to-drop))))
      :else
        (throw
          (Exception.
            "stream-while*: invalid consumer (not yield nor continue)"))))]

  (fn to-outer-consumer [inner-consumer]
    (continue #(outer-consumer inner-consumer %)))))

(defn- split-when-consumer [f]
  (do-consumer
    [first-chunks (take-while (complement f))
     last-chunk   (take 1)]
     (if (nil? last-chunk)
       first-chunks
       (concat first-chunks last-chunk))))

(defn split-when* [f]
  "Splits on stream elements satisfiying the given `f` function, the consumer
  will receive a stream of chunks of seqs."
  (to-filter (split-when-consumer f)))

