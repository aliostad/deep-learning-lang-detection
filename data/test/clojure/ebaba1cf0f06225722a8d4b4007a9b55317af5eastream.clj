(ns cellular.stream
  (:use [testa.core :only (suite)])
  (:require [cellular.core :as cell])
  (:import [java.io StringReader]))

(suite
  "stream"
  (:fact plain
         (let [rdr (StringReader. "a")]
           (vec (cell/reader->stream rdr)))
         :is
         [{:result \a}
          {:result :eof}])
  (:fact str
         (vec (cell/str->stream "a"))
         :is
         [{:result \a}
          {:result :eof}])
  (:fact empty
         (vec (cell/str->stream ""))
         :is
         [{:result :eof}])
  (:fact offset
         (vec (cell/offset-stream (cell/str->stream "abc")))
         :is
         [{:offset 0 :result \a}
          {:offset 1 :result \b}
          {:offset 2 :result \c}
          {:offset 3 :result :eof}])
  (:fact newline
         (vec (cell/position-stream (cell/str->stream "a\nb")))
         :is
         [{:row 1, :column 1, :result \a}
          {:row 1, :column 2, :result \newline}
          {:row 2, :column 1, :result \b}
          {:row 2, :column 2, :result :eof}]))
