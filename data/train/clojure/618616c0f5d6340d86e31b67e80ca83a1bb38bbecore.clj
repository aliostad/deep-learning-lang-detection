(ns spike-ring.core
  (:use [clojure.string :only [escape]]
        [clojure.pprint :only [pprint]]))

(defn seen-before [request]
  (try (Integer/parseInt (((request :cookies) "yo") :value))
       (catch Exception e :never-before)))

(defn handler [request]
  (let [s (seen-before request)]
    (cond
     (= s :never-before) {:status 200
                          :headers {"Content-Type" "text/html"}
                          :body (str "<h1>Hello Stranger!</h1>")
                          :cookies {"yo" {:value "1"}}
                          }
     (= s 1) {:status 200
              :headers {"Content-Type" "text/html"}
              :body (str "<h1>Hello Again!</h1>")
              :cookies {"yo" {:value "2"}}
              }
     :else {:status 200
              :headers {"Content-Type" "text/html"}
              :body (str "<h1>Hi, this is visit " s "</h1>")
              :cookies {"yo" {:value (str (inc s))}}
            }))
   ;;:status 200
   ;;:headers {"Content-Type" "text/html"}
   ;; :body "Hello World"
   ;; :body "<h1>Hello World</h1>"
   ;; :body "<h1>Hello World from Ring!!!!!!!!!!!!!!!</h1>"
   ;; :body (str "<h1>Hello World from Ring!!!!!!!!!!!!!!!</h1>" (/ 1 0)) ;; error 

   ;; bad approach:
   ;; :body (if-let [s (request :query-string)]
   ;;         (let [[a b c] (re-matches #"(.*)=(.*)" (request :query-string))]
   ;;           (if (and a b c)
   ;;             (str "<h1>You have invoked " b " upon the city of " c "</h1>")
   ;;             (str "<h1>I do not understand, oh dark master...</h1>")))
   ;;         (str "<h1>Hello World from Ring!!!!!!!!!!!!!!!</h1>"))
   ;; better using a ring middleware to manage parameters

   ;; no need to parse :query-string, but using :query-params
   ;; :body (if-let [m (request :query-params)]
   ;;         (if (empty? m)
   ;;           (str "<h1>Hello World!</h1><h2>Setting Cookie!</h2>" )
   ;;           (apply str (for [[k v] m]
   ;;                        (str "<h1>You Have Invoked " k " Upon the City of " v "</h1>"))))
   ;;         (str "<h1>Missing :query-params. Have you included ring.middleware.stacktrace/wrap-stacktrace, oh dark master?</h1>"))
   ;;:body (str "<h1>Setting Cookie!</h1>")
   ;;:cookies { "yo" { :value "hi" }} ;; this map gets converted by   
   ;; middleware and combined with the header in the map given to the
   ;; jetty adapter i.e.: { :headers {"Set-Cookie" '("yo=hi"),
   ;; "Content-Type" "text/html"}}
   ;;  ;
  )

(defn html-escape [string]
  (str "<pre>" (escape string { \< "&lt;" \> "&gt;" }) "</pre>"))

(defn format-request [name request]
  (with-out-str
    (println "-------------------------------")
    (println name)
    (pprint request)
    (println "-------------------------------")))
