(ns parser.constantpool
  (:use [parser.file])
  (:use [parser.convert]))

(defn utf8-info [input-stream]
  (let [length (hex-to-int (read-next-bytes-as-hex-str input-stream 2))
        hex-value (read-next-bytes-as-hex-str input-stream length)]
    {:utf8-info {:value (hex-to-utf8 hex-value)}}))

(defn constant-count [input-stream]
  (let [hex (read-next-bytes-as-hex-str input-stream 2)]
    (dec (hex-to-int hex))))

(defmacro register-const-type
  ([const-type fields]
     `(register-const-type ~const-type ~hex-to-int ~fields))
  ([const-type hex-convert fields]
     (let [const-type-sym (symbol const-type)
           const-type-key (keyword const-type)
           input-stream (symbol "input-stream")]
       `(defn ~const-type-sym [~input-stream]
          (let
              [~@(reduce concat
                         (map (fn [[field-key bytes]]
                                [(symbol (name field-key))
                                 `(read-next-bytes-as-hex-str ~input-stream ~bytes)])
                              fields))]
            {~const-type-key
             ~(reduce conj (map
                            (fn [[field-key _]]
                              `{~field-key (~hex-convert ~(symbol (name field-key)))})
                            fields))})))))

(defn utf8-info [input-stream]
  (let [length (hex-to-int (read-next-bytes-as-hex-str input-stream 2))
        hex-value (read-next-bytes-as-hex-str input-stream length)]
    {:utf8-info {:value (hex-to-utf8 hex-value)}}))

(register-const-type class-info [[:name-index 2]])
(register-const-type methodref-info [[:class-index 2] [:name-and-type-index 2]])
(register-const-type fieldref-info [[:class-index 2] [:name-and-type-index 2]])
(register-const-type interface-methodref-info [[:class-index 2] [:name-and-type-index 2]])
(register-const-type string-info [[:string-index 2]])
(register-const-type integer-info [[:value 4]])
(register-const-type float-info hex-to-float [[:value 4]])
(register-const-type long-info hex-to-long [[:value 8]])
(register-const-type double-info hex-to-double [[:value 8]])
(register-const-type name-and-type-info [[:name-index 2] [:descriptor-index 2]])

(defmulti parse-const-type #(read-next-bytes-as-hex-str % 1))
(defmethod parse-const-type "07" [input-stream] (class-info input-stream))
(defmethod parse-const-type "09" [input-stream] (fieldref-info input-stream))
(defmethod parse-const-type "0a" [input-stream] (methodref-info input-stream))
(defmethod parse-const-type "0b" [input-stream] (interface-methodref-info input-stream))
(defmethod parse-const-type "08" [input-stream] (string-info input-stream))
(defmethod parse-const-type "03" [input-stream] (integer-info input-stream))
(defmethod parse-const-type "04" [input-stream] (float-info input-stream))
(defmethod parse-const-type "05" [input-stream] (long-info input-stream))
(defmethod parse-const-type "06" [input-stream] (double-info input-stream))
(defmethod parse-const-type "0c" [input-stream] (name-and-type-info input-stream))
(defmethod parse-const-type "01" [input-stream] (utf8-info input-stream))

(defn constant-pool [input-stream]
  (let [const-count (constant-count input-stream)]
    (loop [result {}
           ref-id 1
           long-double-count 0]
      (if (= (+ (- ref-id 1) long-double-count) const-count)
        {:constant-pool result}
        (let [const-type (parse-const-type input-stream)
              const-type-with-id {(keyword (str ref-id)) const-type}
              is-long-double? (or (contains? const-type :long-info)
                                  (contains? const-type :double-info))]
          (recur (conj result const-type-with-id)
                 (inc ref-id)
                 (if is-long-double? (inc long-double-count) long-double-count)))))))
           