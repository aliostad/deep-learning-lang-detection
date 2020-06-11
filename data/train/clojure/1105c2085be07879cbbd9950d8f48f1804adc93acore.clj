(ns play.onyx-stream.core
  (:require [play.onyx-stream.fixed-windows :as fw]
            [play.onyx-stream.sliding-windows :as slw]
            [play.onyx-stream.global-windows :as gw]
            [play.onyx-stream.session-windows :as ssw]
            [play.onyx-stream.twitter.fixed-windows :as twitterfw]
            [play.onyx-stream.twitter.global-windows :as twittergw]
            [play.onyx-stream.twitter.sliding-windows :as twitterslw]
            [play.onyx-stream.twitter.session-windows :as twitterssw]
            [play.onyx-stream.twitter.chain-windows :as twitterchw]))

(defn -main
  "Executes window samples"
  [& args]
  (condp = (first args)
    "fw" (fw/execute-flow {})
    "slw" (slw/execute-flow {})
    "gw" (gw/execute-flow {})
    "ssw" (ssw/execute-flow {})
    "twitter-fw" (twitterfw/execute-flow {})
    "twitter-slw" (twitterslw/execute-flow {})
    "twitter-gw" (twittergw/execute-flow {})
    "twitter-ssw" (twitterssw/execute-flow {})
    "twitter-chain" (twitterchw/execute-flow {})
    (println "Usage: lein run <fw|slw|gw|ssw|twitter-fw|twitter-slw|twitter-gw|twitter-ssw|twitter-chain>")))
