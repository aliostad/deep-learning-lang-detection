(ns NewCssSprite.core 
  (:use  (NewCssSprite writeCss manageImages ))
  )
 
           

(defn generate-css-sprite
  "generate it"
  [image-dir]
  
 (def img-coll (reverse (sort-by :dimensions(collecte-imgs image-dir))))
 (def sprite (getBounds [{:x 0 :y 0 :width (getMaxPicWidth img-coll) :height (SumPicsHeight1 0 img-coll) }] img-coll [])   )
 (combine-images sprite "sprite.png")
 (writeToFile sprite  )
 (print "all done :D")
 )


(defn -main
  "get the directory of pictures as argumnet and call the function which does it all"
  ; make it run with (-main "images//test#)  when #  is 1-5
  [& args]

      (apply generate-css-sprite args))
