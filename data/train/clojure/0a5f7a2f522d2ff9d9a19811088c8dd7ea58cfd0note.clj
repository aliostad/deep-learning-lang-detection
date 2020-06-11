(def ^:private note-options [["-s" "--list"]
                             ["-l" "--last"]
                             ["-a" "--add"]
                             ["-d" "--delete INDEX" :parse-fn #(Integer/parseInt %)]])

(defn- create-note [note nick]
  (if (not (.exists (io/file "notes")))
    (.mkdir (io/as-file "notes")))
  (if (not (.exists (io/file (str "notes/" nick))))
    (.mkdir (io/as-file (str "notes/" nick))))
  (let [timestamp (System/currentTimeMillis)]
    (spit (str "notes/" nick "/" timestamp) note)))

(defn- get-note-files [nick]
  (filter #(.isFile %) (.listFiles (io/as-file (str "notes/" nick)))))

(defn- delete-note [index nick]
  (let [file-to-delete (nth (sort (get-note-files nick)) (- index 1))]
    (if (.exists file-to-delete)
      (clojure.java.io/delete-file file-to-delete))))

(defn- show-last-note [nick]
  (slurp
   (last
    (sort
     (get-note-files nick)))))

(defn- list-notes [nick]
  (map-indexed
   (fn [i file]
     (let [note (slurp file)
           length (count note)]
       (str (+ i 1) ": " (subs note 0 (min (count note) 100)) (if (> length 100) "..."))))
   (take-last 3 (sort (get-note-files nick)))))

(defn note
  "Manage notes"
  {:aliases ["n"] :options note-options}
  [in message]
  (let [opts (cli/parse-opts (clojure.string/split in #"\s") note-options)
        note (clojure.string/join " " (:arguments opts))
        nick (:nick message)]
    (cond
     (flag? opts :list) (list-notes nick)
     (flag? opts :add) (create-note note nick)
     (flag? opts :last) (show-last-note nick)
     (and (contains? opts :options) (contains? (:options opts) :delete)) (delete-note (get-in opts [:options :delete]) nick)
     (not (clojure.string/blank? in)) (create-note in nick))))

(defn notes
  "Same as .note --list"
  [in message]
  (list-notes (:nick message)))

; TODO: User specific, delete command, multi-line
