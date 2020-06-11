(ns blogen.versions
  "Using the underlying version control system we can manage post
  revision histories and provide all kinds of information.

  DEFINITION: A [revision] history of a file is a seq of revisions,
  ordered by time desc. The topmost is the newest and the current
  revision.

  DEFINITION: A revision is a map with keys :hash, :date and :note."
  (:require [clj-time.format]
            [dire.core :refer [with-handler!]]
            [me.raynes.conch :refer [programs]])
  (:use [blogen.config]))

(programs git)

;;; git log --format="%%HASH: %h %n%%DATE: %aD %n%%NOTE: %s %n%%%%"
;;; both --git-dir and --work-tree need to be specified.

(def git-arguments
  (let [orig-dir (:original-dir @config)]
    [(str "--git-dir=" orig-dir "/.git/")
     (str "--work-tree=" orig-dir)
     "log"
     "--format=%%HASH: %h %n%%DATE: %aD %n%%NOTE: %s %n%%%%"]))

(def git-log-date-format
  (clj-time.format/formatters :rfc822))

(defn major-revision?
  "Basing on revision data (map) determine if this revision is a major
  one."
  [rev]
  (boolean (re-find #"MAJ|XXX|UP"
                    (:note rev))))

(defn read-revision
  "Read a revision from git output."
  [rev-str]
  (when (seq rev-str)
    (let [lines (vec (.split rev-str "\\n"))
          pieces (for [l lines]
                   (re-matches #"^%([A-Z]+): (.+?)\s*$" l))
          rev (into {} (for [p pieces]
                         [(keyword (.toLowerCase (p 1)))
                          (p 2)]))
          rev (update-in rev [:date]
                         (partial clj-time.format/parse
                                  git-log-date-format))
          rev (assoc rev :major? (major-revision? rev))]
      rev)))

(defn history
  "Get and parse revision history of given file."
  [path]
  (let [git-output (apply git (conj git-arguments path))
        git-output (seq (.split git-output "\\n%%\\n"))]
    (filter
     identity
     (map read-revision git-output))))
