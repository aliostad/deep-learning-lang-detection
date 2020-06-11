(ns photodb-server.manage)

(require 'monger.core)
(require '[monger.collection :as mongo])

(use 'monger.operators)

(require 'photodb-server.core)

(defonce db
	(let [connection (monger.core/connect {:host "localhost" :port 27017})]
		(monger.core/get-db connection "photodb")))

; todo in future we should be able to change stores and types for tag
(defn tag-create-if-not-exists [name]
	(try
		(mongo/insert-and-return db "tags" {
			:_id name
			:id name
			:stores '(
				[:default-store '(:all)])})
		(catch com.mongodb.DuplicateKeyException e nil)))

(defn tags-list []
	(mongo/find-maps db "tags"))

(defn tag-get [name]
	(mongo/find-one-as-map db "tags" {:id name}))

(defn images-seq
  "Retrieves all images in db in seq"
  []
  (mongo/find-maps db "images" {}))

(defn image-tags-set
	"Should be used during image update"
	[image-id tags]
	(mongo/update db "images" {:id image-id} {$set {:tags tags}}))

(defn tag-remove [tag-to-remove]
  (doseq [image (filter
                  #(contains? (set (:tags %1)) tag-to-remove)
                  (images-seq))]
    (image-tags-set (:id image) (disj (into #{} {:tags image}) tag-to-remove))))

(defn image-create
	"Should be used during process image, initial image import"
	[image-metadata]
	(mongo/insert-and-return db "images" image-metadata))

(defn image-get [image-id]
	(mongo/find-one-as-map db "images" {:id image-id}))

(defn images-find [tags]
	(mongo/find-maps db "images" {:tags {$all tags}}))


; utils to support repl commands / move somewhere

(defn path-to-array [path]
  (clojure.string/split path #"/"))

(defn path-name [path]
  (let [path-array (path-to-array path)]
    (last path-array)))

(defn path-dir-name
  "Assumes that path is path to file, returns name of directory containing file"
  [path]

  (let [path-array (path-to-array path)]
    (nth path-array (- (count path-array) 2))))

(defn path-root-dir-path
  "Assues that path is path to file in dir which is inside root-dir, returns path to root dir"
  [path]

  (let [path-array (path-to-array path)]
    (clojure.string/join "/" (take (- (count path-array) 2) path-array))))


(defn print-seq [seq-to-print]
  (doseq [element seq-to-print]
    (println element)))

; to be used inside of repl

(defn list-root-store-paths []
  (into []
    (reduce
      (fn [root-paths-set image]
        (let [root-path (path-root-dir-path (:path image))]
          (conj root-paths-set root-path)))
      #{}
      (mongo/find-maps db "images" {}))))

(defn list-dirs []
  (into []
    (reduce
      (fn [dirs-set image]
        (let [dir (path-dir-name (:path image))]
          (conj dirs-set dir)))
      #{}
      (mongo/find-maps db "images" {}))))

(defn tags-list-name []
  (map
    (fn [tag] (:id tag))
    (tags-list)))

(defn images-find-id [tags]
  (map
    (fn [image] (:id image))
    (images-find tags)))

(defn images-find-by-filename
  "Retrieves image metadata for images that match by filename"
  [filename]

  (mongo/find-maps db "images" {:path {$regex (str ".*" filename ".*")}}))


(defn tag-tags
  "Counts other tags inside given tag"
  [tag]

  (let [images (images-find (list tag))]
    (reduce
      (fn [counts image]
        (let [tags (into #{} (filter
                               (fn [image-tag] (not (= image-tag tag)))
                               (:tags image)))]
          (reduce
            (fn [counts tag]
              (assoc counts tag (inc (get counts tag 0))))
            counts
            tags)))
      {}
      images)))





