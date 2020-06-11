(ns clirj.core
  (:require [reagent.core :as r]
            [re-frame.core :as rf]
            [clirj.net :as net]
            [clirj.components :as components]
            [clirj.events :as events]))

(enable-console-print!)

  (defn manage-members-view
    []
    (let [name (rf/subscribe [:member-input])
          web-socket (rf/subscribe [:ws])]
      [:div
       [:div
        (components/input #(rf/dispatch [:member-input (-> % .-target .-value)])
                          {:value @name})
        (if @web-socket
          (components/button "Disconnect" #(.close @web-socket))
          (components/button "Join" #(when @name
                                       (net/make-websocket @name)
                                       (rf/dispatch [:member-input nil]))))]
       [:div
        (components/button "Ban user" #(when @name
                                         (net/ban-member @name)
                                         (rf/dispatch [:member-input nil])))]]))

(defn send-message-view
  []
  (let [message (rf/subscribe [:message-input])
        web-socket (rf/subscribe [:ws])]
    [:div
     (components/input #(rf/dispatch [:message-input (-> % .-target .-value)])
                       {:value @message})
     (components/button "Send" #(when (and @web-socket @message)
                                  (.send @web-socket @message)
                                  (rf/dispatch [:message-input nil])))]))

(defn messages-list []
  [:div
   [:h3 "Messages"]
   (for [message @(rf/subscribe [:messages])]
     [:p message])])

(defn members-list []
  [:div
    [:h3 "Members"]
    (for [member @(rf/subscribe [:members])]
      [:p {:key member} member])])

(defn main []
  [:div
   [:h3 "Join to CLIRJ"]
   [:div
    [manage-members-view]
    [messages-list]
    [send-message-view]
    [members-list]]])

(defn run
  []
  (events/initialize-data)
  (r/render-component [main]
                      (. js/document (getElementById "app"))))

(run)
