(ns photodb-server.log)

(require '[photodb-server.utils :as utils])
(require '[photodb-server.manage :as manage])
(require '[clojure.data.json :as json])

(doseq [tag (filter #(not (.startsWith %1 "#")) (manage/tags-list-name))] (println tag))

(doseq [tag (filter #(.startsWith %1 "#") (manage/tags-list-name))] (println tag))

(defn print-seq [seq]
  (doseq [elem seq]
    (println elem)))


(defn print-subtags-for-tags [tags-seq]
  (doseq [tag tags-seq]
    (let [sub-tags-map (manage/tag-tags tag)]
      (println tag)
      (println (json/write-str sub-tags-map)))))


; will update only id, mongodb's _id will remain old
(defn rewrite-old-id-to-new [images-file-path new-images-file-path]
  (with-open [reader (clojure.java.io/reader images-file-path)
              writer (clojure.java.io/writer new-images-file-path)]
    (doseq [record (map
                     #(json/read-str %1 :key-fn keyword)
                     (line-seq reader))]
      (let [old-id (:id record)
            new-id (utils/old-id-to-new-one old-id)]
        (.write
          writer
          (json/write-str
            (assoc
              record
              :id
              new-id)))
        (.write writer "\n")))))


(defn load-image-db-backup-file [images-file-path]
  (with-open [reader (clojure.java.io/reader images-file-path)]
    (reduce
      (fn [state record]
        (conj state record))
      '()
      (map
        #(json/read-str %1 :key-fn keyword)
        (line-seq reader)))))

(defn update-tags-on-existing [image-seq]
  (doseq [image image-seq]
    (if-let [_ (manage/image-get (:id image))]
      (manage/image-tags-set (:id image) (:tags image))
      (println "not existing image " (:id image)))))

