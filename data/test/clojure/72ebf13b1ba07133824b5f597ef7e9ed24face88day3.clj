; Tyler Palsulich
; Seven Languages in Seven Weeks, by Bruce A. Tate
; Clojure day 3

; 1) Use refs to create a vector of accounts in memory. Create debit
; and credit functions to change the balance of an account.

; 2) In this section, I’m going to outline a single problem called sleeping
; barber. It was created by Edsger Dijkstra in 1965. It has these charac-
; teristics:
; • A barber shop takes customers.
; • Customers arrive at random intervals, from ten to thirty millisec-
; onds.
; • The barber shop has three chairs in the waiting room.
; • The barber shop has one barber and one barber chair.
; • When the barber’s chair is empty, a customer sits in the chair,
; wakes up the barber, and gets a haircut.
; • If the chairs are occupied, all new customers will turn away.
; • Haircuts take twenty milliseconds.
; • After a customer receives a haircut, he gets up and leaves.
; Write a multithreaded program to determine how many haircuts a bar-
; ber can give in ten seconds.

(ns clojure-lisp.day3
  (:gen-class))

(def accounts (ref []))         ; Vector of accounts.
 
(defn open-account [init]
  "Add a new account to our vector with starting value [init]."
	(dosync 
		(alter accounts conj init))); Alter a ref inside (dosync). Alter a ref directly with alter.

(defn debit [account ammount]
  "Remove [amount] from [account]. [account] is the index in accounts."
	(dosync 
    ; Uses a macro to define an anonymous function to subtract [amount] from the proper [account].
    ; `#` starts the macro and %1 is the second argument to the function.
		(alter accounts 
      #(assoc %1 account (- (get %1 account) ammount)))))
(defn credit [account ammount] 
  "Add [amount] to [account]. [account] is the index in accounts."
	(dosync 
		(alter accounts 
      ; Similar to debt. Uses an anonymous function (macro) to add [amount] to the [account].
      #(assoc %1 account (+ ammount (get %1 account))))))
 

(def customers-waiting (atom 0))    ; Customers that will fill up the chairs.
(def chairs 3)                      ; Number of possible waiting customers.
(def num-haircuts (atom 0))         ; Will increment every time we cut someone's hair.
 
(def open? (atom true))             ; New customers come in and the barber cuts hair until no longer open.
 
(defn open-shop [seconds]
  "[seconds] Manage the state of the barbershop. Opens, stays open for [seconds], then closes the shop."
  (future
      (println "Barber is open for business for" seconds "seconds!")
      (Thread/sleep (* 1000 seconds))   ; * 1000 since sleep takes miliseconds.
      (swap! open? not)                 ; We slept for long enough, close shop.
      (println "We're now closed")))
 
(defn make-customers []
  "[] Generate people who enter the barbershop."
  (future
    (while @open?                       ; Only make-customers when the shop is open for business.
      (if (< @customers-waiting chairs) ; Don't bring too many customers in.
        (do                             ; To make a list of code snippets to run.
           (swap! customers-waiting inc)  ; Increment number of customers waiting to get a haircut.
           (Thread/sleep (+ 10 (rand-int 20))))))))   ; Customers come in every 10-30 ms.
 
(defn cut-some-hair []
  "[] Every 20 ms, 'cut' a customer's hair."
  (future
    (while @open?
      (if (> @customers-waiting 0 )     ; Need customers to cut a customer's hair!
        (do
          (swap! customers-waiting  dec); Decrement number of waiting customers,
          (swap! num-haircuts inc)      ; and increment the number of haircuts we've given.
          (Thread/sleep 20))))))        ; Simulate the time it takes to cut a customer's hair.

 (defn -main []
 	(open-account 6) (open-account 5)     ; Open two accounts, then do a couple transactions while double
 	(println "[6 5] ?=" @accounts)        ; checking the account balances.
 	(debit 0 2) (debit 1 2)
 	(println "[4 3] ?=" @accounts)
 	(credit 0 -2) (credit 1 -2)
 	(println "[2 1] ?=" @accounts)

 	(def shopthread (open-shop 10))       ; We name the thread so we can see the number of haircuts later.
	(make-customers)                      ; Start generating customers before we start cutting hair.
	(cut-some-hair)                       ; Put the barber to work!
	(deref shopthread)                    ; Deref allows us to access the value of variables inside.
	(println @num-haircuts))              ; num-haircuts from the shopthread.