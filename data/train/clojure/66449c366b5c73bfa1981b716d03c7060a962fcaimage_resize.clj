(ns wedding-photos.image-resize
  (:use [clojure.java.io :only [as-file]])
  (:import [javax.imageio.ImageIO] 
           [java.awt.image.BufferedImage]
           [java.io.ByteArrayOutputStream]))



(defn make-thumbnail [input-stream width]
  (let [img (javax.imageio.ImageIO/read input-stream)
        imgtype (java.awt.image.BufferedImage/TYPE_INT_ARGB)
        width (min (.getWidth img) width)
        height (* (/ width (.getWidth img)) (.getHeight img))
        simg (java.awt.image.BufferedImage. width height imgtype)
        g (.createGraphics simg)
        output-stream (java.io.ByteArrayOutputStream.)]
    (.drawImage g img 0 0 width height nil)
    (.dispose g)
    
    (javax.imageio.ImageIO/write simg "png" output-stream)
    (.byteArray output-stream)))

