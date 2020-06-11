(ns whats-my-salary.core)

;;; A calculator to show how much money you will take home given a
;;; specified

;;; Define your standard allowances
;;; values taken from http://www.hmrc.gov.uk/rates/it.htm
;;; and http://www.hmrc.gov.uk/rates/nic.htm

;; Should refactor data into few small maps by related context
;; Eventually create a one map to manage all the data

(def weeks-in-a-year 52)

(def personal-earnings-allowance 8105.0)

(def personal-allowance-income-limit 100000)

(def tax-rate-basic-level-max 34370)
(def tax-rate-basic-percent 20.0)
(def tax-rate-higher-level-max 150000)
(def tax-rate-higher-percent 40.0)

(def national-insurance-employed-minimum-weekly-salary 142.0)
(def national-insurance-employed-maximum-weekly-salary 817.0)
(def national-insurance-percentage 12.0)
   ; Use decimal number to prevent lazy evaluation on all percentage
   ; figures due to the way we calculate percentage


;;; experimental code

(defn earns-within-basic-tax-rate [monies]
  (- (* monies (/ tax-rate-basic-percent 100.0))) monies )

;;; End of experimental code


(defn whats-my-tax-bands [gross-salary]
  "Which taxation bands do I incur due to salary.  If below the personal tax allowance, then only NI.  If below 37k then only 20%.  If more then everything over 38k earnt taxed at 40%"
  (if (> gross-salary tax-rate-basic-level-max )
    (println "You are a fat "))
  )

;; Refactor to combine similar functions,
;; either using paramter overloading or let statements

(defn national-insurance-rate-employed-minimum [monies]
  (* national-insurance-employed-minimum-weekly-salary weeks-in-a-year))

(defn national-insurance-rate-employed-maximum [monies]
  (* national-insurance-employed-maximum-weekly-salary weeks-in-a-year))


(defn taxable-salary [my-salary]
  (- my-salary personal-earnings-allowance))

(defn national-insurance-due [monies]
  (* (taxable-salary monies) (/ national-insurance-percentage 100)))


(defn income-tax-due [monies]
  (* (taxable-salary monies) (/ tax-rate-basic-percent 100)))


(defn whats-my-yearly-takehome [salary]
  (- salary (income-tax-due salary) (national-insurance-due salary)))

(defn whats-my-monthly-takehome [monies]
  (/ (whats-my-yearly-takehome monies) 12.0))


(whats-my-yearly-takehome 28000)
(whats-my-monthly-takehome 28000)

(whats-my-yearly-takehome 85000)



;;; Main only used for Uber jar - a bit pointless otherwise it would seem

(defn -main
  "I don't do a whole lot.  Used to call the code from the Uberjar on the command line"
  [& args]
  (println "Hello, World!")
  (whats-my-yearly-takehome 28000)
  )
