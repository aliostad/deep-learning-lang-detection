
(ns memjore.views.common
  (require [noir.session :as session])
  (:use [noir.core :only [defpartial pre-route]]
        [noir.response :only [redirect]]
        [hiccup.element :only [link-to]]
        [memjore.models.validation]
        [hiccup.form :only
         [label text-field form-to drop-down submit-button text-area hidden-field]]
        [hiccup.page :only [include-css html5 include-js]]))


(defn- flash-message "flash-message")

(defn get-flash-message []
  (session/flash-get flash-message))

(defn put-flash-message! [message]
  (session/flash-put! flash-message message))

(defn main-links [links]
  "Returns links to main pages of the app"
  (map
   #(let [[url text] %]
         [:span.main-menu-links (link-to url text)])
   links))

(defpartial footer []
  [:p (str "Memjore. Copyright Ikenna Nwaiwu") ])

(defpartial layout [& content]
            (html5
              [:head
               [:title "memjore"]
               (include-css "/css/style.css")
               (include-js "/ckeditor/ckeditor.js")]
              [:body
               [:div#wrapper
                [:p.logout (link-to "/log-out" "Log out") ]
                [:div#header
                 [:h1 "Memjore"]
                 [:p.main-menu
                  (main-links [  ["/manage/home" "Home"]
                                 [ "/manage/members" "All Members"]
                                 [ "/manage/members/add" "Add Member"]
                                 [ "/manage/sendtext" "Send Text"]
                                 [ "/manage/sendemail" "Send Email"]])]]
                [:div#content content]
                [:div#footer (footer)]]]))


(defn edit-text-field [f]
  (let [[symbol value id name areabox] f]
    [:p (label id name)
     (if (nil? areabox)(text-field symbol value) (text-area symbol value) )
     (err-mess symbol)]))


(defpartial user-fields [{:keys [id fname lname mobile phone address tags] :as member}]
  [:div#editform
   (map edit-text-field [
                         [:fname fname "firstname" "First Name:"]
                         [:lname lname "lastname" "Last Name:"]
                         [:mobile mobile "mobile" "Mobile:"]
                         [:phone phone "phone number" "Phone Number:"]
                         [:address address "address" "Address:" :area-box]
                         [:tags tags "tags" "Tags:" :area-box]])
   [:p  (hidden-field "id" (:_id member)) (submit-button "Submit") ]])


(defpartial display-error-messages-if-any [req]
  (if (not (= (:success req) true))
    [:h3.error (:message req)]))
