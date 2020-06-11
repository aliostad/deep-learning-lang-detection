(ns respondent.repl)

(comment
  ;;
  ;; Event stream REPL examples
  ;;


  ;;
  ;; deliver & map
  ;;
  (def es1 (event-stream))

  (deliver es1 10)
  ;; "first event stream emitted: " 10


  (def es2 (map es1 #(* 2 %)))
  (subscribe es2 #(prn "second event stream emitted: " %))
  (deliver es1 20)
  ;; "first event stream emitted: " 20
  ;; "second event stream emitted: " 40


  ;;
  ;; filter
  ;;
  (def es1 (event-stream))
  (def es2 (filter es1 even?))
  (subscribe es1 #(prn "first event stream emitted: " %))
  (subscribe es2 #(prn "second event stream emitted: " %))

  (deliver es1 2)
  (deliver es1 3)
  (deliver es1 4)

  ;; "first event stream emitted: " 2
  ;; "second event stream emitted: " 2
  ;; "first event stream emitted: " 3
  ;; "first event stream emitted: " 4
  ;; "second event stream emitted: " 4


  ;;
  ;; flatmap
  ;;
  (defn range-es [n]
    (let [es (event-stream (chan n))]
      (doseq [n (range n)]
        (deliver es n))
      es))

  (def es1 (event-stream))
  (def es2 (flatmap es1 range-es))
  (subscribe es1 #(prn "first event stream emitted: " %))
  (subscribe es2 #(prn "second event stream emitted: " %))

  (deliver es1 2)
  ;; "first event stream emitted: " 2
  ;; "second event stream emitted: " 0
  ;; "second event stream emitted: " 1

  (deliver es1 3)
  ;; "first event stream emitted: " 3
  ;; "second event stream emitted: " 0
  ;; "second event stream emitted: " 1
  ;; "second event stream emitted: " 2




  ;;
  ;; behavior REPL examples
  ;;

  ;;
  ;; from-interval
  ;;
  (def es1 (from-interval 500))
  (def es1-token (subscribe es1 #(prn "Got: " %)))
  ;; "Got: " 0
  ;; "Got: " 1
  ;; "Got: " 2
  ;; "Got: " 3
  (dispose es1-token)

  ;;
  ;; deref
  ;;
  (def time-behavior (behavior (System/nanoTime)))

  @time-behavior
  ;; 201003153977194

  @time-behavior
  ;; 201005133457949

  ;;
  ;; sample
  ;;
  (def time-stream (sample time-behavior 1500))
  (def token       (subscribe time-stream #(prn "Time is " %)))
  ;; "Time is " 201668521217402
  ;; "Time is " 201670030219351
  ;; ...

  (dispose token)
  )
