(ns hackedio.core
  (:use [clojure.pprint :only [pprint]]
        [overtone.live]
        [overtone.inst.piano]
        [overtone.inst.synth]
        [overtone.inst.sampled-piano :only [sampled-piano]])
  (:require [hackedio.sowhat :as sowhat]))

(def nome (metronome 125))
(def kick (sample (freesound-path 2086)))
(def rimshot (sample (freesound-path 132418)))
(def base-note (atom 0))

(defn next-measure
  "Given a metronome, tells you when the next measure will begin."
  ([metro]
     (next-measure metro 4))
  ([metro beats-per-measure]
     (* beats-per-measure
        (inc (quot (metro)
                   beats-per-measure)))))
(defn play-thing
  [metro instrument bar n offset & notes]
  (at (nome (+ (next-measure nome)
               (* 4 bar)
               (dec n)
               offset
               ))
      (doseq [n notes]
        (instrument (+ @base-note (note n))))))

(defn play-track
  [track-atom]
  (if-let [track @track-atom]
    (let [{:keys [name man phrase]} track]
      (doseq [n phrase]
        (apply play-thing nome man n)))))

(def track1 (atom nil))
(def track2 (atom nil))

(reset! track1 sowhat/section-a-phrase-1)
(reset! track1 sowhat/section-a-phrase-2)
(reset! track1 sowhat/section-a-phrase-3)
(reset! track1 sowhat/section-b-phrase-1)
(reset! track1 sowhat/section-b-phrase-2)
(reset! track1 sowhat/section-b-phrase-3)

(defn change-phrase
  [track-ref f]
  (swap! track-ref update-in [:phrase] f))

(reset! track2 sowhat/soloist)

(defn random-from
  [coll]
  (nth coll (rand-int (count coll))))

(defn random-a [] (random-from [:d4 :e4 :f4 :g4 :a4 :b4 :c5]))
(defn random-b [] (random-from [:d#4 :f4 :f#4 :g#4 :a#4 :c5 :c#5]))

(defmacro idea
  [name & body]
  `(do
     (swap! track2
            update-in
            [:phrase]
            (fn [~'phrase]
              ~@body))
     (pprint (:phrase @track2))
     :ok
     ))

(idea take-3 (take 3 phrase))
(idea take-7 (take 7 phrase))
(idea drop-2 (drop 2 phrase))
(idea reset (:phrase sowhat/soloist))

(idea random-a (map (fn [[m b o & rest]] [m b o (random-a)]) phrase))
(idea random-b (map (fn [[m b o & rest]] [m b o (random-b)]) phrase))
(idea random-subset (map (fn [[m b o & rest]]
                           [m b o (random-from (map #(nth % 3) phrase))])
                         phrase))

(idea drop-some (filter (fn [_] (even? (rand-int 2)))
              phrase))


(interspaced (beat-ms 8 (metro-bpm nome)) (partial play-track track1))
(interspaced (beat-ms 8 (metro-bpm nome)) (partial play-track track2))

(stop)
