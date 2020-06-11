(ns hello-world.key-maps
  (:require
   [hello-world.views :as view]
   [re-frame.core :refer [dispatch]] 
   [cljs-time.core :as time]
   [cljs-time.format :as formatter]
   ))

;; Helper functions
(def encode-date (formatter/formatters :date-hour-minute-second))

;; Key-maps

(def modal-login-key-map
  {87 {:info "MODAL w - LOGIN and create session as anja"
       :fn (fn [] (dispatch [:session-login "DoLogin"]))}
   81 {:info "MODAL q should qlose!!!"
       :fn (fn [] (dispatch [:close-modal]))}})

(def modal-help-key-map
  {
   81 {:info "MODAL q should qlose!!!"
       :fn (fn [] (dispatch [:close-modal]))}})

(def modal-market-catalogue-key-map
  {
   81 {:info "MODAL q should qlose!!!"
       :fn (fn [] (dispatch [:close-modal]))}
   49 {:info "Press 1 to select the first row"
       :fn (fn [] (do
                    (dispatch [:select-market 0])
                    (dispatch [:close-modal])))}
   50 {:info "Press 2 to select the first row"
       :fn (fn [] (do
                    (dispatch [:select-market 1])
                    (dispatch [:close-modal])))}
   51 {:info "Press 3 to select the first row"
       :fn (fn [] (do
                    (dispatch [:select-market 2])
                    (dispatch [:close-modal])))}
   52 {:info "Press 4 to select the first row"
       :fn (fn [] (do
                    (dispatch [:select-market 3])
                    (dispatch [:close-modal])))}
   53 {:info "Press 5 to select the first row"
       :fn (fn [] (do
                    (dispatch [:select-market 4])
                    (dispatch [:close-modal])))}
   54 {:info "Press 6 to select the first row"
       :fn (fn [] (do
                    (dispatch [:select-market 5])
                    (dispatch [:close-modal])))}
   55 {:info "Press 7 to select the first row"
       :fn (fn [] (do
                    (dispatch [:select-market 6])
                    (dispatch [:close-modal])))}
   56 {:info "Press 8 to select the first row"
       :fn (fn [] (do
                    (dispatch [:select-market 7])
                    (dispatch [:close-modal])))}
   57 {:info "Press 9 to select the last row"
       :fn (fn [] (do
                    (dispatch [:select-market 8])
                    (dispatch [:close-modal])))}
   })
   

(def key-map
  {
   66 {:info "b to login to betfair"
       :fn (fn [] (dispatch [:open-modal [view/login {:shown #(dispatch [:load-keymap modal-login-key-map])
                                                      :hide #(dispatch [:load-keymap key-map])}]]))}
   72 {:info "h open help, will close any open modals"
       :fn (fn [] (dispatch [:open-modal [view/help {:shown #(dispatch [:load-keymap modal-help-key-map])
                                                     :hide #(dispatch [:load-keymap key-map])}]]))}
   88 {:info "x to list market catalogue at betfair..."
       :fn (fn [] (dispatch [:open-modal [view/list-market-catalogue {:shown #(do (dispatch [:load-keymap modal-market-catalogue-key-map])
                                                                                  (dispatch [:betfair-request [:make-request {:endpoint "listMarketCatalogue"
                                                                                                                              :body {:filter {:eventTypeIds [7] ;; make to string if "7"
                                                                                                                                              :marketStartTime {:from (formatter/unparse encode-date (time/now))
                                                                                                                                                                :to (formatter/unparse encode-date (time/plus (time/now) (time/minutes 180)))}}
                                                                                                                                     :maxResults 9
                                                                                                                                     :sort "FIRST_TO_START"
                                                                                                                                     :marketProjection ["MARKET_START_TIME"]}}]])
                                                                                  )
                                                                      :hide #(dispatch [:load-keymap key-map])}]])
             )}
   75 {:info "k to kill market watcher"
       :fn (fn [] (dispatch [:send-to-market-watcher [:kill]]))}
   84 {:info "t to place a bet"
       :fn (fn [] (dispatch [:make-request [:cancel-order {:endpoint "placeOrders"
                                                              :body {:marketId nil 
                                                                     :instructions [{:selectionId nil :handicap 0 :side "BACK" :orderType "LIMIT"
                                                                                     :limitOrder {:size 2 :price 1000 :persistenceType "LAPCE"}}]}}]]))}
   89 {:info "y to cancel a bet"
       :fn (fn [] (dispatch [:make-request [:make-request {:endpoint "cancelOrders"
                                                              :body {}}]]))}
   
   49 {:info "Press 1 to select the first selection"
       :fn (fn [] (dispatch [:select-selection 0]))}
   50 {:info "Press 2 to select the secound selection"
       :fn (fn [] (dispatch [:select-selection 1]))}
   51 {:info "Press 3 to select the third selection"
       :fn (fn [] (dispatch [:select-selection 2]))}
   52 {:info "Press 4 to select the fourth row"
       :fn (fn [] (dispatch [:select-selection 3]))}
   })
