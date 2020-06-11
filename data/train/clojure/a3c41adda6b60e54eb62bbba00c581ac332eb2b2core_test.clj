(ns reddit-tv.core-test
  (:require [reddit-tv.core :refer [get-n-posts]]
            [reddit-tv.reddit.api :refer [get-posts-page]]
            [reddit-tv.util :refer [check-passed?]]
            [reddit-tv.spec :as rs]
            [clojure.spec.test :refer [instrument check]]
            [clojure.test :refer :all]
            [clojure.spec :as s]
            [clojure.spec.gen :as gen]))

(deftest test-get-posts
  (instrument `get-posts-page {:stub #{`get-posts-page}})
  (is (check-passed? (check `get-n-posts))))
