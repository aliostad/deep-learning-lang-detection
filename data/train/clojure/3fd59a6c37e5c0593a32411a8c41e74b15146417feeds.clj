(ns event-data-newsfeed-agent.feeds
  "Manage newsfeed feed list."
  (:require [clojure.tools.logging :as l]
            [clojure.data.json :as json])
  (:require [clj-time.coerce :as clj-time-coerce]
            [clj-time.core :as clj-time])
  (:import [java.net URL]
           [java.io InputStreamReader]
           [com.rometools.rome.feed.synd SyndFeed SyndEntry SyndContent]
           [com.rometools.rome.io SyndFeedInput XmlReader]))

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
  (l/info "Retrieve latest from feed:" feed-url)
  (let [url (new URL feed-url)
        input (new SyndFeedInput)
        feed (.build input (new XmlReader url))
        entries (.getEntries feed)
        parsed-entries (map (partial parse-section url (str (clj-time/now))) entries)]
      parsed-entries))
