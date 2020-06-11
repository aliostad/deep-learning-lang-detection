(ns email-tool.parse
  (:require [clojure.string :as str]
            [clojure.spec :as s]
            [clojure.spec.test :as stest]))

(s/fdef to-regex
        :args :email-tool.parts/parts
        :ret :email-tool.specs/regex)
(defn- to-regex [token-types] (->> token-types
                                   (map :regex)
                                   (str/join "|")
                                   re-pattern)) 

(s/fdef obtain-info
        :args (s/cat :parts :email-tool.parts/parts
                     :emmap map?
                     :text-chunk string?)
        :ret map?)
(defn- obtain-info [parts emmap text-chunk]
  (some (fn [{:keys [regex result-handler conflict-fn]
              :or {conflict-fn (fn [a b] b)}}]
          (if-let [matched (re-matches regex text-chunk)]
             (let [info (result-handler parts matched)]
               (merge-with conflict-fn emmap info))))
        parts))

#_(stest/instrument `obtain-info)

(s/fdef parse
        :args (s/cat :mail string?
                     :parts :email-tool.parts/parts)
        :ret map?)

(defn parse
  [string parts] 
  (let [text-chunks (->> (re-seq (to-regex parts) string)
                         (map #(if (seq? %) (first %) %)))
        emmap (reduce (partial obtain-info parts)
                      {}
                      text-chunks)]
    emmap
    ))
#_(stest/instrument `parse)
