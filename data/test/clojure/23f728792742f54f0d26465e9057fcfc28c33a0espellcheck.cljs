(ns project-factual.editor.spellcheck
  (:require [clojure.string :as string]))

(defonce typo (js/require "typo-js"))

(defonce spellcheck
         (typo. "en_GB" false false #js{:dictionaryPath "./dict"}))
(defonce word-seperators "'!'\\\"#$%&()*+,-./:);<=>?@[\\\\]^_`{|}~ '")
(defonce number-regex #"[0-9]+")

(defn advance-to-next-word-seperator [stream word seperators]
  "WARNING: SIDE EFFECTS, advances stream to the next seperator"
  (let [ch (.peek stream)]
    (if (and (not (nil? ch))
             (not (string/includes? seperators ch)))
      (do (.next stream)
          (recur stream (str word ch) seperators))
      word)))

(defn spellcheck-tokeniser [stream]
  (let [ch (.peek stream)]
    (if (string/includes? word-seperators ch)
      (do (.next stream)
          nil)
      (let [word (advance-to-next-word-seperator stream "" word-seperators)]
        (if (or (.check spellcheck word)
                (re-matches number-regex word)) ; Is a number
          nil
          "spell-error")))))

(def spellcheck-overlay #js{"token" spellcheck-tokeniser})