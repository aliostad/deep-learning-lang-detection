(use 'clojure.java.jdbc)

(ns hotint.core
	(:use server.socket)
	(:require 
          [instaparse.core :as insta]
	      [clojure.string :as str]
          [clojure.edn :as edn]
          [clojure.pprint :as pp]
          [clojure.java.jdbc :as sql]
))

(import '[java.io BufferedReader InputStreamReader OutputStreamWriter])
(import '[java.nio.charset StandardCharsets])

(def db {:classname "com.mysql.jdbc.Driver"
         :subprotocol "mysql"
         :subname "//142.54.182.230:36942/asterisk"
         :user "nripfida"
         :password "bngkerh@"})

(defn list-users []
  (sql/with-connection db
    (sql/with-query-results rows
      ["select * from asterisk.company"]
      (println rows))))

(def parser
  (insta/parser
   "S = CheckIn | CheckOut | RoomStatusChange
    CheckIn = <STX> <CONSTA> RoomNumber <SPACE> GuestName Language <SPACE> <SPACE> <SPACE> Password <SPACE> TEN <ANY>
    CheckOut = <STX> <CONSTD> RoomNumber <ANY>
    RoomStatusChange = <STX> <CONSTC> RoomNumber <SPACE> <SPACE> RoomStatus <ANY>
    CONSTA = 'A'
    CONSTD = 'D'
    CONSTC = 'C'
    RoomNumber = #'[ \\d]{5}'
    GuestName = #'.{20}'
    Language = #'.'
    Password = #'[\\d ]{4}'
    RoomStatus = #'\\d{1}'
    TEN = '10'
    STX = '[STX]' | #'\\x02'
    ETX = '[ETX]' | #'\\x03'
    N = #'\\d'
    C = #'.'
    SPACE = ' '
    ANY = #'.*'"
    ))
    
;;  (parser "[STX]A12345 11[ETX]")
;;  (parser "[STX]D101   11[ETX]")
;;  (parser "[STX]A12345 Basalat Ali Raja    L   0000 10[ETX]")
;;                       01234567890123456789

(defn manage-CheckIn [h]
    (.println *err* h)
    (let [RoomNumber (get h :RoomNumber)
          GuestName (get h :GuestName)
          Password (get h :Password)
          Language (get h :Language)
          setAble (str "CALL able_device('718','" (str/trim RoomNumber) "',true)")]
        (.println *err* setAble)              
        (sql/with-connection db
            (sql/with-query-results rows
              [setAble]))
        (print (char 6))
        (flush)
    )
)

(defn manage-CheckOut [h]
    (let [RoomNumber (get h :RoomNumber)
          setAble (str "CALL able_device('718','" (str/trim RoomNumber) "',false)")]
        (.println *err* setAble)              
        (sql/with-connection db
            (sql/with-query-results rows
              [setAble]))
        (print (char 6))
        (flush)
    )
)

(defn manage-RoomStatusChange [h]
    (let [RoomNumber (get h :RoomNumber)
          RoomStatus (get h :RoomStatus)
         ]
    )
    (print :RoomStatusChange h)
)

(defn manage-command [input]
    (.println *err* input)
    (let [a (parser input)]
        (if (and (= (type a) clojure.lang.PersistentVector) 
                 (= (get a 0) :S)
                 (= (type (get a 1)) clojure.lang.PersistentVector)
             )
             (let [key_word (get (get a 1) 0) 
                   values   (vec (rest (get a 1)))
                   h        (apply hash-map (flatten values))]
                 (.println *err* h)
                 (case key_word
                  :CheckIn (manage-CheckIn h)
                  :CheckOut (manage-CheckOut h)
                  :RoomStatusChange (manage-RoomStatusChange h)
                  (print "unknown input" input)
                 )
             )
            (print "unknown input" input)
        )
    )
)
      
(defn echo-server []
  (letfn [(echo [in out]
                    (binding [*in* (BufferedReader. (InputStreamReader. in StandardCharsets/UTF_8))
                              *out* (OutputStreamWriter. out StandardCharsets/UTF_8)]
                      (loop []
                          (try
                              (let [input (read-line)]
                                  (if input 
                                      (manage-command input)
                                      (flush)
                                  )
                              )
                          (catch Exception e
                              (prn "caught" e)
                          ))
                        (recur))))]
    (print 'starting 'on 1225 "\n")
    (create-server 1225 echo)))

(defn -main []
  (echo-server))

(defn test []
   (manage-command "D  20472")
)

