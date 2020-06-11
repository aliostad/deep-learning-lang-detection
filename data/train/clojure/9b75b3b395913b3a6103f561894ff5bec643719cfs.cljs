(ns ui.fx.fs
  (:require [re-frame.core :refer [dispatch]]
            [lib.util :refer [reg-fx-service]]))

(defonce fs (js/require "fs-extra"))

(reg-fx-service
  :fs/stat
  (fn [{:keys [path on-success on-error]}]
    (.stat fs
           path
           (fn [err val]
             (if err
               (dispatch (conj on-error (js->clj err)))
               (dispatch (conj on-success {:filesize (.-size val)})))))))

(reg-fx-service
  :fs/copy
  (fn [{:keys [src-path dest-path on-success on-error]}]
    (.copy fs
           src-path
           dest-path
           (fn [err]
             (if err
               (dispatch on-error)
               (dispatch on-success))))))