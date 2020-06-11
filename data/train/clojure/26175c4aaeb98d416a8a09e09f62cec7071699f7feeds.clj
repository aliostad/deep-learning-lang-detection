(ns event-data-newsfeed-agent.feeds
  "Manage newsfeed feed list."
  (:require [baleen.context :as baleen-context]
            [baleen.redis :as baleen-redis]
            [baleen.time :as baleen-time]
            [baleen.stash :as baleen-stash]
            [baleen.queue :as baleen-queue])
  (:require [clojure.tools.logging :as l]
            [clojure.data.json :as json])
  (:require [clj-time.coerce :as clj-time-coerce])
  (:import [java.net URL]
           [java.io InputStreamReader]
           [com.rometools.rome.feed.synd SyndFeed SyndEntry SyndContent]
           [com.rometools.rome.io SyndFeedInput XmlReader])
  )

(defn add-feed
  [context feed-url]
  (l/info "Add feed" feed-url)
  (with-open [redis-conn (baleen-redis/get-connection context)]
    (.sadd redis-conn "newsfeed__feed-urls" (into-array [feed-url]))))

(defn parse-section
  "Parse a SyndEntry into an object that can be serialized."
  [feed-url fetch-date-str ^SyndEntry entry]
  (let [title (.getTitle entry)
        ; for feedburner this is annoyingly a redirect URL.
        link (.getLink entry)
        ; for feedburner this is the URL of the feed, but only the link is actually defined as being the URL.
        id (.getUri entry)
        
        updated (clj-time-coerce/to-string (clj-time-coerce/from-date (or (.getUpdatedDate entry) (.getPublishedDate entry))))
        ^SyndContent description (.getDescription entry)
        summary (.getValue description)]
    { :title title
      :link link
      :id id
      :updated updated
      :summary summary
      :feed-url (str feed-url)
      :fetch-date fetch-date-str}))

(defn get-items
  "Get list of parsed items from the feed url."
  [feed-url]
  (let [url (new URL feed-url)
        input (new SyndFeedInput)
        feed (.build input (new XmlReader url))
        entries (.getEntries feed)
        parsed-entries (map (partial parse-section url (baleen-time/iso8601-now)) entries)]
      parsed-entries))

(def year-in-seconds
  (*
    60 ; seconds in a minute
    60 ; minutes in an hour
    24 ; hours in a day
    365 ; days in a year
))

(defn get-new-items
  "Get a list of unseen new items from the feed url.
  Maintain a list of 'newsfeed__seen-' prefixed keys in redis that expire after a year."
  [context feed-url]
  (with-open [redis-conn (baleen-redis/get-connection context)]
    (let [items (get-items feed-url)
          unseen-items (remove (fn [item] (.get redis-conn (str "newsfeed__seen-" (:id item)))) items)]
      (doseq [item unseen-items]
        (.set redis-conn (str "newsfeed__seen-" (:id item)) "1")
        (.expire redis-conn (str "newsfeed__seen-" (:id item)) year-in-seconds))
      unseen-items)))

(defn queue-all
  "Retrieve all feeds. Should be run every hour or so."
  [context]
  (l/info "Queue all feeds")
  (with-open [redis-conn (baleen-redis/get-connection context)]
    (let [feed-urls (.smembers redis-conn "newsfeed__feed-urls")
          feed-urls-to-stash (map #(hash-map :url %) feed-urls)]
      (baleen-stash/stash-jsonapi-list context feed-urls-to-stash (str "feeds-" (baleen-time/iso8601-now) ".json") "feed-url" false)
      (baleen-stash/stash-jsonapi-list context feed-urls-to-stash (str "feeds-current.json") "feed-url" true)
      (l/info "Check" (count feed-urls) "feeds"
      (doseq [feed-url feed-urls]
        (l/info "Check" feed-url)
        (let [new-items (get-new-items context feed-url)]
          (l/info "Got" (count new-items) "new items")
          (doseq [item new-items]
            (baleen-queue/enqueue context "input" (json/write-str item) true))))))))
