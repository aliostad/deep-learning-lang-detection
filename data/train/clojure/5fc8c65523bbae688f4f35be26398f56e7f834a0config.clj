(ns GeneralTestSuite.config
  (:use [GeneralTestSuite.util :only [get-time-one-day-ago get-time-one-week-ago]])
  (:use [GeneralTestSuite.db]))



(def login-routes
  "Map of login-maps, including request base address, login info and some configurations."
  ;; local 8084
  {:login-local-direct {:name "fbpapf000000001m", ;  fbbbcc001m
	   :password "111111",
	   :settled (str (rand-int 2)),
	   :log-location "direct-output.log"
     :base-url "http://localhost:8084/SgfmApi/"
     :use-local-db true
     :suppress-console true}
  :login-local {:name "fbbbcc001m", 
	   :password "111111",
	   :settled (str (rand-int 2)),
	   :log-location "nginx-output.log"
     :base-url "http://172.17.110.22:8080/SgfmApi/"
     :use-local-db true
     :suppress-console true}
  :login-remote-test {:name "fbzhli001m", 
	   :password "111111",
	   :settled (str (rand-int 2)),
     :log-location "remote-test-output.log"
     :base-url "http://172.17.108.52:8088/SgfmApi/"
     :use-local-db true
     :suppress-console true}
   :login-remote {:name "fbchli000m", 
	   :password "111111",
	   :settled (str (rand-int 2)),
	   :log-location "remote-output.log"
     :base-url "http://localhost:8084/SgfmApi/"
     :use-local-db nil
     :suppress-console true}
})

(defn get-rand-tradable-id [use-local-db]
  "Get a random tradable id from local or remote timesten server.
   NOT EFFICIENT, for small dataset only!"
  (let [rs (if use-local-db 
    (query-for-selections pool-tt)
    (query-for-selections pool-tt-remote))]
    (if (> (count rs) 0)
      (.toPlainString (rand-nth rs)))))

(defn get-rand-order-id [login-name use-local-db]
  (let [rs (if use-local-db 
    (query-for-order-ids pool-tt login-name)
    (query-for-order-ids pool-tt-remote login-name))]
    (if (> (count rs) 0)
      (.toPlainString (rand-nth rs)))))  

(defn get-rand-matchid [use-local-db]
  (let [rs (if use-local-db 
    (query-for-match-ids pool-tt)
    (query-for-match-ids pool-tt-remote))]
    (if (> (count rs) 0)
      (.toPlainString (rand-nth rs)))))

