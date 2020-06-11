(ns think.image.io
  (:import [java.awt.image BufferedImage]
           [javax.imageio ImageIO ImageWriter IIOImage]
           [javax.imageio.plugins.jpeg JPEGImageWriteParam]
           [java.io OutputStream]))


(defn get-image-writer
  ^ImageWriter [format-name]
  (let [iter (ImageIO/getImageWritersByFormatName format-name)]
    (when (.hasNext iter)
      (.next iter))))


(defn write-image-to-stream
  [buffered-image format output-stream & {:keys [lossy-quality]
                                          :or {lossy-quality 0.95}}]
  (let [^BufferedImage buffered-image buffered-image
        ^OutputStream output-stream output-stream
        ^String format format]
   (if (= format "PNG")
     (ImageIO/write buffered-image format output-stream)
     (let [quality (float lossy-quality)
           writer (get-image-writer "JPG")
           ^JPEGImageWriteParam params (.getDefaultWriteParam writer)]
       (doto params
         (.setCompressionMode JPEGImageWriteParam/MODE_EXPLICIT)
         (.setCompressionQuality quality))
       (.setOutput writer (ImageIO/createImageOutputStream output-stream))
       (.write writer nil (IIOImage. buffered-image nil nil) params)))))
