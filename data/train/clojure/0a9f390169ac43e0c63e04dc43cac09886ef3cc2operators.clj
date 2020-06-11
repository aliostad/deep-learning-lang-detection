;   Copyright (c) 2008, Erik Soehnel All rights reserved.
;
;   Redistribution and use in source and binary forms, with or without
;   modification, are permitted provided that the following conditions
;   are met:
;
;     * Redistributions of source code must retain the above copyright
;       notice, this list of conditions and the following disclaimer.
;
;     * Redistributions in binary form must reproduce the above
;       copyright notice, this list of conditions and the following
;       disclaimer in the documentation and/or other materials
;       provided with the distribution.
;
;   THIS SOFTWARE IS PROVIDED BY THE AUTHOR 'AS IS' AND ANY EXPRESSED
;   OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;   WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;   ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
;   DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
;   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
;   GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
;   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
;   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(ns hoeck.rel.operators)

;; relational algebra operations

(defn type-dispatch [thing & opts]
  (type thing))

(defn op-dispatch-fn [relation & rest]
  (:relation-tag ^relation))

(defn join-dispatch [R r, S s]
  (let [tag-r (:relation-tag ^R)
        tag-s (:relation-tag ^S)]
    (or (or (nil? tag-r) (nil? tag-s))
        (and (= tag-r tag-s) tag-r)
        :clojure)))

(defn two-op-dispatch-fn [R, S & rest]
  (let [tag-r (:relation-tag ^R)
        tag-s (:relation-tag ^S)]
    (or (or (nil? tag-r) (nil? tag-s))
        (and (= tag-r tag-s) tag-r)
        :clojure)))

(defmulti project op-dispatch-fn)
(defmulti select op-dispatch-fn)
(defmulti rename op-dispatch-fn)
(defmulti xproduct two-op-dispatch-fn)

(defmulti join join-dispatch) ;; natural-join
(defmulti outer-join join-dispatch) ;; right-outer-join
(defmulti full-outer-join join-dispatch)
(defmulti fjoin op-dispatch-fn) ;; join with a custom function

(defmulti union two-op-dispatch-fn)
(defmulti difference two-op-dispatch-fn)
(defmulti intersection two-op-dispatch-fn)
(defmulti order-by op-dispatch-fn)

;; constructor methods
(defmulti make-relation type-dispatch)
(defmulti make-index type-dispatch)

;; misc functions
(defn fields [R] (:fields ^R))
(defn index [R] (:index ^R))
(defn field? [form] (keyword? form))
(defn relation? [x] (if (:relation-tag ^x) true))


