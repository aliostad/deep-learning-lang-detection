(ns instrument.decorators
  (:require [delaunay.div-conq :as dq]
            [edge-algebra.state.app-mutators
             :refer [wrap-with-undo
                     wrap-with-add-circle
                     wrap-with-clear-circles
                     wrap-with-add-message
                     replace-with-add-message
                     wrap-with-name-and-args-reporting
                     wrap-with-clear-messages
                     reset-state!]]))


(defn decorate
  [f]
  (fn [& args]
    (with-redefs [edge-algebra.core/splice! (wrap-with-name-and-args-reporting
                                             edge-algebra.core/splice!)
                  dq/make-d-edge! (wrap-with-clear-messages
                                   (wrap-with-clear-circles
                                    (wrap-with-undo
                                     (wrap-with-name-and-args-reporting
                                      dq/make-d-edge!))))
                  dq/delete-edge! (wrap-with-clear-messages
                                   (wrap-with-clear-circles
                                    (wrap-with-undo
                                     (wrap-with-name-and-args-reporting
                                      dq/delete-edge!))))
                  dq/in-circle? (wrap-with-add-circle
                                 (wrap-with-name-and-args-reporting
                                  dq/in-circle?))
                  println (replace-with-add-message
                           println)]
      (apply f args))))
