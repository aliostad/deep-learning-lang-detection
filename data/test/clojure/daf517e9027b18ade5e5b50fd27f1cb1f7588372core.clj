(ns clj-protobuf.core
  (:import (com.google.protobuf CodedOutputStream ByteString)))

(defn protobuf-load [data] 5)

(defn find-first
  [schema name type]
  (some #(when (and (= name (:name %)) (= type (:type %))) %) schema))

(def protobuf-compute-size)

(defn protobuf-compute-attribute-size
  [type tag value]
  (case type
    :double (CodedOutputStream/computeDoubleSize tag value)
    :float (CodedOutputStream/computeFloatSize tag value)
    :int32 (CodedOutputStream/computeInt32Size tag value)
    :int64 (CodedOutputStream/computeInt64Size tag value)
    :uint32 (CodedOutputStream/computeUInt32Size tag value)
    :uint64 (CodedOutputStream/computeUInt64Size tag value)
    :sint32 (CodedOutputStream/computeSInt32Size tag value)
    :sint64 (CodedOutputStream/computeSInt64Size tag value)
    :fixed32 (CodedOutputStream/computeFixed32Size tag value)
    :fixed64 (CodedOutputStream/computeFixed64Size tag value)
    :bool (CodedOutputStream/computeBoolSize tag value)
    :string (CodedOutputStream/computeStringSize tag value)
    :bytes (CodedOutputStream/computeBytesSize tag (ByteString/copyFrom value))
    nil
    ))

(defn protobuf-compute-enum-size
  [schema enum-name tag value]
  (let [enum-schema (find-first schema enum-name :enum)
        enum-schema-entry (some #(when (= (name value) (:name %)) %) (:content enum-schema))]
    (if (not-empty enum-schema-entry) (CodedOutputStream/computeEnumSize tag (:tag enum-schema-entry)))))

(defn protobuf-compute-message-size
  [schema message-name tag value]
  (let [message-schema (find-first schema message-name :message)]
    (let [message-size (protobuf-compute-size (vector message-schema) message-name value)]
      (+ (CodedOutputStream/computeTagSize tag)
         (CodedOutputStream/computeRawVarint32Size message-size)
         message-size))))

(defn protobuf-compute-size
  [schema message-name message]
  (let [message-schema (some #(when
                               (= message-name (:name %))
                               (:content %))
                             schema)]
    (reduce +
            (map (fn [attribute-key]
                   (let [attribute-schema (some #(when (= (name attribute-key) (:name %)) %) message-schema)
                         type (:type attribute-schema)
                         tag (:tag attribute-schema)
                         value (attribute-key message)]
                     (or (protobuf-compute-attribute-size type tag value)
                         (protobuf-compute-enum-size message-schema type tag value)
                         (protobuf-compute-message-size message-schema type tag value))))
                 (keys message)))))

(defn protobuf-dump-attribute
  [type tag value stream]
  (not (case type
         :double (.writeDouble stream tag value)
         :float (.writeFloat stream tag value)
         :int32 (.writeInt32 stream tag value)
         :int64 (.writeInt64 stream tag value)
         :uint32 (.writeUInt32 stream tag value)
         :uint64 (.writeUInt64 stream tag value)
         :sint32 (.writeSInt32 stream tag value)
         :sint64 (.writeSInt64 stream tag value)
         :fixed32 (.writeFixed32 stream tag value)
         :fixed64 (.writeFixed64 stream tag value)
         :bool (.writeBool stream tag value)
         :string (.writeString stream tag value)
         :bytes (.writeBytes stream tag (ByteString/copyFrom value))
         true
         )))

(defn protobuf-dump-enum
  [schema enum-name tag value stream]
  (let [enum-schema (find-first schema enum-name :enum)
        enum-schema-entry (some #(when (= (name value) (:name %)) %) (:content enum-schema))]
    (.writeEnum stream tag (:tag enum-schema-entry))))

(defn protobuf-dump-stream
  [schema message-name message stream]
  (let [message-schema (some #(when
                               (= message-name (:name %))
                               (:content %))
                             schema)]
    (doall (map (fn [x]
                  (let [attribute-name (name x)
                        attribute-schema (some #(when (= attribute-name (:name %)) %) message-schema)]
                    (or (protobuf-dump-attribute (:type attribute-schema) (:tag attribute-schema) ((keyword attribute-name) message) stream)
                        (protobuf-dump-enum message-schema (:type attribute-schema) (:tag attribute-schema) ((keyword attribute-name) message) stream))))
                (keys message)))))

(defn protobuf-dump
  [schema message-name message]
  (let [buffer (byte-array (protobuf-compute-size schema message-name message))
        output-stream (CodedOutputStream/newInstance buffer)]
    (do
      (protobuf-dump-stream schema message-name message output-stream)
      (seq buffer))))
