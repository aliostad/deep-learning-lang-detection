;; This module will convert data files into csv files. We are using clojure 1.3 so we need some
;; I/O and String functions.
(ns rundata.core
  (:require [clojure.string :as str]
            [clojure.java.io :as io]))

;; First we need a function that splits up a line of text from the log file into a list of fields
;; The file has fixed width fields with the tilde character (`~`) used as a delimiter. A regular
;; expression should do the trick. We will also need to trim the resulting whitespace out of each
;; field so a simple `map` call does that.

(defn split-line
  "Splits a line of text using a ~ delimiter and trims each field returning a list of each field."
  [line]
  (let [v (str/split line #" *~")]
    (map #(str/trim %) v)))

;; Now we need a function to read from the log file and output a comma-separated values (csv) file.
;; The `with-open` macro can be used to manage the buffered file reader and writer. This macro handles
;; the management of the resource making sure that it is closed after we are finished with it. The call
;; to `line-seq` creates a lazy sequence of lines from the log file and we then call the `split-line` function
;; on each line outputing a comma as a delimiter and adding a newline character at the end of each line.
;;
;; The act of writing to the output file is a side-effect which means that this function is not pure.
;; For this reason, we need to use a `doseq` call for the looping through the file as opposed to `for`.
;;
;; We should note that this function is pretty naive in how it creates csv. It doesn't, for example,
;; deal with the case where the field has a comma or a double quote in it. The csv spec requires that
;; these are escaped. We haven't dealt with that because we don't think we'll have to worry about it
;; for the data files we're dealing with. If that changes we can revisit that. It is a simple matter
;; of changing the `map` call in the `split-line` function probably.

(defn output-csv
  "Opens the specified data-file and outputs a {data-file}.csv file in the same location."
  [data-file]
  (with-open [outfile (io/writer (str data-file ".csv"))]
    (with-open [infile (io/reader data-file)]
      (let [lines (line-seq infile)]
        (doseq [line lines]
          (.write outfile (str (str/join ", " (split-line line)) "\n")))))))

;; Finally, we'll add a function to take a whole directory of files and convert the lot of them to
;; csv files. The function takes a string and creates a `java.io.File` from it. We could check that
;; it is a directory and it exists and so forth but we didn't bother.
;;
;; The next line is a loop through the files in the specified directory with a call to `output-csv` on
;; each file. Since `output-csv` is not a pure function we need to use `doseq` on it.
;;
;; The function does not do any checking of the files to see that they are data files. It will just run
;; on every file in the directory no matter if it is binary or whatever. We could fix this by implementing
;; the `FileFilter` interface.

(defn convert-directory
  "Converts all the files in the specified directory into csv files."
  [dir]
  (let [files (seq (.listFiles (java.io.File. dir)))]
    (doseq [file files] (output-csv file))))
