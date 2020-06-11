(ns
  com.marzhillstudios.http.stream
  (:require
     [com.marzhillstudios.path.uri :as uri]
     [com.marzhillstudios.list.util :as lu]
     [clojure.contrib.http.agent :as ha]
     [clojure.contrib.duck-streams :as du])
  (:use [com.marzhillstudios.test.tap :only [test-tap ok is]]))

(defmulti get-http-stream
  "Gets an http stream using duck-stream/read-lines from the given url.
   
  Takes either a string or path.uri/uri object as an argument."
  type)
(defmethod get-http-stream java.lang.String
  [s] (du/read-lines (ha/stream (ha/http-agent
                                  s :follow-redirects true))))

(defmethod get-http-stream (uri/uri-type)
  [u] (get-http-stream (uri/uri-to-string u)))
