(ns banach.pagination
  (:require [manifold.stream :as ms]
            [manifold.deferred :as md]))

(defn paginated->stream
  "Turn a paginated collection into a stream.

  `handle-todo` should take a todo item (like a URL) and return a deferred
  that will fire with the result of fetching that information (e.g. by making
  an HTTP request). `get-results` is passed that value from `handle-todo`, and
  should return the results in that value. These will be added to the output
  stream. `get-next-todo` should return the next todo or nil if this is the
  last page. `first-todo` is the first todo item to kick this process off."
  [handle-todo first-todo get-next-todo get-results]
  (let [todo-stream (ms/stream 10)
        rsrc-stream (ms/stream 20)]
    (ms/put! todo-stream first-todo)
    (ms/connect-via
     todo-stream
     (fn [todo]
       (md/chain (handle-todo todo)
                 (fn [response]
                   (if-some [next-todo (get-next-todo response)]
                     (ms/put! todo-stream next-todo)
                     (ms/close! todo-stream))
                   (when-let [rs (get-results response)]
                     (ms/put-all! rsrc-stream rs)))))
     rsrc-stream)
    rsrc-stream))
