(ns ^{:doc "This is the main view. It receives requests from the
            controller and fetches information from the model.

            The main views make use of nested components."}
      
  track.views

  (:use [ring.util.response :only [response content-type]]
        [hiccup.core]
        [hiccup.page :only [html4 include-css include-js]]
        [hiccup.def :only [defelem defhtml]]
        [hiccup.element :only [link-to unordered-list]]
        [track.model])
  (:require [track.views.tables :as table]
            [track.views.forms :as form]
            [track.views.charts :as chart]))

(def stylesheet
  "/css/bootstrap.css")

(def favicon
  "/images/favicon.ico")

(defn html-response [body]
  (content-type (response body) "text/html"))

(defn hero-template
  [{flash :flash} & body]
  (html4 {:lang "en"}
         [:head
          [:title "Rheo Systems | Machine Monitor"]
          [:meta {:name "description" :content "some description"}]
          [:meta {:name "keywords" :content "some keywords"}]
          [:meta {:name "author" :content "Rheo Systems"}]
          (include-css stylesheet)
          [:style {:type "text/css"}
           "body {padding-top: 60px;
                  padding-bottom: 40px;}
            .sidebar-nav {
             padding: 9px 0;}"]
          [:link {:rel "shortcut icon" :href favicon}]
          ;; TODO: Need to include iPad favicons.
          [:script {:type "text/javascript"  :src "https://www.google.com/jsapi"}]]
         [:body
          [:div.navbar.navbar-fixed-top
           [:div.navbar-inner
            [:div.container
             [:div.nav-collapse
              (unordered-list {:class "nav"}
                              [(link-to "/" "Home")
                               (link-to "/register" "Register")
                               (link-to "/manage/devices" "Devices")
                               (link-to "/manage/series" "Series")
                               (link-to "/doc" "Documentation")])]]]]
          [:div.container
           (when-not (nil? flash)
             [:div {:class (str "alert " (name (key (first flash)))) }
              [:a.close {:data-dismiss "alert"} "&times;"]
              (val (first flash))])
           body
           [:footer
            [:hr]
            [:p "&copy; Rheo Systems 2012"]]]
          (include-js "/js/jquery-1.7.2.min.js")
          (include-js "/js/bootstrap-carousel.js")
          (include-js "/js/bootstrap-modal.js")
          (include-js "/js/bootstrap-alert.js")]))

(defn devices [{user :basic-authentication :as req}]
  (html-response
   (hero-template
    req
    [:div.row
     [:div.span3
      [:div.sidebar
       [:div.well
        [:h5 "Manage"]
        (unordered-list
         [(link-to {:data-toggle "modal" :data-target "#newDevice"} "#newDevice" "New Device")])]]]
     [:div.span9
      [:div#newDevice.modal.fade
       (form/modal
        {:post "/manage/devices"
         :legend "Device Details"
         :labels ["Location" "Tags"]
         :fields [:location :tags]
         :values ["" ""]
         :helptexts ["" ""]})]
      (table/devices (fetch-devices user))]])))


(defn series [{user :basic-authentication :as req}]
  (html-response
   (hero-template
    req
    [:h2 "Series"]
    [:div#newDevice.modal.fade
     (form/modal
      {:post "/admin/devices"
       :legend "Device Details"
       :labels ["Location" "Tags"]
       :fields [:location :tags]
       :values ["" ""]})]
    (table/series (fetch-series user)))))

(defn home [req]
  (html-response
   (hero-template
    req
    [:p "Will add some charts here later."]
    ;; [:div#myCarousel.carousel.slide
    ;;  [:div.carousel-inner
    ;;   [:div.active.item
    ;;    [:p "something"]]
    ;;   [:div.item
    ;;    [:p "something else"]]]
    ;;  [:a.carousel-control.left
    ;;   {:href "#myCarousel" :data-slide "prev"} "&lsaquo;"]
    ;;  [:a.carousel-control.right
    ;;   {:href "#myCarousel" :data-slide "next"} "&rsaquo;"]]
    )))

(defn registration [req]
  (html-response
   (hero-template req
                  [:div.row
                   [:div.span5.offset1
                    (form/registration "/register")]])))

(defn documentation [req]
  (html-response
   (hero-template
    req
    [:h1 "Documentation"]
    [:p "Use the following line to send a datapoint to the application:"]
    [:pre "curl -X PUT -H 'Content-type: application/json' -d '{\"device\": 1 \"Voltage\": 250}' http://devices.rheosystems.com/api/v1"]
    [:p "Fetch data with the following:"]
    [:pre "curl -X GET -H 'Content-type: application/json' http://devices.rheosystems.com/api/v1/series/1"]
    [:p "Time limitations can be sent with query parameters (STILL NEEDS TESTING)"]
    [:pre "curl -X GET -H 'Content-type: application/json' http://devices.rheosystems.com/api/v1/series/1?'start=\"2012-01-01\"&end=\"2012-06-01\""])))

(defn datapoints [req id]
  (html-response
   (let [series (refresh (create-series {:series_id id}))]
     (hero-template
      req
      [:div.row
       [:div.span3
        [:h1 (:attribute series)]
        [:p (str "From device " (:device series))]]
       [:div.span9
        [:p (table/datapoints series)]
        [:p "For later..."]]]))))
