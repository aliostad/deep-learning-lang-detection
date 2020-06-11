(ns photodb-server.render)

(require '[photodb-server.manage :as manage])

(defn render-images-html
  "Renders html with all images that match given set of tags. image-type, type of images.
  output-stream to which html will be written."
  [tags image-type output-stream]
  (let [images (manage/images-find tags)]
    (with-open [album-writer (clojure.java.io/writer output-stream)]
      (.write album-writer "<html>\n\t<head>\n\t</head>\n\t<body align='center'>\n")
      (doseq [image images]
        (let [image-id (:id image)
              image-path (str "/render/photo?id=" image-id "&type=" image-type)]
          (.write album-writer (str
                                 "\t\t<img src='" image-path
                                 "' style='max-width:1024px;max-height:800px;width:auto;height:auto;'"
                                 "></br></br></br></br></br>\n"))))
      (.write album-writer "\t</body>\n</html>"))))
