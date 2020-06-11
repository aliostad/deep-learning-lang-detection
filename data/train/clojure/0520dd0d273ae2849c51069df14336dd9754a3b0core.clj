(ns rolling-your-own-queue-ch9.core
  (:gen-class))

(defmacro wait
  "Sleep `timeout` seconds before evaluating body"
  [timeout & body]
  `(do (Thread/sleep ~timeout) ~@body))

;; the code below splits up tasks into a concurrent portion and a serialized portion:
(time  (let [saying3 (promise)]
         (future (deliver saying3 (wait 100 "Cheerio!!!")))
         @(let [saying2 (promise)]
            (future (deliver saying2 (wait 400 "Pip pip!!!")))
            @(let [saying1 (promise)]
               (future (deliver saying1 (wait 200 "'Ello, gov'na!!")))
               (println @saying1)
               saying1)
            (println @saying2)
            saying2)
         (println @saying3)
         saying3))

;; use @ to dereference the let (future, which create another line, leave a reference for the result)
;; it might seem silly to dereference the let block, but doing so lets you abstract this code with a macro.
;; if not, the function will be like below:


(defmacro enqueue
  ([q concurrent-promise-name concurrent serialized]
   `(let [~concurrent-promise-name (promise)]
      (future (deliver ~concurrent-promise-name ~concurrent))
      (deref ~q)
      ~serialized
      ~concurrent-promise-name))
  ([concurrent-promise-name concurrent serialized]
   `(enqueue (future) ~concurrent-promise-name ~concurrent ~serialized)))

(time @(-> (enqueue saying (wait 200 "'Ello, gov'na") (println @saying))
          (enqueue saying (wait 400 "Pip pip!!!") (println @saying))
          (enqueue saying (wait 100 "Cheerio!") (println @saying))))

;; concurrency refers to a program's ability to carry out more than one task, 
;; and in Clojure you achieve this by placeing tasks on separate threads.

;; concurrency programming refers to the techniques used to manage three concurrency risks:
;; reference cells, mutual exclusion, and deadlock
;; Clojure gives you three basic tools that help you mitigate those risks:
;; futures delays and promise
;; each tool lets you decouple the three events of 
;; 1 => defining a task, 2 => executing a task, 3 => requiring a task's result

;; Future 
;;  let you define a task and execute it immediately, allowing you to require the result later or never. Futures also cache their results.

;; Delay
;;  Delays let you define a task that doesn’t get executed until later, and a delay’s result gets cached

;; Promise
;;  Promises let you express that you require a result without having to know about the task that produces that result. 
;;  You can only deliver a value to a promise once.
