(ns simple-sample.Imgproc (:import [org.opencv.core
                                    Mat Core Point Size MatOfDouble MatOfInt MatOfByte MatOfRect Scalar]
                                   [org.opencv.imgcodecs Imgcodecs]
                                   [org.opencv.imgproc Imgproc]
                                   [java.awt.image BufferedImage]
                                   [javax.swing ImageIcon])
    (:require [simple-sample.Core :as ssC]))

;
(use 'seesaw.core)

(native!) ;this will tell to seesaw to make thing native for the OS, for example thing for MAC OS

(defn toHSV
  "take a matrix object and return a new one in Hue Saturation Value (HSV) color model."
  [mat]
  (let [new-mat (Mat.)
        _ (Imgproc/cvtColor mat new-mat Imgproc/COLOR_BGR2HSV)]
    new-mat))

;
(defn toGray
  "take a matrix object and return a new one in Gray color."
  [mat]
  (let [new-mat (Mat.)
        _ (Imgproc/cvtColor mat new-mat Imgproc/COLOR_BGR2GRAY)]
    new-mat))

;
(defn toLab
  "take a matrix object and return a new one in Lab color model."
  [mat]
  (let [new-mat (Mat.)
        _ (Imgproc/cvtColor mat new-mat Imgproc/COLOR_BGR2Lab)]
    new-mat))

;
(defn apply-upper-threshold
  "A function that takes as argumenst a matrix object and an integer n.
  It returns a different matrix object with apply a threshold from n to 255
  NOTE: you SHOULD use a gray matrix"
  [mat n]
  (let [new_mat (Mat.)
        _ (Imgproc/threshold  mat new_mat n 255 Imgproc/THRESH_BINARY)]
    new_mat))

;
(defn gaussian-blur
  [mat square-side sigma]
  (let [new-mat (Mat.)
        _ (Imgproc/GaussianBlur mat new-mat (Size. square-side square-side) sigma)]
    new-mat))

(defn median-blur
  [mat sigma]
  (let [new-mat (Mat.)
        _ (Imgproc/medianBlur mat new-mat sigma)]
    new-mat))

;
(defn find-contours
  [mat]
  (let [new-mat (Mat.)
        _ (.copyTo mat new-mat)
        list-of-point (java.util.ArrayList.)
        hierarchy-mat (Mat.)
        _ (Imgproc/findContours
           new-mat
           list-of-point
           hierarchy-mat
           Imgproc/RETR_TREE
           Imgproc/CHAIN_APPROX_NONE
           (Point.))]
    [new-mat list-of-point hierarchy-mat]))

(defn draw-contours
  ([mat array-list n]
   (let [new-mat (Mat.)
         _ (.copyTo mat new-mat)
         _ (if (coll? n)
             (doseq [x n]
               (Imgproc/drawContours new-mat array-list x (Scalar. 0 0 255) 2))
             (Imgproc/drawContours new-mat array-list n (Scalar. 0 0 255) 2))]
     new-mat))
  ([mat array-list]
   (let [new-mat (Mat.)
         _ (.copyTo mat new-mat)
         _ (doseq [n (range (count array-list))] (Imgproc/drawContours new-mat array-list n (Scalar. 0 0 255) 2))]
     new-mat)));; NOTE: FOR SOME REASON MAT SEAMS TO DOESN'T WORKING


;; This functions are used to extract the values of next, previuos, first-child and parent contour
;; from the hierchical matrix. It refer to the explanation relative to Find contours given in
;; http://docs.opencv.org/trunk/d9/d8b/tutorial_py_contours_hierarchy.html

(defn get-next
  "Return the first element of the passed collection.
  It is used in the function that manage the hierarchila matrix, whose rows are
  (theoretically) [next previous child parent]"
  [coll]
  (nth coll 0))

(defn get-previous
  "Return the second element of the passed collection.
  It is used in the function that manage the hierarchila matrix, whose rows are
  (theoretically) [next previous child parent]"
  [coll]
  (nth coll 1))

;
(defn get-child
  "Return the third element of the passed collection.
  It is used in the function that manage the hierarchila matrix, whose rows are
  (theoretically) [next previous child parent]"
  [coll]
  (nth coll 2))

;
(defn get-parent
  "Return the fourth element of the passed collection.
  It is used in the function that manage the hierarchila matrix, whose rows are
  (theoretically) [next previous child parent]"
  [coll]
  (nth coll 3))

(defn find-3sons
  [contours h-mat]
  "This function take as input a hierarchical matrix and return a sequence
  with all indexes of the squares with 3 hierarchical levels.
  TO BE IMPROVED: it is not write functionally"
  (let [only-son (fn [n] (and
                          (= (get-next      n) -1)
                          (= (get-previous  n) -1)
                          (= (get-child     n) -1)
                          (not= (get-parent n) -1)))
        father-son (fn [n] (and
                            (= (get-next      n) -1)
                            (= (get-previous  n) -1)
                            (not= (get-child  n) -1)
                            (not= (get-parent n) -1)))
        candidate (partition 4 (read-string (.dump h-mat)))
        get-son (fn [])
        small-squares-index  (keep-indexed #(if (only-son %2) %1) candidate)
        small-squares        (mapv          #(nth candidate %) small-squares-index)
        candidate-medium-square-index (mapv #(get-parent %) small-squares)
        medium-squares-index  (filter #(father-son (nth candidate %)) candidate-medium-square-index)
        medium-squares       (mapv #(nth candidate %) medium-squares-index)
        big-squares-index    (mapv #(get-parent %) medium-squares)
        big-square           (mapv #(nth candidate %) big-squares-index)
        small-squares-index (mapv #(get-child %) medium-squares)
        terne-vector (mapv
                      (fn [b m s] [[(.rows (nth contours b)) b]
                                   [(.rows (nth contours m)) m]
                                   [(.rows (nth contours s)) s]])
                      big-squares-index medium-squares-index small-squares-index)
        ;terne-vector (filter (fn [[[b b-idx] [m m-idx] [s s-idx]]]
        ;                       (and (<= 1.26 (/ b m) 1.54)
        ;                            (<= 1.50 (/ m s) 1.83))) terne-vector)
        ;terne-vector (mapv (fn [[[b b-idx] [m m-idx] [s s-idx]]] [b-idx m-idx s-idx]) terne-vector)
        ]
    (concat big-squares-index medium-squares-index small-squares-index)))
;
(defn adaptive-threshold
  [mat]
  (let [new-mat (Mat.)
        _ (Imgproc/adaptiveThreshold
           (toGray mat)
           new-mat
           255
           Imgproc/ADAPTIVE_THRESH_MEAN_C
           Imgproc/THRESH_BINARY
           11
           2)]
    new-mat))
;
(defn find-3squares
  [mat]
  (let [[new-mat contours h-mat] (find-contours (adaptive-threshold mat))
        squares-list (find-3sons contours h-mat)]
    (if (nil? squares-list)
      (draw-contours mat contours 0)
      (draw-contours mat contours squares-list))
    ))
