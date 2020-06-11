(set! *warn-on-reflection* true)

(ns cloanda.helper
    (:require [cloanda.core :as apicore]))




;; collection of helper functions
(defn get-history-of-instruments [ oa insts gran cnt]
  "oa -> oanda api ; insts -> instrumets ; gran -> granularity ; count-> history count"
  (loop [ inst insts r {}]
    (let [
          current-inst (first inst)
          pcs-resp (.get-instrument-history oa current-inst {"granularity" gran "count" (str cnt)})
          ]
      (if (nil? current-inst)
        r
        (recur (next inst) (assoc r current-inst pcs-resp  ))))
  ))


(defmacro http-body-form [ f h ]
  {:as :json :body f :headers h :content-type :json :throw-exceptions false})

(defmacro http-normal [ h ]
  {:as :json :headers h :content-type :json :throw-exceptions false})



(defmacro tt
  ([ h ]
   {:as :json :headers h :content-type :json :throw-exceptions false})
  ([ f h ]
    (list assoc (tt  h) :body f)
   ))



(tt "dadf")


(tt "dadf" "dafdbbbb")
