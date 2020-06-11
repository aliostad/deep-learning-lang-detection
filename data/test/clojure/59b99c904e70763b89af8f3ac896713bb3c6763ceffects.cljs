(ns blog.state.effects
  (:require [re-frame.core :refer [dispatch reg-fx]]
            [secretary.core :as secretary :include-macros true]
            [blog.client :refer [GET PUT POST DELETE]]))

(reg-fx :get
        (fn [{:keys [url dispatch-key]}]
          (GET url #(dispatch [dispatch-key %]))))

(reg-fx :post
        (fn [{:keys [url dispatch-key body file?] :or {file? false}}]
          (POST url body #(dispatch [dispatch-key %]) file?)))

(reg-fx :put
        (fn [{:keys [url dispatch-key body]}] 
          (PUT url body #(dispatch [dispatch-key %]))))

(reg-fx :alert
        (fn [msg]
          (js/alert msg)))

(reg-fx :delete
        (fn [{:keys [url dispatch-key]}]
          (DELETE url #(dispatch [dispatch-key %]))))

(reg-fx :redirect-to
        (fn [url]
          (secretary/dispatch! url)))
