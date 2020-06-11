;; All jangosmtp api function throws ExceptionInfo whenever there are errors in jangosmtp server. The exception info's data can be accessed by using clojure.core/ex-data
;;
;;

(ns clj-jangosmtp.core
  (:require [clj-http.client :as client]
            [clojure.data.xml :refer [parse-str]]
            [ribol.core :refer [manage on raise]]))
            


(declare success? jangosmtp-request convert-send-transactional-email-data)


(defprotocol HttpClient
  (post [service url req]))


(defrecord JangoSmtpApi [username password]
  HttpClient
  (post [service url req]
    (client/post url (update-in req 
                                [:form-params]
                                merge
                                {:Username username
                                 :Password password}))))


(defn jangosmtp-api [username password]
  ;; constructor for this api's component
  ;; the component returned from this function IS the first argument to any jangosmtp api function 
  (->JangoSmtpApi username password))


(defn check-bounce [j email]
  ;; return true if email is in bounce list
  (jangosmtp-request
   {:req-fn #(post j "https://api.jangomail.com/api.asmx/CheckBounce" {:form-params {:EmailAddress email}})
    :succ-fn success?}))


(defn delete-bounce [j email]
  ;; delete email from bounce list, returns true even if the email is not in bounce list
  (jangosmtp-request
   {:req-fn #(post j "https://api.jangomail.com/api.asmx/DeleteBounce" {:form-params {:EmailAddress email}})
    :succ-fn success?}))


(defn get-bounce-list-all 
  ;; returns vector containing email in bounce list
  ;; use since to specify since date in string date format e.g. 2014-03-29
  ;; by default returns all email in bounce list
  ([j] (get-bounce-list-all j ""))
  ([j since]
     (jangosmtp-request
      {:req-fn #(post j "https://api.jangomail.com/api.asmx/GetBounceListAll" {:form-params {:Since since}})
       :succ-fn (fn [s]
                  (if (success? s)
                    (-> (clojure.string/split s #"\n")
                        (subvec 2))
                    []))})))


(defn send-transactional-email [j email-data]
  (let [ts (convert-send-transactional-email-data email-data)]
    (jangosmtp-request
     {:req-fn #(post j 
                     "https://api.jangomail.com/api.asmx/SendTransactionalEmail" 
                     {:form-params ts})
      :succ-fn (fn [s]
                 (if (success? s)
                   (-> (clojure.string/split s #"\n")
                       (subvec 2)
                       first)
                   nil))})))


(defn- convert-send-transactional-email-data [email-data]
  ;; convert send-transactional-email-data to JangoSMTP request format
  (let [default {:message-html ""
                 :message-plain ""
                 :options ""}
        ed (merge default email-data)
        {:keys [from-email from-name to-email-address subject message-plain message-html options]} ed]
    {:FromEmail from-email
     :FromName from-name
     :ToEmailAddress to-email-address
     :Subject subject
     :MessagePlain message-plain
     :MessageHTML message-html
     :Options options}))
  

(defn- success? [s]
  ;; success based on jangosmtp api specification
  (= (re-find #"^0\nSUCCESS" s) "0\nSUCCESS" ))


(defn- jangosmtp-request [{:keys [req-fn succ-fn]}]
  ;; encapsulate try catch block where req-fn is the api request to do and succ-fn is the function applied to result of request.
  ;; returns ex-info with :jangosmtp-exception and :data key
  (try
    (succ-fn (->  (req-fn)
                   :body
                   parse-str
                   :content
                   first))
    (catch Exception e
      (raise {:jangosmtp-exception true 
              :data (-> e
                        ex-data
                        :object)}))))
