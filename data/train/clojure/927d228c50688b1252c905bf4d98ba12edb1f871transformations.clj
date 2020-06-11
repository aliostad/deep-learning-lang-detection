(ns bridge.transformations)

(defn key-by [stream key-selector-object]
  "Creates a keyed stream that uses the given key-selector to partition the data stream"
  (.keyBy stream key-selector-object))

(defn apply-map [stream map-object]
  "Applies a map function on the data stream. An object that implements org.apache.flink.api.common.functions.
  MapFunction is required"
  (.map stream map-object))

(defn apply-flat-map [stream flat-map-object]
  "Applies a flat map function to the data stream. An object that implements org.apache.flink.api.common.functions.
  FlatMapFunction is required"
  (.flatMap stream flat-map-object))

(defn apply-filter [stream filter-object]
  "Applies a filter function to the data stream. An object that implements org.apache.flink.api.common.functions.
  FilterFunction is required"
  (.filter stream filter-object))

(defn apply-window [stream window-object]
  "Applies a window function to the data stream. An object that implements org.apache.flink.api.common.functions.
  WindowFunction is required"
  (.apply stream window-object))

(defn apply-reduce [stream reduce-object]
  "Applies a reduce function to the data stream. An object that implements org.apache.flink.api.common.functions.
  ReduceFunction is required"
  (.reduce stream reduce-object))
