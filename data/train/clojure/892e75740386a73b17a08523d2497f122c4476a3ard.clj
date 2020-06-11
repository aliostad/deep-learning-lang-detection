(ns lcmap.aardvark.ard
  "Functions for parsing ARD XML metadata.

  This is useful for obtaining data to produce chip-specs and
  convert bands into chips."
  (:require [clojure.java.io :as io]
            [clojure.xml :as xml]
            [clojure.zip :as zip]
            [clojure.data.zip.xml :refer :all]
            [clojure.tools.logging :as log]
            [lcmap.aardvark.util :as util])
  (:refer-clojure :exclude [load]))

(defn find-xml
  "Gets the path to the metadata file of an ESPA archive."
  [path]
  (let [files (-> path io/file file-seq)
        names (map #(.getPath ^java.io.File %) files)
        xml   (filter #(re-find #".+\.xml" %) names)]
    (first xml)))

(defn +path
  "Add absolute path to band's raster image."
  [scene-dir band]
  (let [path (.getAbsolutePath (io/file scene-dir (:file_name band)))]
    (assoc band :path path)))

(defn +ubid
  "Add UBID to band."
  [band]
  (let [vals ((juxt :satellite :instrument :band_name) band)]
    (assoc band :ubid (clojure.string/join "/" vals))))

(defn +acquired
  "Add scene center ISO8601 time, not just a date."
  [band]
  (let [date (:acquisition_date band)
        time (:scene_center_time band)
        time-no-ms (first (re-seq #"[0-9:]+" time))
        acquired (format "%sT%sZ" date time-no-ms)]
    (assoc band :acquired acquired)))

(def chip-spec-tags (util/read-edn "chip-spec-tags.edn"))

(defn +tags
  "Appends additional tags to a chip-spec"
  [chip-spec]
  (log/debugf "appending additional tags to chip-spec")
  (let [ubid-tags (clojure.string/split (:ubid chip-spec) #"/|_")]
    (-> chip-spec
        (update :tags concat ubid-tags)
        (update :tags concat (chip-spec-tags (:ubid chip-spec))))))

(defn parse-tile-metadata
  [root]
  ""
  (let [gmzip (xml1-> root :tile_metadata :global_metadata)]
    {:data_provider     (xml1-> gmzip :data_provider text)
     :satellite         (xml1-> gmzip :satellite text)
     :instrument        (xml1-> gmzip :instrument text)
     :acquisition_date  (xml1-> gmzip :acquisition_date text)
     :product_id        (xml1-> gmzip :product_id text)
     :production_date   (xml1-> gmzip :production_date text)}))

(defn parse-scene-metadata
  ""
  [root]
  (let [gmzip (xml1-> root :scene_metadata :global_metadata)]
    {:data_provider      (xml1-> gmzip :data_provider text)
     :satellite          (xml1-> gmzip :satellite text)
     :instrument         (xml1-> gmzip :instrument text)
     :acquisition_date   (xml1-> gmzip :acquisition_date text)
     :scene_center_time  (xml1-> gmzip :scene_center_time text)
     :request_id         (xml1-> gmzip :request_id text)
     :scene_id           (xml1-> gmzip :scene_id text)
     :product_id         (xml1-> gmzip :product_id text)}))

(defn parse-range
  "Convert a valid_range element into a list."
  [band]
  (if-let [element (xml1-> band :valid_range)]
    [(some-> (attr element :min) Double/parseDouble)
     (some-> (attr element :max) Double/parseDouble)]))

(defn parse-bit
  "Convert a bit element to an number-text pair."
  [bit]
  [(Integer/parseInt (attr bit :num)) (text bit)])

(defn parse-bitmap
  "Convert a bitmap_description element into a map."
  [band]
  (some->> (xml-> band :bitmap_description :bit)
           (map parse-bit)
           (into (sorted-map))))

(defn parse-fill
  ""
  [band]
  (some-> (attr band :fill_value) Short/parseShort))

(defn parse-scale
  ""
  [band]
  (some-> (attr band :scale_factor) Double/parseDouble))

(defn parse-band
  "Convert a band element to a map."
  [band]
  {:file_name       (xml1-> band :band :file_name text)
   :band_short_name (xml1-> band :short_name text)
   :band_long_name  (xml1-> band :long_name text)
   :band_category   (attr band :category)
   :band_product    (attr band :product)
   :band_name       (attr band :name)
   :data_type       (attr band :data_type)
   :data_units      (xml1-> band :data_units text)
   :data_mask       (parse-bitmap band)
   :data_fill       (parse-fill band)
   :data_scale      (parse-scale band)
   :data_range      (parse-range band)})

(defn parse-bands
  "Convert a list of band elements into a list of band maps."
  [root]
  (map parse-band (xml-> root :tile_metadata :bands :band)))

(defn parse-xml
  "Produce a list of bands with tile and scene metadata."
  [xml-path]
  (let [xml-root    (-> xml-path xml/parse zip/xml-zip)
        tile-info   (parse-tile-metadata xml-root)
        scene-info  (parse-scene-metadata xml-root)
        bands       (parse-bands xml-root)
        combo       (map #(merge tile-info scene-info %) bands)]
    (sequence (comp (map +ubid)
                    (map +acquired))
              combo)))

(def chip-spec-keys
  [:ubid :wkt :name :tags
   :chip_x :chip_y
   :pixel_x :pixel_y
   :shift_x :shift_y
   :data_shape
   :data_fill
   :data_mask
   :data_type
   :data_units
   :satellite :instrument :band_name])

(defn build-chip-specs
  "List of bands with scene and chip metadata, useful for chip-spec creation."
  [base-path defaults]
  (let [xml-path (find-xml base-path)]
    (sequence (comp (map #(merge % defaults))
                    (map #(+tags %))
                    (map #(select-keys % chip-spec-keys))
                    (map #(into (sorted-map) %)))
              (parse-xml xml-path))))

(defn file-exists?
  ""
  [band]
  (-> (band :path)
      (io/file)
      (.exists)))

(defn load
  "List of bands with existent raster data, useful for ingest."
  [base-path]
  (let [xml-path (find-xml base-path)]
    (sequence (comp (map #(+path base-path %))
                    (filter file-exists?))
              (parse-xml xml-path))))
