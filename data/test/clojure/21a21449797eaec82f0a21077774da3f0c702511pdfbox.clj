;; *Documentation intended for developers of pdf-stamper*
;;
;; The functions in this namespace are wrappers around PDFBox functionality, and as such every single function is impure (mutating a content stream).

(ns pdf-stamper.text.pdfbox
  (:require
    [pdf-stamper.context :as context]))

(defn- move-text-position-up
  [c-stream amount]
  (.. c-stream (moveTextPositionByAmount 0 amount))
  c-stream)

(defn- move-text-position-down
  [c-stream amount]
  (.. c-stream (moveTextPositionByAmount 0 (- amount)))
  c-stream)

(defn- move-text-position-right
  [c-stream amount]
  (.. c-stream (moveTextPositionByAmount amount 0))
  c-stream)

(defn- move-text-position-left
  [c-stream amount]
  (.. c-stream (moveTextPositionByAmount (- amount) 0))
  c-stream)

(defn- new-line-by-font
  [c-stream font size style context]
  (let [font-height (context/get-font-height font style size context)
        font-leading (context/get-font-leading font style size context)]
    (move-text-position-down c-stream (+ font-height font-leading))))

(defn- set-font
  [c-stream font size style context]
  (let [font-obj (context/get-font font style context)]
    (.. c-stream (setFont font-obj size))
    c-stream))

(defn- set-color
  [c-stream color]
  (let [[r g b] color]
    (doto c-stream
      (.setStrokingColor r g b)
      (.setNonStrokingColor r g b))))

(defn- draw-string
  [c-stream string]
  (.. c-stream (drawString string))
  c-stream)

(defn- add-padding-horizontal
  [c-stream line-length formatting]
  (let [h-align (get-in formatting [:align :horizontal])]
    (condp = h-align
      :center (move-text-position-right c-stream (/ (- (:width formatting) line-length) 2))
      :left c-stream
      :right (move-text-position-right c-stream (- (:width formatting) line-length)))))

(defn- add-padding-vertical
  [c-stream line-height formatting context]
  (let [v-align (get-in formatting [:align :vertical])
        {:keys [font style size] :as font} formatting]
    (condp = v-align
      :center (move-text-position-up c-stream
                                     (+ (/ (- (:height formatting)
                                              line-height)
                                           2)
                                        (context/get-font-descent font
                                                                  style
                                                                  size
                                                                  context)))
      :top (move-text-position-up c-stream (- (:height formatting)
                                              (context/get-font-ascent font
                                                                       style
                                                                       size
                                                                       context)))
      :bottom (move-text-position-up c-stream (context/get-font-descent font
                                                                        style
                                                                        size
                                                                        context)))))

(defn- write-linepart
  [c-stream linepart context]
  (let [{:keys [font size style color]} (:format linepart)]
    (-> c-stream
        (set-font font size style context)
        (set-color color)
        (draw-string (:contents linepart)))))

(defn- write-line
  [c-stream line context]
  (doseq [linepart (map #(update-in % [:contents] (fn [s] (str " " s))) line)]
    (write-linepart c-stream linepart context))
  c-stream)

(defn- write-default-paragraph
  [c-stream formatting paragraph context]
  (let [{:keys [font size style]} formatting]
    (doseq [line paragraph]
      (-> c-stream
          (new-line-by-font font size style context)
          (move-text-position-down (get-in formatting [:spacing :line :above]))
          (write-line line context)
          (move-text-position-down (get-in formatting [:spacing :line :below]))))))

(defn- write-bullet-paragraph
  [c-stream formatting paragraph context]
  (let [{:keys [font style size color bullet-char broken]} formatting
        bullet (str (or bullet-char (char 149)))
        bullet-length (context/get-font-string-width font style size bullet context)]
    (-> c-stream
        (set-font font size style context)
        (set-color color)
        (new-line-by-font font size style context)
        (move-text-position-down (get-in formatting [:spacing :line :above]))
        (#(if-not broken
            (do
              (draw-string % bullet)
              (move-text-position-right % (* bullet-length 2)))
            (move-text-position-right % (* bullet-length 2))))
        (write-line (first paragraph) context))
    (doseq [line (rest paragraph)]
      (-> c-stream
          (move-text-position-down (get-in formatting [:spacing :line :above]))
          (new-line-by-font font size style context)
          (write-line line context)
          (move-text-position-down (get-in formatting [:spacing :line :below]))))
    (move-text-position-left c-stream (* bullet-length 2))
    c-stream))

(defn- write-paragraph-internal
  [c-stream formatting paragraph context]
  (let [paragraph-type (:elem formatting)]
    (cond
      (= paragraph-type :paragraph) (write-default-paragraph c-stream formatting paragraph context)
      (= paragraph-type :bullet) (write-bullet-paragraph c-stream formatting paragraph context)
      (= paragraph-type :number) (write-bullet-paragraph c-stream formatting paragraph context)
      :default (write-default-paragraph c-stream formatting paragraph context))
    c-stream))

(defn- write-paragraph
  [c-stream formatting paragraph context]
  (-> c-stream
      (move-text-position-right (get-in formatting [:indent :all]))
      (move-text-position-down (get-in formatting [:spacing :paragraph :above]))
      (write-paragraph-internal formatting paragraph context)
      (move-text-position-down (get-in formatting [:spacing :paragraph :below]))
      (move-text-position-left (get-in formatting [:indent :all]))))

(defn begin-text-block
  [c-stream]
  (.. c-stream (beginText))
  c-stream)

(defn end-text-block
  [c-stream]
  (.. c-stream (endText))
  c-stream)

(defn set-text-position
  [c-stream x y]
  (.. c-stream (setTextMatrix 1 0 0 1 x y))
  c-stream)

(defn write-paragraphs
  [c-stream formatting paragraphs context]
  (doseq [[p-format paragraph] paragraphs]
    (write-paragraph c-stream p-format paragraph context))
  c-stream)

(defn- optimal-font-size
  [font style start-size string max-width context]
  (let [string-width (context/get-font-string-width font style start-size string context)]
    (if (<= string-width max-width)
      start-size
      (letfn [(decrement-font-size
                [[current-size current-width]]
                [(dec current-size)
                 (context/get-font-string-width font style (dec current-size) string context)])]
        (let [[best-font-size _] (first
                                   (drop-while #(> (second %) max-width)
                                               (iterate decrement-font-size
                                                        [start-size string-width])))]
          best-font-size)))))

(defn write-unparsed-line
  [c-stream line context]
  (let [{:keys [align width height font size style color] :as formatting} (:format line)
        optimal-font-size (optimal-font-size font style size (:contents line) width context)
        line-length (context/get-font-string-width font style optimal-font-size (:contents line) context)
        line-height (context/get-font-height font style optimal-font-size context)]
    (-> c-stream
        (add-padding-horizontal line-length formatting)
        (add-padding-vertical line-height formatting context)
        (set-font font optimal-font-size style context)
        (set-color color)
        (draw-string (:contents line)))))

