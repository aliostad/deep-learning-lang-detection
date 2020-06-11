(ns budget.charts
  (:use budget.constants
        budget.manage-redis
        [clj-time core format local]))

(defn comma-separate [l]
  (if 
    (coll? l)
    (str 
     "["
     (reduce 
      #(str % ", " (comma-separate %2))
      (comma-separate (first l))
      (rest l))
     "]")
    l))

(defn days-since-first [time-obj]
  (float (inc (/ (in-secs (interval 
          (first-of-the-month time-obj)
          time-obj))
     (* 60 60 24)))))



(defn plot-budget-left [transactions total f]
    (loop [trans transactions
       curr (. Integer parseInt total)
       retval [[(days-since-first (local-now)) (f (days-since-first (local-now)) (. Integer parseInt total))]]]
       (if (= 1 (count trans))
        retval
         (let [t (first trans)
               curr-total (+ curr (. Integer parseInt (:amount t)))]
           (recur (rest trans) 
				  curr-total
                  (let [x (days-since-first 
                            (parse 
                             (formatters :date-hour-minute-second)
                             (:time t)))]
                    (conj retval (vector x (f x curr-total)))))))))

(defn plot-total-spent [transactions total f]
  	(loop [trans (reverse transactions)
           spent 0
           retval [[0 (f 0 0)]]]
      (if (empty? trans)
        retval
        (let [t (first trans)
              amount (max 0 (. Integer parseInt (:amount (first trans))))
              day (days-since-first (parse (formatters :date-hour-minute-second) (:time (first trans))))]
          (recur 
           (rest trans)
           (+ spent amount)
           (conj retval 
               [day (f day (+ spent amount))]))))))


;(render-chart "test" trans "8000" plot-total-spent (fn[x y] y))

(def chart-options 
  "{
    xaxis: {tickDecimals: 0, autoscaleMargin: 20},
    yaxis: {tickDecimals: 0}
   }") 

(defn render-chart [chart-name transactions total data-parser & functions]
  [:div
    [:h6.center chart-name]
    [:div.chart {:id chart-name}]
    [:script {:type "text/javascript"} 
    	(str "Flotr.draw(document.getElementById('" chart-name "'),"
		  (comma-separate
            (map #(data-parser transactions total %) functions))
          ","
	      chart-options
          ");")]])
