(ns twitter-producer.core
  (:require [twitter-streaming-client.core :as client]
            [twitter.oauth :as oauth]
            [twitter.api.streaming]
            [clojure.tools.logging :refer [debug info error]]
            [amazonica.aws.kinesis :as kinesis]
            [amazonica.core :refer [defcredential]]
            [clj-time.format :as format]
            [clj-time.coerce :refer [to-date]]
            [environ.core :refer [env]]
            [clojure.string :as string]
            [clojure.tools.cli :refer [parse-opts]])
  (:import com.amazonaws.services.kinesis.model.ResourceInUseException
           java.util.Locale)
  (:gen-class))

(def twitter-creds (oauth/make-oauth-creds (env :consumer-key)
                                           (env :consumer-secret)
                                           (env :access-token)
                                           (env :access-token-secret)))

(defcredential (env :aws-access-key-id) (env :aws-secret-key) (env :aws-region))

(def ^:dynamic *kinesis-stream-name* "Twitter")

(def ^:dynamic *kinesis-uri* "https://kinesis.eu-west-1.amazonaws.com")

;; make sure we have a working stream
(defn create-kinesis-stream [stream-name shards]
  (let [streams (kinesis/list-streams)
        stream-names (set (:stream-names streams))]
    (if (stream-names stream-name)
      (do                               ;stream exists, check status
        (info "Kinesis stream" stream-name "exists, checking status...")
        (let [stream (kinesis/describe-stream stream-name)
              status (get-in stream [:stream-description :stream-status])]
          (case status
            "ACTIVE" (do
                       (info "Kinesis stream" stream-name "is active")
                       stream)
            "CREATING" (do (info "Stream" stream-name "is in status CREATING, waiting until it's done")
                           (Thread/sleep 5000)
                           (recur stream-name shards))
            "DELETING" (do (info "Stream" stream-name "is in status DELETING, will re-create when done")
                           (Thread/sleep 5000)
                           (recur stream-name shards)))))
      (do                               ;no stream, create it
        (info "Creating Kinesis stream" stream-name)
        (try
          (kinesis/create-stream stream-name shards)
          (catch ResourceInUseException e
            (error "Stream" stream-name "already exists, somebody got in between")
            (System/exit 2)))
        (Thread/sleep 5000)
        (recur stream-name shards)))))

(defn- handle-hashtag [stream-name date hashtag]
  (let [data {:created-at date
              :tag hashtag}]
    (info "Posting to Kinesis:" data)
    (kinesis/put-record stream-name
                        data
                        hashtag)))

(defn- handle-tweet [stream-name tweet]
  (let [;; see https://dev.twitter.com/docs/tweet-entities
        hashtags (get-in tweet [:entities :hashtags])
        date-str (:created_at tweet)
        formatter (format/with-locale
                    (format/formatter "EEE MMM dd HH:mm:ss Z yyyy")
                    Locale/ENGLISH)
        date (when date-str
               (to-date (format/parse formatter date-str)))]

    (doseq [hashtag (mapv :text hashtags)]
      (handle-hashtag stream-name date hashtag))))

(declare kinesis-stream)
(declare twitter-stream)

(defn cleanup []
  (info "Cancelling the Twitter stream")
  (client/cancel-twitter-stream twitter-stream)
  (when kinesis-stream
    (info "Note that Kinesis stream"
          (get-in kinesis-stream [:stream-description :stream-arn])
          "still exists")))

;; command line stuff

(def cli-options
  [["-s" "--stream STREAMNAME" "Kinesis stream name (required)"]
   ["-k" "--shards N" "Number of Kinesis shards; each 1000 writes/s and 5 reads/s"
    :default 1
    :parse-fn #(Integer/parseInt %)
    :validate [#(< 0 % 5) "Must be a number between 1 and 4, because it may get expensive"]]
   ["-h" "--help"]])

(defn usage [options-summary]
  (->> [""
        "This is the twitter-producer application, that gets tweets off the Twitter"
        "Streaming API, parses the Twitter hashtags, and posts each hashtag to the given"
        "Kinesis stream with a timestamp, sharding on the hashtag. A Kinesis client"
        "application downstream can then perform calculations on that data, for example"
        "sliding window counts."
        ""
        "You must specify a Kinesis stream where to post the hashtags. That would perhaps"
        "be Hashtags-<teamname>. The stream will be created if not already existing."
        ""
        "Usage: twitter-producer [-h] [-k N] -s STREAMNAME"
        options-summary]
       (string/join \newline)))

(defn error-msg [errors]
  (str "The following errors occurred while parsing your command:\n\n"
       (string/join \newline errors)))

(defn exit [status msg]
  (println msg)
  (System/exit status))

(defn -main [& args]
  (let [{:keys [options arguments errors summary]} (parse-opts args cli-options)]
    ;; Handle help and error conditions
    (cond
     (:help options) (exit 0 (usage summary))
     (not
      (:stream options)) (exit 1 (str \newline "Some options are required"
                                      \newline (usage summary)))
     errors (exit 1 (error-msg errors)))

    ;; ugly, but I think these need to be global for the cleanup function to see them
    (def kinesis-stream (create-kinesis-stream (:stream options) (:shards options)))
    (def twitter-stream (client/create-twitter-stream
                         twitter.api.streaming/statuses-sample
                         :oauth-creds twitter-creds))

    (client/start-twitter-stream twitter-stream)
    (.addShutdownHook (Runtime/getRuntime) (Thread. cleanup))
    (try
      (loop []
        (let [queues (client/retrieve-queues twitter-stream)
              tweets (:tweet queues)]
          (doseq [tweet tweets]
            (debug "Handling tweet" (:id tweet))
            (handle-tweet (:stream options) tweet))
          (recur)))
      (catch Exception e
        (error "A problem occurred when retrieving tweets:" (.getMessage e))
        (cleanup)
        (System/exit 1)))))
