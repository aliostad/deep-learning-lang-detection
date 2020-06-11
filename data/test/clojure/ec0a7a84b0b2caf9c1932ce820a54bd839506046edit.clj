(ns circle.edit
  (:require [circle.dispatch :as dispatch]))

(defn delete-char-at [v i]
  (if (= i (count v))
    (subvec v 0 (dec i))
    (apply conj (subvec v 0 (dec i)) (subvec v i))))

(defn mush [[a b]]
  (if (seq b)
    [(apply conj a b)]
    [a]))

(defn delete-line [v i]
  (let [head (subvec v 0 (dec i))
        altered (mush (subvec v (dec i) (inc i)))
        altered-head (apply conj head altered)]
    (if (< (inc i) (count v))
      (let [tail (subvec v (inc i))]
        (apply conj altered-head tail))
      altered-head)))

(defn delete [_]
  (let [line-number (dispatch/receive :state-get-cursor-line)]
    (if (= 0 (dispatch/receive :state-get-cursor-x))
      (when (> (count (dispatch/receive :state-get-buffer)) 1)
        (dispatch/fire :state-delete-line delete-line))
      (dispatch/fire :state-delete-char-before-cursor
                     (delete-char-at ((dispatch/receive :state-get-buffer) (dispatch/receive :state-get-cursor-line))
                                     (dispatch/receive :state-get-cursor-x))))))

(defn add-newline [v x]
  (if (= x (count v))
    [v []]
    [(subvec v 0 x) (subvec v x)]))

(defn adding-newline-at-end-of-document? [buffer line]
  (= (inc line) (count buffer)))

(defn new-document-with-modification [start-of-document buffer line]
  (apply conj
         start-of-document
         (subvec buffer (inc line))))

(defn add-newline-at-cursor [buffer line x]
  (let [start-of-document (apply conj
                                 (subvec buffer 0 line)
                                 (add-newline (buffer line) x))]
    (if (adding-newline-at-end-of-document? buffer line)
      start-of-document
      (new-document-with-modification start-of-document buffer line))))

(defn add-to-eol? [v i]
  (= i (count v)))

(defn add-char-at-eol [v x]
  (conj v x))

(defn add-char-at [v i x]
    (apply conj (conj (subvec v 0 i) x) (subvec v i)))

(defn add-char-to-line-at [v i x]
  (if (add-to-eol? v i)
    (add-char-at-eol v x)
    (add-char-at v i x)))

(defn newline? [c]
  (= c \newline))

(defn character? [c]
  (Character/isDefined c))

(defn add-char [c]
  (cond
   (newline? c) (dispatch/fire :state-modify-buffer add-newline-at-cursor)
   (character? c) (let [buffer (dispatch/receive :state-get-buffer)
                        line-num (dispatch/receive :state-get-cursor-line)
                        x (dispatch/receive :state-get-cursor-x)
                        new-line (add-char-to-line-at (buffer line-num) x c)]
                    (dispatch/fire :state-modify-buffer-line new-line))))
