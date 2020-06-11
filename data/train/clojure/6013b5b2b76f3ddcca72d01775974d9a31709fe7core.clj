(ns AncapMarkov.core
  (:gen-class)
  (:use
    [twitter.oauth]
    ;[twitter.callbacks]
    ;[twitter.callbacks.handlers]
    [twitter.request]
    [twitter.api.restful])
  (:require [clojure.java.io :as io]
            [clojure.set]
            [overtone.at-at :as at-at]
            [environ.core :refer [env]]))

(def possible-starts ["you" "the" "all"]) ;each meme starts with "When", so that's the first word following it
(def creds (make-oauth-creds (env :app-consumer-key)
                             (env :app-consumer-secret)
                             (env :user-access-token)
                             (env :user-access-secret)))

;TODO: merge word-paser & file2words?
;TODO: find a better way than "EOL" to manage newlines
(defn word-parser [words]
  (reduce (fn [r t] ; r is what we're filling, and t is what we use to fill
    (merge-with clojure.set/union r
      (let [[a b] t] ; first & second word of partition
        ;(println "a:"a" b:"b)
        (if (not (= a "-EOL"))
          (if (= b "-EOL")
            {(keyword a) #{}}
            {(keyword a) #{b}})))))
        ;we create a map which associates #{b} to the a key if b exists, else we give it an empty value
  {} words))

(defn file2words [file]
  (word-parser (partition-all 2 1 (clojure.string/split file #" "))))

;TODO: better trim system
;maybe rewrite make-chain so it counts characters?
;merging both functions would be great
;TODO: isn't the next TODO already fixed?
;TODO: fix the broken re-pattern (endless loop which can (?!) lead to REPL crash)
(defn trim-chain [chain]
  (let [words (clojure.string/split (str chain) #" ")]
    (if (< (count chain) 116) ;116 = 140 - image limit
    ;(if (< (count chain) 140)
      chain
      (recur (clojure.string/replace chain (re-pattern (str (last words)"$")) "")))))

;TODO: add percents
(defn make-chain [start wordlist result]
  (let [next-words (get wordlist (keyword start))]
    ;(println "start:" start " state:"(empty? next-words) " n-words:" next-words)
    (if (or (empty? next-words) (> (count result) 116))
    ;(if (or (empty? next-words) (> (count result) 140))
      result
      (let [next-word (first (shuffle next-words))
            new-start next-word]
        (recur new-start wordlist (str result " " next-word))))))

(defn gen-text []
  (let [first-word (get possible-starts (rand-int (count possible-starts)))
        made-chain (str "When "(make-chain first-word (file2words (slurp (io/resource "memes.txt"))) first-word))]
    (if (> (count made-chain) 116)
    ;(if (> (count made-chain) 140)
      (recur)
      made-chain)))

;TODO: every while-or-so, complains about "Remotely Closed", wtf is that?
;TODO: configure log4j to avoid shitty warnings
(defn tweet-text [text]
  (try (statuses-update-with-media :oauth-creds creds
                                    :body [(file-body-part "meme.jpg")
                                           (status-body-part text)])
       (catch Exception e (println "Error: " (.getMessage e)))))

(def at-pool (at-at/mk-pool))

(defn -main []
  (at-at/every (* 1000 60 15) #(tweet-text (gen-text)) at-pool))
