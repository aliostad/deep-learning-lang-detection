;; This file is part of CSound-Clojure.

;;     CSound-Clojure is free software: you can redistribute it and/or modify
;;     it under the terms of the GNU General Public License as published by
;;     the Free Software Foundation, either version 3 of the License, or
;;     (at your option) any later version.

;;     CSound-Clojure is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;     GNU General Public License for more details.

;;     You should have received a copy of the GNU General Public License
;;     along with CSound-Clojure.  If not, see <http://www.gnu.org/licenses/>.

(ns net.slothrop.csound.parse
  (:require [net.slothrop.csound [emit :as cse]]))

(defn orchestra [instruments]
  (cse/emit-orchestra
   (map cse/emit-instrument instruments)))

(defn score [tables notes]
  (str (cse/emit-tables tables)
       (apply cse/emit-notes notes)))

(comment
  (score [[:note :i101 5 4] [:note :i102 5 6]])
  (cse/emit-tables '([1 0 4096 10 1]))
  )