(ns excelize.core
  (require [clojure.java.io :as io]
           [clojure.data.csv :as csv]
           [clj-excel.core :as excel])
  (import (java.io ByteArrayInputStream
                   ByteArrayOutputStream
                   FileInputStream
                   InputStreamReader)))

(defn csv->rows
  "Takes csv file object and convert it to rows."
  [file encoding]
  (with-open [stream (io/reader (InputStreamReader. (FileInputStream. file) encoding))]
    (try
      (doall
        (csv/read-csv stream))
      (catch Exception e nil))))

(defn create-excel
  "Takes rows (and optional arguments format/name), create excel from them and
  return excel as a stream."
  [& {:keys [file encoding name format]}]
  (when-let [rows (csv->rows file encoding)]
    (let [workbook (if (= format "hssf")
                     (excel/workbook-hssf)
                     (excel/workbook-xssf))
          stream (ByteArrayOutputStream.)]
      (do
        (->
          (excel/build-workbook workbook {name rows})
          (excel/save stream))
        (ByteArrayInputStream. (.toByteArray stream))))))
