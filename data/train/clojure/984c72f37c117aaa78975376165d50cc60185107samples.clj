(ns chapter-3.samples)

; atom
(def who-atom (atom :caterpillar))

@who-atom
;=> :caterpillar

(reset! who-atom :chrysalis)
@who-atom
;=> :chrysalis

;swap! --> change atom value for by the return value of function
(defn change [state]
  (case state
    :caterpillar :chrysalis
    :defalut))

(swap! who-atom change)
; => :chrysalis

; -- for the sideeffect
; dotimes
; Repeatedly executes body (presumably for side-effects) with name
; bound to integers from 0 through n-1.
(def counter (atom 0))
(dotimes [_ 5] (swap! counter inc))
@counter

(defn inc-print
  [val]
  (println val)
  (inc val))

; future -- multithread
; creat 3 thread for change the counter values
; --> the value is changed atomical
(let [n 10]
  (future (dotimes [_ n] (swap! counter inc-print)))
  (future (dotimes [_ n] (swap! counter inc-print)))
  (future (dotimes [_ n] (swap! counter inc-print)))
  )

; --> なんか不思議な動き
; 読み出し時に待ち合わせしている
; and they clould be retries.
;32
;333333
;
;34
;
;35
;353636
;
;37


; refs --- Software Transactional Memory, STM.
; Atomic update , Consistent, Isolated

(def alice-height (ref 3))
(def right-hand-bites (ref 10))
@alice-height
@right-hand-bites

(defn eat-from-right-hand []
  (when (pos? @right-hand-bites)
    (alter right-hand-bites dec)
    (alter alice-height #(+ % 24))))

(eat-from-right-hand)
; CompilerException java.lang.IllegalStateException: No transaction running
; needing STM for alter

with dosync
(dosync (eat-from-right-hand))
; => 27

; pos? -> positive?
(defn eat-from-right-hand-sync []
  (dosync (when (pos? @right-hand-bites)
    (alter right-hand-bites dec)
    (alter alice-height #(+ % 24)))))

; the function of the swap! and alter must be side effect-free, cos they cloud be retries.

; transactional changes
(let [n 3]
  (future (dotimes [_ n] (eat-from-right-hand-sync)))
  (future (dotimes [_ n] (eat-from-right-hand-sync)))
  (future (dotimes [_ n] (eat-from-right-hand-sync))))
@alice-height
; => 219
@right-hand-bites
; => 1


; Agent -- Manage Changes on their own
(def who-agent (agent :caterpillar))


(defn chnage [state]
  (case state
    :caterpillar :chysalis
    :chysalis :butterfly
    :butterfly :deadbody))

(send who-agent change)
@who-agent

; atom and swap! ... change the value synchronously
; agent and send ... asynchoronously! -> the value is different, depends on the timing

; send off ... expandable thread pool. using I/O brocking actions.
; (not using same thread pool as main thread? )
(send-off who-agent change)


; if an error occerred...
(defn change-error [state]
  (throw (Exception. "Error!!")))

(send who-agent change-error)
; => #'chapter-3.samples/who-agent

(send who-agent change)
; CompilerException java.lang.RuntimeException: Agent is failed, needs restart, compiling:(/Users/a14059/src/studing_living_clojure/src/chapter_3/samples.clj:1:27)

; we can check the agetnt errors with agent-errors
(agent-errors who-agent)

; if restet agent, we can use the agent again
(restart-agent who-agent :chatapiller)

; handling error
(set-error-mode! who-agent :continue)
(set-error-handler! who-agent (fn [a ex]
                                (println "error " ex " value is @a")))
; => #<Agent@140d2a64: :chatapiller>
;    error  #<Exception java.lang.Exception: Error!!>  value is @a

; atom  -> それぞれの変数に個別のトランザクション
; refs  -> 変数全体でトランザクション
; agent -> 非同期実行