(defn request-path-dummy
  "Request path construction using configurations passed in login-map "
  [login-map]
  {:login (format "login.sv?param={'un':'%s','pwd':'%s'}" (login-map :name) (login-map :password)), 
   :list-valid (format "orderManage.sv?act=getValidOrderList&param={st_date:'%s', settled:'%s'}" (get-time-one-week-ago) (login-map :settled)),
   :list-invalid (format "orderManage.sv?act=getInvalidOrderList&param={order_stas:[7,8],st_date:'%s', settled:'%s'}" (get-time-one-day-ago) (login-map :settled)),
  :list-all-pending (format "orderManage.sv?act=getOrderList&param={st_date:'%s',order_sta:1}" (get-time-one-week-ago)),
  :list-all-pending-no-args (str "orderManage.sv?act=getOrderList&param={}")
   :list-all-settled (format "orderManage.sv?act=getOrderList&param={st_date:'%s',settled:'%s'}" (get-time-one-week-ago) (login-map :settled)),
   ;; :order-add (format "orderManage.sv?act=addOrder&param={'orders':[{'type':3,'direction':2,'price':1.32,'stake':100, 'sel_id':14550017}]}" ),
      :order-add (format "orderManage.sv?act=addOrder&param={'orders':[{'type':3,'direction':2,'price':1.32,'stake':100, 'sel_id':%s}]}" 
                       (get-rand-tradable-id (login-map :use-local-db))),
   :order-update (format "orderManage.sv?act=updOrder&param={order_id:%s, price:1.77, stake:117}" 
                          (get-rand-order-id (:name login-map)
                                             (:use-local-db login-map)))
   :order-add-with-expire (format "orderManage.sv?act=addOrder&param={'orders':[{'type':3,'direction':2,'price':1.98,'stake':100, 'sel_id':%s,'time_out':10, 'expire':5}]}"
                                  (get-rand-tradable-id (login-map :use-local-db))),
  ;; :order-undo "orderManage.sv?act=undoOrder",
   :order-add-multiple (format (str "orderManage.sv?act=addOrder&param=" 
                            "{'orders':[{'type':3,'direction':1,'price':1.23,'stake':100, 'sel_id':%s,'expire':12},"
                            "{'type':1,'direction':1,'price':1.24,'stake':10000, 'sel_id':%s,'time_out':59},"
                            "{'type':3,'direction':1,'price':1.68,'stake':8000, 'sel_id':%s,'expire':10}]}")
                               (get-rand-tradable-id (login-map :use-local-db)) 
                               (get-rand-tradable-id (login-map :use-local-db)) 
                               (get-rand-tradable-id (login-map :use-local-db))), ; todo: ugly
   ;; :order-push "orderManage.sv?act= pushOrder"
  :list-markets "marketInfo.sv?",
  :list-single-market (format "marketInfo.sv?act=getMarket&param={'language':'zh','event_ids':[%s]}" (get-rand-matchid (:use-local-db login-map)))
  :list-markets-selection (format "marketInfo.sv?act=getSelections&param={sel_ids:[%s,%s,%s]}"
                                  (get-rand-tradable-id (login-map :use-local-db)) 
                              (get-rand-tradable-id (login-map :use-local-db)) 
                              (get-rand-tradable-id (login-map :use-local-db))), 
  :list-leagues "marketInfo.sv?act=getLeague",
  ;; :list-markets-cond (format  "marketInfo.sv?act=getMarket&param={language:'EN','event_ids':[%s,%s],'ver_num':52}"
  ;;                             (get-rand-matchid (:use-local-db login-map))
  ;;                             (get-rand-matchid (:use-local-db login-map)))
  :query-account (format "account.sv?param={'un':'%s'}" (login-map :name))
  ;;  :get-hb "getHeart.sv?time_out=10"
  ;; :cancel-hb "getHeart.sv"
   })


(defn request-path
  "Request path construction using configurations passed in login-map "
  [login-map]
  {:login (format "login.sv?param={'un':'%s','pwd':'%s'}" (login-map :name) (login-map :password))
   ;; :list-valid (format "orderManage.sv?act=getValidOrderList&param={st_date:'%s', settled:'%s'}" (get-time-one-week-ago) (login-map :settled)),
  ;;  :list-invalid (format "orderManage.sv?act=getInvalidOrderList&param={order_stas:[7,8],st_date:'%s', settled:'%s'}" (get-time-one-day-ago) (login-map :settled)),
  ;; :list-all-pending (format "orderManage.sv?act=getOrderList&param={st_date:'%s',order_sta:1}" (get-time-one-week-ago)),
  ;; :list-all-pending-no-args (str "orderManage.sv?act=getOrderList&param={}")
  ;;  :list-all-settled (format "orderManage.sv?act=getOrderList&param={st_date:'%s',settled:'%s'}" (get-time-one-week-ago) (login-map :settled)),
  ;; :list-markets "marketInfo.sv?",
  ;; :list-leagues "marketInfo.sv?act=getLeague",
  ;; :query-account (format "account.sv?param={'un':'%s'}" (login-map :name))
      ;; :order-add (format "orderManage.sv?act=addOrder&param={'orders':[{'type':3,'direction':2,'price':1.32,'stake':100, 'sel_id':%s}]}" 
      ;;                  (get-rand-tradable-id (login-map :use-local-db)))
   :order-add (format "orderManage.sv?act=addOrder&param={'orders':[{'type':3,'direction':2,'price':1.79,'stake':11, 'sel_id':%s}]}" (get-rand-tradable-id (login-map :use-local-db)))  ;88744
;;   :order-undo "orderManage.sv?act=undoOrder"
;; :order-add-with-expire (format "orderManage.sv?act=addOrder&param={'orders':[{'type':3,'direction':2,'price':2.17,'stake':11, 'sel_id':14553689,'time_out':10, 'expire':60}]}") ;14553689 14553691
   })
