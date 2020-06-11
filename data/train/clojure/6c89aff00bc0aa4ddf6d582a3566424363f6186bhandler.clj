(ns example.handler
  (:require
    [clojure.java.io :as io]
    [clojure.string :as string]
    [clojure.tools.logging :as log]
    [ring.middleware.multipart-params.temp-file :refer [temp-file-store]]
    [com.stuartsierra.component :as component])
  (:import
    [javax.imageio ImageIO]
    [java.io InputStream]
    [org.apache.commons.io.input BoundedInputStream TeeInputStream]))

(defn ok [{:keys [components] :as request}]
  {:status 200 :body (pr-str request)})

(defn wrap-components [handler components]
  (fn [request]
    (handler (assoc request :components components))))

(defn bounded-input-stream
  "Return a stream that will return bytes only up to the supplied maximum length."
  [^InputStream stream ^long max-length]
  (BoundedInputStream. stream max-length))

(defn bounded-file-store [maximum-length]
  (let [store (temp-file-store)]
    (fn [item]
      (let [item (store (update-in item [:stream] bounded-input-stream (inc maximum-length)))]
        (if (> (:size item) maximum-length)
          (throw (Exception. "Overlength file"))
          item)))))

; (BoundedInputStream. (io/input-stream (.getBytes "12" "UTF-8")) 1)

(defrecord Handler [db]
  component/Lifecycle
  (start [this]
    (assoc this :handler-fn (-> ok (wrap-components this))))
  (stop [this]
    (dissoc this :handler-fn)))

;; -Djava.awt.headless=true
(defn image-info [filename]
  (with-open [istream (ImageIO/createImageInputStream (io/as-file filename))]
    (when-let [reader (some-> istream (ImageIO/getImageReaders) (iterator-seq) (first))]
      (try
        (.setInput reader istream)
        { :format (string/lower-case (.getFormatName reader)) ;; jpeg, png, bmp, gif
          :width  (.getWidth reader (.getMinIndex reader))
          :height (.getHeight reader (.getMinIndex reader)) }
        (finally
          (.dispose reader))))))
