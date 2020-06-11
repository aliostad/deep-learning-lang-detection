;; http://codingdojo.org/cgi-bin/wiki.pl?KataBankOCR

(ns ocr.core
  (:use midje.sweet)
  (:use ocr.characters))

(defn split-ocr-into-digits [ocr]
  (apply map vector (map (partial re-seq #"...") ocr)))


(fact
  (split-ocr-into-digits ["123---"
                          "456+++"]) => [ ["123"
                                           "456"] ["---"
                                                   "+++"]])

(defn stringify-ocr-digit [ocr-digit]
  (str (character-representations ocr-digit)))

(fact 
  (stringify-ocr-digit ["   "
                        "  |"
                        "  |"
                        "   "]) => "1")


(defn stringify-ocr [ocr]
  (apply str (map stringify-ocr-digit (split-ocr-into-digits ocr))))

(fact "OCRs are translated by translating their constituent ocr-digits"
  (stringify-ocr ..ocr..) => "12"
  (provided
    (split-ocr-into-digits ..ocr..) => [..digit-1.. ..digit-2..]
    (stringify-ocr-digit ..digit-1..) => "1"
    (stringify-ocr-digit ..digit-2..) => "2"))

(defn split-ocr-stream [ocr-stream]
  (partition 4 ocr-stream))

(fact "an ocr stream consists of four-line ocrs"
  (split-ocr-stream ["1" "2" "3" "4" "5" "6" "7" "8"]) => [ ["1" "2" "3" "4"] ["5" "6" "7" "8"]])


(defn stringify-ocr-stream [stream]
  (map stringify-ocr (split-ocr-stream stream)))

(fact "OCR streams are translated by translating their constituent ocrs"
  (stringify-ocr-stream ..ocr-stream..) => ["12" "23"]
  (provided
    (split-ocr-stream ..ocr-stream..) => [..ocr-1.. ..ocr-2..]
    (stringify-ocr ..ocr-1..) => "12"
    (stringify-ocr ..ocr-2..) => "23"))
    

(fact "OCR-style account representations can be translated into strings"
  (stringify-ocr-stream ["    _  _     _  _  _  _  _ "
                         "  | _| _||_||_ |_   ||_||_|"
                         "  ||_  _|  | _||_|  ||_| _|"
                         "                           "
                         " _  _     _  _  _  _  _  _ "
                         " _| _||_||_ |_   ||_||_|| |"
                         "|_  _|  | _||_|  ||_| _||_|"             
                         "                           "]) => ["123456789" "234567890"])

