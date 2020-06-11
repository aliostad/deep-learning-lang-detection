(ns sicp-clj.ch3.hd
    (:use [clojure.contrib.math :only []])
    (:use [clojure.contrib.generic.math-functions :only []]))

; 3-59-a
; a0, a1, a2, ... 의 수열에 1, 1/2, 1/3, 1/4, ... 을 mul-stream한 다음 맨 앞에 c를 붙이면 된다.
; 아, 그냥 div-stream처럼 만들면 되겠군.
(defn integers-starting-from [n]
    (cons-stream n (integers-starting-from (inc n))))

(def integers
    (integers-starting-from 1))

(defn integrate-series [power-series-stream]
    (stream-map / power-series-stream integers))

; 3-59-b
; sin과 cos는 서로 반복된다.
; 음수를 곱하는 게 반복되는 수열을 이용하면 되겠다.
; 음.. 그런데 b에서 쓰이는 걸 보니 integerate-series에서 임의의 c를 붙이라는 게 아니라, 그걸 사용할 때 붙이라는 거였군. 바꿨다.
(defn negative-stream [st]
    (stream-map (fn [x] (- x)) st))

(def cosine-series
    (cons-stream 1 (negative-stream (integrate-series sine-series))))

(def sine-series
    (cons-stream 0 (negative-stream (integrate-series cosine-series))))
