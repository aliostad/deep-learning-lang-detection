(ns bitcloj.requester
  (:require [org.httpkit.client :as http]))


; (def response1 (http/get "http://tracker.openbittorrent.com:80"))
(def response (http/get "http://tracker.openbittorrent.com:80/announce13"))

(identity response)
; (print @response)

; (defn decode [stream & i]
;   (let [indicator (if (nil? i) (.read stream) (first i))]
;     (cond
;      (and (>= indicator 48)
;           (<= indicator 57)) (decode-string stream indicator)
;           (= (char indicator) \i) (decode-number stream \e)
;           (= (char indicator) \l) (decode-list stream)
;           (= (char indicator) \d) (decode-map stream))))








