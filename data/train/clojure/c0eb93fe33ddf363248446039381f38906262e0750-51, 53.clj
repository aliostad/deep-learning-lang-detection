(ns sicp-clj.ch3.hd
    (:use [clojure.contrib.math :only []])
    (:use [clojure.contrib.generic.math-functions :only []]))

; 3-50
; Stream이라는 걸 다루기 시작했다. 클로저에 비슷한게 있는 것 같긴 한데 여러 함수들이 일대일 매칭이 잘 안된다. 웅철이에게 물어봐야겠다.

(defn stream-map [proc . argstreams]
    (if (steam-null? (car argstreams))
        the-empty-stream
        (cons-stream
            (apply proc
                (map stream-car argstreams))
            (apply stream-map
                (cons proc
                    (map stream-cdr argstreams))))))

; 3-51
; 처음 정의될 때 0이 나오고, (stream-ref x 5)에서 1 2 3 4 5 나오고, (stream-ref x 7)에서 6 7이 나올 것이다.

; 3-52 -> 돌려봐야 하는데 돌릴수가 없다..

; 3-53
; s는 1부터 시작해서 계속 앞에것을 2배씩 한 것. 즉 2의 n승 (n=0, 1, 2, ...) 의 리스트이다.
