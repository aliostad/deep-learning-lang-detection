(ns controller.android.gyro
  (:require [taoensso.timbre :refer-macros [info]]
            [re-frame.core :refer [dispatch]]
            [taoensso.timbre :refer-macros [spy]]))

(def device-event-emitter (.-DeviceEventEmitter (js/require "react-native")))
(def sensor-manager (.-SensorManager (js/require "NativeModules")))

(defn hook-gyro! [millisec-delay listener]
  (do
    (.addListener device-event-emitter "Gyroscope" listener)
    (.startGyroscope sensor-manager millisec-delay)))

(defn hook-magnetometer! [millisec-delay listener]
  (do
    (.addListener device-event-emitter "Magnetometer" listener)
    (.startMagnetometer sensor-manager millisec-delay)))

(defn dispatch-listener [data]
  (dispatch [:set-state [:drive :magneto]
             (js->clj data :keywordize-keys true)]))

(defn hooks []
  (do
    (info "Hook magnetometer")
    (hook-magnetometer! 50 dispatch-listener)))
