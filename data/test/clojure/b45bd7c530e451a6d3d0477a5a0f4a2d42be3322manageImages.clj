(ns NewCssSprite.manageImages
  (:use  NewCssSprite.strTools)
  (:import (javax.imageio ImageIO)
           (java.awt      Color
                          image.BufferedImage)))

(defn SumPicsHeight1 
  [initialSum SortedPictures]
  "returns the sum of all the pictures height"
    (if (empty? SortedPictures)
      initialSum
    (recur (+ initialSum (last (:dimensions (first SortedPictures)))) (rest SortedPictures))      
    ) )

(defn getMaxPicWidth [SortedPictures]
  "gets the max width of a picture"
   (first ( :dimensions (first SortedPictures)))
  ) 
(defn  collecte-imgs
  "Given a directory, return a map of all png images with a buffered image and dimensions"
  [dir]
  (let [dir-name (file-str dir)] "get the dir name"
      (map
        (fn [image]
          (let [imgIO (ImageIO/read image)]
            {:buffered-image imgIO :path (.replaceAll (.getPath image) dir "")   :dimensions [(.getWidth imgIO) (.getHeight imgIO)] :x 0 ,:y 0}))
        (filter
          #(re-matches #"(?i).*\.png$" (.getName %1))
          (file-seq dir-name)))))




(defn DoesPicFit[ x pic]
  (and (>= ( x :width) (first (pic :dimensions))) (>= (x :height) (last (pic :dimensions)))))
  


(defn combine-images 
  "Given the images , create a sprite png at the output location"
  [images  output]   		
  (let [MaxYPic (:bottomY (last (sort-by :bottomY images )) )
        hi  (+ 0 ( :y (last (sort-by :y  images))) (last ( :dimensions (last (sort-by :dimensions images)))))
        output-image      (BufferedImage. (getMaxPicWidth images) MaxYPic BufferedImage/TYPE_INT_ARGB)
        graphics          (.createGraphics output-image)]
     (doseq [image images]
          (.drawImage graphics (:buffered-image image) (:x image)  (:y image)  nil))
      (ImageIO/write output-image "png" (file-str output)) images))



(defn GetBestSpace [pic spacesList]
  (let [currspace (first spacesList)]
  (do  
    (if (DoesPicFit currspace pic)
        (conj nil currspace );true
        (recur  pic (rest spacesList));false
    
    ))))


   


(defn PlacePic [pic BestSpace]
  
  (
    let[ SpaceA {:x(BestSpace :x)
                 :y(+ (BestSpace :y) (last (pic :dimensions)) )
                 :width (BestSpace :width ) 
                 :height (- (BestSpace :height ) (last (pic :dimensions)))}
        SpaceB {:x (+(BestSpace :x) (first (pic :dimensions)))
                :y (BestSpace :y)
                :width (-(BestSpace :width)(first (pic :dimensions)))
                :height (last (pic :dimensions))}
        NewPic (assoc pic  
                         :x(BestSpace :x) 
                         :y(BestSpace :y)
                          :bottomY (+ (BestSpace :y) (last (pic :dimensions) )))
        returnMap {:Pic NewPic   :SpaceA nil  :SpaceB nil}]
    
   
     (assoc returnMap
         :SpaceA (if(and (< 0 (SpaceA :height ))(< 0 (SpaceA :width) )) SpaceA nil) 
         :SpaceB (if(and (< 0 (SpaceB :height ))(< 0 (SpaceB :width))) SpaceB nil))

  )
  
  )

       
 (defn updatList [OldList newSpaceA newSpaceB BestOpenSpace]
   "delets the used space and return a new list with the new spaces "
   (let [
         ;filter the current best space out of the space list. it is no longer a valid space
         ChangedList (filter (fn [space] 
                                      (and  
                                      (not= (space :x )(BestOpenSpace :x ))
                                      (not= (space :y )(BestOpenSpace :y )))
                                )OldList) ]
     ; add the new spaces into  the spacelist , sort out the nils if they exist
    (sort-by :width (filter (fn [space]
                              (not (nil? space)))
                            (conj ChangedList  newSpaceA newSpaceB)))
     ))
 

( defn getBounds [SpaceList SortedPics LocatedPictures]
  (if (empty? SortedPics)
	; trues
	LocatedPictures 
	;false	
 (let [nextPic (first SortedPics )
       ;gets the best open space , set the used flag to 1 
       BestOpenSpace (first (GetBestSpace nextPic SpaceList))
       newSpacesNpic (PlacePic nextPic BestOpenSpace)
       newSpaceA(:SpaceA newSpacesNpic)
       newSpaceB(:SpaceB  newSpacesNpic)
       updatedSPaceList(updatList SpaceList newSpaceA newSpaceB BestOpenSpace) ]
       
   
   
    
   (recur updatedSPaceList (rest SortedPics) (conj LocatedPictures (:Pic newSpacesNpic)) )
	)
 )
)
