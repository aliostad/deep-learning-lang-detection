(ns parking-lot.manager-test
  (:use clojure.test
        parking-lot.manager
        parking-lot.core))

(deftest should-test-manager
  "test that manager can manage multiple lots"
  (def lot (->Lot 3 [:car :car2 :car3]))
  (def lot2 (->Lot 3 [:car :car2 ]))
  (def manager 
    (->Manager [lot lot2]))
  (is (= lot2 (-> (get-available-parking-lot manager)))))

(deftest should-test-manager-gets-no-lot
  "should return nill if no lot is found"
  (def lot (->Lot 3 [:car :car2 :car3]))
  (def lot2 (->Lot 3 [:car :car2 :car3]))
  (def manager 
    (->Manager [lot lot2]))
  (is (= nil (get-available-parking-lot manager))))

(deftest should-allow-manager-park-a-car
  "Should allow manager park a car in the first 
  none empty lot"
  (def lot (->Lot 3 [:car :car2 :car3]))
  (def lot2 (->Lot 3 [:car :car2]))
  (def manager 
    (->Manager [lot lot2]))
  (is (= [:car :car2 :car4] (-> (park manager :car4 ) :alot))))

(deftest should-not-allow-manager-park-a-car
  "Should not` allow manager park a car if he cant find a lot"
  (def lot (->Lot 3 [:car :car2 :car3]))
  (def lot2 (->Lot 3 [:car :car2 :car5]))
  (def manager 
    (->Manager [lot lot2]))
  (is (= :lot-full-can't-park  (-> (park manager :car4 )))))