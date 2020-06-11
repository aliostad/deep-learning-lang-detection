(ns sportzbee.core
  (:require [reagent.core :as reagent :refer [atom]]
            [reagent.session :as session]
            [reagent.cookies :as cookies]
            [secretary.core :as secretary :include-macros true]
            [goog.events :as events]
            [goog.history.EventType :as EventType]
            [hickory.core :as hickory]
            [cljs.core.async :as async :refer [chan close!]]
            [cljsjs.react-bootstrap :as react-bootstrap]
            [markdown.core :refer [md->html]]
            [clojure.walk :as walk]
            [cognitect.transit :as t]
            [ajax.core :refer [GET POST]])
  (:import goog.History)
  (:require-macros
    [cljs.core.async.macros :refer [go alt!]]))
(def app-state (reagent/atom
                {:app-about-page-message "This about page message"
                              :background-color "black"
                              :person {:user_name "Guest"
                                       :bank ""
                                       :password "secret"
                                       :retype_password "secret"
                                       :age 35
                                       :token ""
                                       :action ""
                                       :org_name "rnandan273"
                                       :app_name "mysportzbee"
                                       :email "foo@bar.baz"}
                              :event {:event_name ""
                                      :venue_name ""
                                      :landmark ""
                                      :street ""
                                      :city ""
                                      :state ""
                                      :pin ""
                                      :contact ""
                                      :other_info ""
                                      :start_date ""
                                      :end_date ""
                                      :details ""}
                              :list_events (list)
                              :fbpage ""
                              :selected_detail ""
                              :nav_items {
                                   :items_main (list
                                            {:link-ref "#/" :evt-key 1 :name-ref "Home"}
                                            {:link-ref "#/about" :evt-key 2 :name-ref "About us"}
                                            {:link-ref "#/login" :evt-key 3 :name-ref "Login"}
                                            {:link-ref "#/register" :evt-key 4 :name-ref "Register"}
                                            {:link-ref "/syncfb" :evt-key 5 :name-ref "LoginFB"})
                                   :items_support (list
                                            {:link-ref "#/login" :evt-key 1 :name-ref "Login"}
                                            {:link-ref "#/register" :evt-key 2 :name-ref "Register"}
                                            )}
                              :carousel_items {
                                  :items_carousel (list
                                       {:link-ref "#/login" :src-ref "http://www.google.co.in/imgres?imgurl=http://www.listofimages.com/wp-content/uploads/2013/01/steven-gerrard-liverpool-captain-glory-football-player-sports.jpg&imgrefurl=http://www.high-resolution-wallpapers.com/steven-gerrard-liverpool-captain-glory-football-player-sports-165931&h=1600&w=2560&tbnid=iHHKKKNYFIb0hM:&docid=PQOYFDTAPKascM&ei=eYQNVpnqLI-jugSkhoCYDQ&tbm=isch&ved=0CE4QMygkMCRqFQoTCNmKqpX8ocgCFY-RjgodJAMA0w" :name-ref "Learn More >>"
                                        :headline "Organize Tournaments and Manage them completely"}
                                       {:link-ref "#/login" :src-ref "" :name-ref "Search >>"
                                        :headline "Search and participate in your favourite Sport events" }
                                       {:link-ref "#/login" :src-ref "" :name-ref "Participate >>"
                                        :headline "Record Scores and build portfolio, share with friends" }
                                       {:link-ref "#/login" :src-ref "" :name-ref "Share >>"
                                        :headline "Share sport events with your friends" }
                                       {:link-ref "#/login" :src-ref "" :name-ref "Learn More >>"
                                        :headline "Organize Tournaments and Manage them completely"}
                                       {:link-ref "#/login" :src-ref "" :name-ref "Search >>"
                                        :headline "Search and participate in your favourite Sport events" }
                                       {:link-ref "#/login" :src-ref "" :name-ref "Participate >>"
                                        :headline "Record Scores and build portfolio, share with friends" }
                                       {:link-ref "#/login" :src-ref "" :name-ref "Share >>"
                                        :headline "Share sport events with your friends" }

                                        {:link-ref "#/login" :src-ref "" :name-ref "Learn More >>"
                                        :headline "Organize Tournaments and Manage them completely"}
                                       {:link-ref "#/login" :src-ref "" :name-ref "Search >>"
                                        :headline "Search and participate in your favourite Sport events" }
                                       {:link-ref "#/login" :src-ref "" :name-ref "Participate >>"
                                        :headline "Record Scores and build portfolio, share with friends" }
                                       {:link-ref "#/login" :src-ref "" :name-ref "Share >>"
                                        :headline "Share sport events with your friends" }
                                       {:link-ref "#/login" :src-ref "" :name-ref "Learn More >>"
                                        :headline "Organize Tournaments and Manage them completely"}
                                       {:link-ref "#/login" :src-ref "" :name-ref "Search >>"
                                        :headline "Search and participate in your favourite Sport events" }
                                       {:link-ref "#/login" :src-ref "" :name-ref "Participate >>"
                                        :headline "Record Scores and build portfolio, share with friends" }
                                       {:link-ref "#/login" :src-ref "" :name-ref "Share >>"
                                        :headline "Share sport events with your friends" })}
                              :services_items {
                                  :items_services (list
                                       {:click-param "events" :name-ref "Organize" :subtext "DIY event management.Create Tournaments, iternaries, invite players"
                                        :button-href "#/details" :button-label "More"}
                                       {:click-param "search" :name-ref "Search" :subtext "Search interesting events in your locality. You can participate in events based on availability"
                                        :button-href "#/details" :button-label "More"}
                                       {:click-param "participate" :name-ref "Participate" :subtext "Participate and build portfolio. This will data will help the players in many professional aspects"
                                        :button-href "#/details" :button-label "More"}
                                       {:click-param "share" :name-ref "Share" :subtext "Share scores and performance with your friends. Create your own brand."
                                        :button-href "#/details" :button-label "More"})}
                              :register_user_items {
                                  :items_register (list
                                      {:label "User Name" :placeholder "Enter user name" :type "text" :ref-key (list :user_name)}
                                      {:label "Password" :placeholder "Enter password" :type "password" :ref-key (list :password)}
                                      {:label "Password" :placeholder "Retype password" :type "password":ref-key (list :retype_password)}
                                      {:label "Email" :placeholder "Enter email" :type "email" :ref-key (list :email)})}
                              :register_event_items {
                                  :items_register (list
                                      {:label "Event Name" :type "text" :placeholder "Enter event name" :ref-key (list :tourney-name)}
                                      {:label "Start Date" :type "date" :placeholder "Enter start date" :ref-key (list :start_date)}
                                      {:label "End Date " :type "date" :placeholder "Enter end date" :ref-key (list :end_date)}
                                      {:label "Venue Name" :type "text" :placeholder "Enter venue name" :ref-key (list :venue_name)}
                                      {:label "Street Name" :type "text" :placeholder "Enter street name" :ref-key (list :street)}
                                      {:label "Landmark" :type "text" :placeholder "Enter landmark name" :ref-key (list :landmark)}
                                      {:label "City" :type "text" :placeholder "Enter city name" :ref-key (list :city)}
                                      {:label "State" :type "text":placeholder "Enter state name" :ref-key (list :state)}
                                      {:label "Pin" :type "text" :placeholder "Enter pin" :ref-key (list :pin)}
                                      {:label "Contact Info" :type "text" :placeholder "Enter contact information" :ref-key (list :organiser_name)}
                                      {:label "Other Info" :type "text" :placeholder "Enter other information" :ref-key (list :other_info)})}
                              }))


(def Text (reagent/adapt-react-class js/ReactBootstrap.Text))
(def Grid (reagent/adapt-react-class js/ReactBootstrap.Grid))
(def Row (reagent/adapt-react-class js/ReactBootstrap.Row))
(def Col (reagent/adapt-react-class js/ReactBootstrap.Col))
(def Label (reagent/adapt-react-class js/ReactBootstrap.Label))
(def ListGroup (reagent/adapt-react-class js/ReactBootstrap.ListGroup))
(def ListGroupItem (reagent/adapt-react-class js/ReactBootstrap.ListGroupItem))
(def Button (reagent/adapt-react-class js/ReactBootstrap.Button))
(def Label (reagent/adapt-react-class js/ReactBootstrap.Label))
(def Jumbotron (reagent/adapt-react-class js/ReactBootstrap.Jumbotron))
(def Accordion (reagent/adapt-react-class js/ReactBootstrap.Accordion))
(def Panel (reagent/adapt-react-class js/ReactBootstrap.Panel))
(def Modal (reagent/adapt-react-class js/ReactBootstrap.Modal))
(def Navbar (reagent/adapt-react-class js/ReactBootstrap.Navbar))
(def Nav (reagent/adapt-react-class js/ReactBootstrap.Nav))
(def NavItem (reagent/adapt-react-class js/ReactBootstrap.NavItem))
(def DropdownButton (reagent/adapt-react-class js/ReactBootstrap.DropdownButton))
(def MenuItem (reagent/adapt-react-class js/ReactBootstrap.MenuItem))
(def Input (reagent/adapt-react-class js/ReactBootstrap.Input))
(def ButtonInput (reagent/adapt-react-class js/ReactBootstrap.ButtonInput))
(def Thumbnail (reagent/adapt-react-class js/ReactBootstrap.Thumbnail))
(def CollapsibleNav (reagent/adapt-react-class js/ReactBootstrap.CollapsibleNav))
(def Carousel (reagent/adapt-react-class js/ReactBootstrap.Carousel))
(def CarouselItem (reagent/adapt-react-class js/ReactBootstrap.CarouselItem))
(def Tabs (reagent/adapt-react-class js/ReactBootstrap.Tabs))
(def Tab (reagent/adapt-react-class js/ReactBootstrap.Tab))
(def Pager (reagent/adapt-react-class js/ReactBootstrap.Pager))
(def PageItem (reagent/adapt-react-class js/ReactBootstrap.PageItem))

(def googlemapkey "AIzaSyDUexZHH88EIeKZSS6U-efg0KDMQCZoH3w")

(def read-json (t/reader :json))

(def write-json (t/writer :json))

(defn forward-login [auth_response]
  (log (str "ERROR ->" (get auth_response :error)))
  (swap! app-state assoc-in [:person :action] (str "Invalid userid / password"))
  (secretary/dispatch! "#/login")
  (session/put! :page :login)
  )

(defn log [s]
  (.log js/console (str s)))

(defn response-handler [ch response]
  (go (>! ch response)(close! ch))
  (log "DONE"))

(defn get_random_image_index []
  (rand-int (count (@app_state :getty_images)))
)

(defn response-handler-images [response]
  (swap! app-state assoc-in [:getty_images] (walk/keywordize-keys (t/read read-json response)))
)

(defn do-http-get [url]
  (log (str "GET " url))
  (let [ch (chan 1)]
    (GET url {:handler (fn [response](response-handler ch response))
              :error-handler (fn [response] (response-handler ch response))})
    ch))

(defn fetch_getty_images [url]
  (go
     (response-handler-images (<! (do-http-get url)))
   )
)

(defn do-http-post [url doc]
  (log "POSTING ---->")
  (log (str "POST " url (clj->js doc)))
  (let [ch (chan 1)]
    (POST url {:params  (clj->js doc) :format :json :handler (fn [response] (response-handler ch response))
               :error-handler (fn [response] (response-handler ch response))})
    ch)
  )


(defn read-server-response [response]
  (walk/keywordize-keys (t/read read-json response)))

(defn read-auth-response [response]
  (swap! app-state assoc-in [:fbpage] (first (map hickory/as-hiccup (hickory/parse-fragment response))))

  (log (str "After Person appstate response "  response))
  ;;(session/put! :page :fblogin)
  (let [auth_response (read-server-response response)]
    (cond (contains? auth_response :error)
          (forward-login auth_response))

    (cond (contains? auth_response :access_token)
          (
            (swap! app-state assoc-in [:person :token] (str (get auth_response :access_token)))
            (secretary/dispatch! "/home")
            (session/put! :page :home)
            )))
  )

(def select-values (comp vals select-keys))

(defn transform-ui [rx]

  (let [vofmaps (into [] (:items_register (@app_state :register_event_items)))]
   ;; (log  (map #(assoc (merge (select-keys rx (:ref-key %)) %) :item_value (select-values rx (:ref-key %))) vofmaps))
    (map #(assoc (merge (select-keys rx (:ref-key %)) %) :item_value (select-values rx (:ref-key %))) vofmaps)
  )
  ;;(merge each with the items-register)
)

(defn read-service-response [response]

  (swap! app-state assoc-in [:list_events] (map #(transform-ui %) (walk/keywordize-keys response)))
  (log (into [] (@app_state :list_events)))
)

;;UI layer
(defn nav-link [uri title page collapsed?]
  [:li {:class (when (= page (session/get :page)) "active")}
   [:a {:href uri
        :on-click #(reset! collapsed? true)}
    title]])


(def menu_dropdown_items
  {:items_sports (list
                     {:event-key 1 :name-ref "Table-Tennis"}
                     {:event-key 2 :name-ref "Chess"}
                     {:event-key 3 :name-ref "Badmintom"}
                     {:event-key 4 :name-ref "Tennis"}
                     {:event-key 5 :name-ref "Cricket"}
                     {:event-key 6 :name-ref "Soccer"})

   :items_manage (list {:event-key 1 :name-ref "Add Event" :link-ref "#/addevent"}
                     {:event-key 2 :name-ref "My Events" :link-ref "#/myevents"})
   }
)

(defn reactnavbar []
  (fn []
    [Navbar {:class "navbar-material-light-blue-800" :fixedTop true :brand "Sportzbee" :bsStyle "primary" :bsSize "large" :toggleNavKey 0}
     [CollapsibleNav {:eventKey 0}
     [Nav {:navbar true :right true :eventKey 0}
           [NavItem {:class "navitem-material-light-blue-800"} (str "Welcome " ((@app_state :person) :user_name))]
       (for [x (:items_main (@app_state :nav_items))]
          (let [{:keys [evt-key link-ref name-ref]} x]
            [NavItem {:class "navitem-material-light-blue-800" :eventKey evt-key :href link-ref} name-ref]))]]]))

(defn about-page []
  [:div.container
   [:div.row
    [:div.col-md-12
     "this is the story of sportzbee... work in progress"]]])

(defn get_random_image_url []
  (:uri (get (@app_state :getty_images) (get_random_image_index)))
)

(defn home-page []
  (fn []
    [:div.container
     [:div [Carousel {:controls false :indicators false}
        (for [x (:items_carousel (@app_state :carousel_items))]
          (let [{:keys [src-ref link-ref name-ref :headline]} x]
            [CarouselItem {:animateIn true :animateOut true}
            [:img {:width 450 :height 200 :src (get_random_image_url)}]
            [:div {:className "carousel-caption"}
              [:h3 {:style {:font-weight "bold" :color "#1D71B0"}} headline]
              [:p [Button {:class "btn-material-light-blue-800" :bsSize "xsmall"
                           :bsStyle "primary" :href link-ref} name-ref]]]]))]]
     [:div [Grid {:fluid false}
            [Col {:xs 9 :md 6} [search-events-details]
             [Pager {:disabled false}
                [PageItem {:previous true :href "#"} "Previous"]
                [PageItem {:next true :href "#"}"Next"]
              ]]
            [Col {:xs 9 :md 6}[:br]
                 [:br]
                 [map-component]
                 [:br]
                 [:br]]
            ]]


     [:div
      [Grid {:fluid true}
          [Row
           (for [x (:items_services (@app_state :services_items))]
             (let [{:keys [name-ref subtext click-param button-label button-href name-ref]} x]
               [Col {:xs 12 :md 3 :sm 4}
                    [:h3 {:style {:font-weight "bold"}} name-ref] [:p subtext]
                    [:p [Button {:class "btn-material-light-blue-800" :bsStyle "primary" :href button-href
                                 :onClick #(show-details click-param)} button-label]]]))]]]]))

(defn show-details [type]
  (swap! app-state assoc-in [:selected_detail] type)
)

(defn get-events-details []
    [Accordion {:bsStyle "primary"}
     [Panel {:bsStyle "primary" :header "Create Event" :eventKey "1"} [register-event]]
      [Panel {:bsStyle "primary" :header "Edit Events" :eventKey "2"}
      [Accordion
       [Panel {:bsStyle "primary" :header "Event - 1" :eventKey "3"} [register-event]]
       [Panel {:bsStyle "primary" :header "Event - 2" :eventKey "4"} [register-event]]
       [Panel {:bsStyle "primary" :header "Event - 3" :eventKey "5"} [register-event]]
       [Panel {:bsStyle "primary" :header "Event - 4" :eventKey "6"} [register-event]]]]]
)
(def x 0)
(defn search-events-details []
    [:div
     [:section  [:h4 "Search Events"]
      [Input {:type "text" :bsSize "medium" :placeholder "Enter sport name or pin or city "
            :onChange #(search_entry (-> % .-target .-value))}]]
      [:section [:h4 "Search Results"]
        [Accordion
         (map-indexed (fn [idx itm]
          [Panel {:bsStyle "primary" :header (:item_value (first itm)) :eventKey idx} [favourite-event itm]])
              (into [] (@app_state :list_events)))]]]
)

(defn participate-events-details []
    [:div
     [:section  [:h4 "Search and Participate"]
      [Input {:type "text" :bsSize "medium" :placeholder "Enter event name or address "
            :onChange #(search_entry (-> % .-target .-value))}]]
      [:section [:h4 "Search Results"]
      [Accordion
         (map-indexed (fn [idx itm]
          [Panel {:bsStyle "primary" :header (:item_value (first itm)) :eventKey idx} [add-event itm]])
              (into [] (@app_state :list_events)))]]]
)

(defn details-page []
  (fn []
     [:div.container
      (cond (= (@app-state :selected_detail) "events") (get-events-details)
            (= (@app-state :selected_detail) "search") (search-events-details)
            (= (@app-state :selected_detail) "participate") (participate-events-details)
      )]
  ))

(defn logout-page []
  [:div.container
   [:div.row
    [:div.col-md-12
     "Your  logged out , Thanks for visiting"]]])

(defn my-events []
  [:div.container
   [:div.row
    [:div.col-md-12
     "List of my events"]]])

(defn login-page []
  (let [login_doc (reagent/atom (@app-state :person) :many {:options :foo})]
    (fn []
      [:form  {:className "form-horizontal"}
       [Grid
        [Row
         [Col {:mdOffset 3 :xsOffset 2 :md 9 :xs 16} [:h2 "Welcome , Login"]
           [Col {:md 10 :xs 14}
            [Row
              [Input {:labelClassName "col-xs-2" :wrapperClassName "col-xs-6"
                      :type "text" :bsSize "small" :label "Username" :placeholder "Enter text"
                    :onChange #(swap! login_doc assoc-in [:user-name] (-> % .-target .-value))}]]
            [Row
               [Input {:labelClassName "col-xs-2" :wrapperClassName "col-xs-6"
                      :type "password" :bsSize "small" :label "Password" :placeholder "Enter password"
                      :onChange #(swap! login_doc assoc-in [:passwd] (-> % .-target .-value))}]]
            [Row
               [Input {:labelClassName "col-xs-2" :wrapperClassName "col-xs-6"
                      :type "email" :bsSize "small" :label "Email Address" :placeholder "Enter email"
                       :onChange #(swap! login_doc assoc-in [:passwd] (-> % .-target .-value))}]]

            [Row
             [Col {:md 3 :xs 6}
              [ButtonInput { :class "btn-material-light-blue-800" :type "reset" :bsSize "small" :bsStyle "primary" :value "Reset"}]
              ]
             [Col {:md 3 :xs 6}
              [ButtonInput {:class "btn-material-light-blue-800" :type "submit" :bsSize "small"  :bsStyle "primary" :value "Login" :onClick #(user-login-click @login_doc)}]
              ]]
          ]

           ]]]])))

(def url_list {:usertoken1
                 (fn [username password]
                   (str "/api/getUserToken?grant_type=password&username=" username "&password=" password))
               :usertoken
                 (fn [username password]
                   (str "/usertoken?grant_type=password&username=" username "&password=" password))
               :user_register
                 (fn [username passwd rt_passwd email]
                    (str "/register"))})


(defn user-login-click [{:keys [user-name passwd]} doc]
  (log (str "User Login destructuring" user-name passwd))
  (go
    (read-auth-response (<! (do-http-get ((:usertoken url_list) user-name passwd))))))

(defn user-fb-login-click []

  (def usergrid_url (str "https://graph.facebook.com/oauth/authorize?client_id=116170012066426&scope=email&response_type=code&redirect_uri=http://localhost:3000/api/fb_callback"))
  (def usergrid_url (str "/fblogin"))
  ;;(def usergrid_url (str "https://www.facebook.com/dialog/oauth?client_id=116170012066426&scope=email&response_type=code&redirect_uri=http://localhost:3000/api/fb_callback"))
  (log (str "FB Login" usergrid_url))
  (do-http-get usergrid_url)
  (comment
  (go
     (read-auth-response (<! (do-http-get usergrid_url))))
  ))

(defn logout-click []
  (cookies/remove! "token")
  (do
        (swap! app-state assoc-in [:person :user_name] "Guest")
        (swap! app-state assoc-in [:nav_items :items_main]
         (list {:link-ref "#/" :evt-key 1 :name-ref "Home"}
               {:link-ref "#/about" :evt-key 2 :name-ref "About us"}
               {:link-ref "#/login" :evt-key 3 :name-ref "Login"}
               {:link-ref "/syncfb" :evt-key 3 :name-ref "LoginFB"})))
)

(defn user-register-click [doc]
   (log (str "POST REGISTER 1" doc))
  (let [{:keys [user-name password retype_password email]} doc]
  (def post_request (.stringify js/JSON (clj->js doc)))
    (log (str "POST REGISTER 1" doc))
  (go
     (read-auth-response (<! (do-http-post ((:user_register url_list) username passwd rt_passwd email) doc))))))


(defn register-page []
  (let [register_doc (reagent/atom (@app-state :person))]
    (fn []
      [:form  {:className "form-horizontal"}
       [Grid
        [Row [Col {:mdOffset 3 :md 9 :xsOffset 2 :xs 10 }[:h2 "Register New User"]]
        (for [x (:items_register (@app_state :register_user_items))]
          (let [{:keys [label placeholder ref-key]} x]
              [Input {:mdOffset 4 :xsOffset 2 :labelClassName "col-xs-4" :wrapperClassName "col-xs-4"
                :type (:type x) :bsSize "small" :label label :placeholder placeholder
                :onChange #(swap! register_doc assoc-in [(first ref-key)] (-> % .-target .-value))}]))]
        [Row
         [Col {:mdOffset 3 :md 3 :xsOffset 2 :xs 4 }
          [ButtonInput {:type "reset" :class "btn-material-light-blue-800" :bsStyle "primary" :value "Reset"}]]
         [Col {:md 3 :xs 4 }
          [ButtonInput {:type "submit" :class "btn-material-light-blue-800" :bsStyle "primary" :value "Submit"
                        :onClick #(user-register-click @register_doc)}]]]]])))

(defn register-event []
  (let [event_doc (reagent/atom (@app-state :event))]
    (fn []
      [:form  {:className "form-horizontal"}
        [Grid
          [Row [Col {:md 12 :xs 12}
            (for [x (:items_register (@app_state :register_event_items))]
              (let [{:keys [label fieldtype placeholder ref-key]} x]
              [Input {
                     :labelClassName "col-xs-3" :wrapperClassName "col-xs-6"
                    :type (:type x) :bsSize "small" :label label :placeholder placeholder
                    :onChange #(swap! event_doc assoc-in [(get ref-key 0)] (-> % .-target .-value))}]))]]

           [Row
            [Col {:mdOffset 2 :md 3 :xsOffset 2 :xs 4}
              [ButtonInput {:type "reset" :class "btn-material-light-blue-800" :bsStyle "primary" :value "Reset"}]]
            [Col {:md 3 :xs 4 }
              [ButtonInput {:type "submit" :class "btn-material-light-blue-800" :bsStyle "primary" :value "Submit"
                            :onClick #(user-register-click @register_doc)}]]]]])))

(defn add-event [elem]
  (let [event_doc (reagent/atom (@app-state :event))]
    (fn []
      [:form  {:className "form-horizontal"}
        [Grid
          [Row [Col {:md 12 :xs 12}
            (for [x elem]
              (let [{:keys [label fieldtype placeholder ref-key]} x]
              [Input {
                     :labelClassName "col-xs-3" :wrapperClassName "col-xs-6"
                    :type (:type x) :bsSize "small" :label label :placeholder placeholder :value (:item_value x)
                    :onChange #(swap! event_doc assoc-in [(get ref-key 0)] (-> % .-target .-value))}]))]]

           [Row
            [Col {:mdOffset 3 :md 9 :xsOffset 3 :xs 9}
              [ButtonInput {:type "submit" :class "btn-material-light-blue-800" :bsStyle "primary" :value "Participate"
                            :onClick #(user-register-click @register_doc)}]]]]])))

(defn favourite-event [elem]
    (let [event_doc (reagent/atom (@app-state :event))]
      (fn []
      [:form  {:className "form-horizontal"}
        [Grid
          [Row [Col {:md 12 :xs 12}
              (for [x elem]
              (let [{:keys [label fieldtype placeholder ref-key]} x]
              [Input {
                     :labelClassName "col-xs-3" :wrapperClassName "col-xs-6"
                    :type (:type x) :bsSize "small" :label label :placeholder placeholder
                    :value (:item_value x)}]))]]

           [Row
            [Col {:mdOffset 3 :md 9 :xsOffset 3 :xs 9}
              [ButtonInput {:type "submit" :class "btn-material-light-blue-800" :bsStyle "primary" :value "Like"
                            :onClick #(user-register-click @register_doc)}]]]]])))

(defn search_entry [entry]
  (log (str "Search : " entry))
  (def service_url1 (str "/listed_events"))
  (def service_url (str "/randomsearch?fp=" entry))
  (log (str "GET EVENTS" service_url))
  (go
     (read-service-response (<! (do-http-get service_url)))
  )
)

(defn footer []
  [Grid
   [Row
    [Col {:mdOffset 1 :xsOffset 1 :xs 5 :md 5} [Row [:h3 "Sportzbee"]]
                 [Row [:p "is online social & digital sports platform for sports enthusiast to capture,
                       record and share sports events & matches happening all over the world."]]
                 [Row [:h4 "© 2014 SportzBee Inc. All rights reserved."]]]
    [Col {:xs 5 :md 5} [Row [:h5 "Disclaimer"]]
                 [Row [:p "Please contact the organizer of the event that you want to participate or
                       attend. SportzBee.com attempts to provide information about events and gathers
                       event information from publicly available sources. The information is subject to change.
                       SportzBee.com does not take responsibility for any loss
                       incurred due to plans made on the basis of the information on the Web site"]]]]])

(defn fblogin-page []
  (@app-state :fbpage))

(def pages
  {:home #'home-page
   :register #'register-page
   :addevent #'register-event
   :myevents #'my-events
   :details #'details-page
   :login #'login-page
   :fblogin #'fblogin-page
   :about #'about-page})

(defn page []
  [(pages (session/get :page))])

;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
  (session/put! :page :home)
  (session/put! :current-page "home")
  )

(secretary/defroute "/about" []
  (session/put! :page :about)
  (session/put! :current-page "about")
  )

(secretary/defroute "/register" []
  (session/put! :page :register)
  (session/put! :current-page "register"))

(secretary/defroute "/addevent" []
  (session/put! :page :addevent)
  (session/put! :current-page "addevent"))

(secretary/defroute "/myevents" []
  (session/put! :page :myevents)
  (session/put! :current-page "myevents"))

(secretary/defroute "/details" []
  (session/put! :page :details)
  (session/put! :current-page "details"))

(secretary/defroute "/chat" []
  (session/put! :page :chat)
  (session/put! :current-page "chat"))

(secretary/defroute "/login" []
  (session/put! :page :login)
  (session/put! :current-page "login"))

(secretary/defroute "/logout" []
  (session/put! :page :logout)
  (session/put! :current-page "logout"))

(defn on_logout []
  (cookies/remove! "token")
  (do
        (swap! app-state assoc-in [:person :user_name] "Guest")
        (swap! app-state assoc-in [:nav_items :items_main]
         (list {:link-ref "#/" :evt-key 1 :name-ref "Home"}
               {:link-ref "#/about" :evt-key 2 :name-ref "About us"}
               {:link-ref "#/login" :evt-key 3 :name-ref "Login"}
               {:link-ref "#/register" :evt-key 4 :name-ref "Register"}
               {:link-ref "/syncfb" :evt-key 5 :name-ref "LoginFB"})))
  )

(defn redirect_handle_page_load[]
  (log "history event")
  (log (cookies/get "token"))
  (if (cookies/contains-key? "token")
    (do
        (swap! app-state assoc-in [:person :user_name] (cookies/get "token"))
        (swap! app-state assoc-in [:nav_items :items_main]
         (list {:link-ref "#/" :evt-key 1 :name-ref "Home"}
               {:link-ref "#/about" :evt-key 2 :name-ref "About us"}
               {:link-ref "/logout" :evt-key 3 ::name-ref "Logout"})))
    (do
        (swap! app-state assoc-in [:person :user_name] "Guest")
        (swap! app-state assoc-in [:nav_items :items_main]
         (list {:link-ref "#/" :evt-key 1 :name-ref "Home"}
               {:link-ref "#/about" :evt-key 2 :name-ref "About us"}
               {:link-ref "#/login" :evt-key 3 :name-ref "Login"}
               {:link-ref "#/register" :evt-key 4 :name-ref "Register"}
               {:link-ref "/syncfb" :evt-key 5 :name-ref "LoginFB"}))))

)

;; -------------------------
;; History
;; must be called after routes have been defined
(defn hook-browser-navigation! []
  (doto (History.)
        (events/listen
          EventType/NAVIGATE
          (fn [event]
              (redirect_handle_page_load)
              (secretary/dispatch! (.-token event))))
        (.setEnabled true)))

;; -------------------------

;;maps
(defn map-render []
  [:div {:style {:height "300px"}}])

(defn map-did-mount [this]
  (let [map-canvas (reagent/dom-node this)
        map-options (clj->js {:zoom 5
                              :mapTypeId google.maps.MapTypeId.ROADMAP
                              :center (google.maps.LatLng. 12.97, 77.59)
                              :mapTypeControl true
                              :styles [{:stylers [{:visibility "on"}]}]})
        map-drawn  (js/google.maps.Map. map-canvas map-options)
        marker-options (clj->js {:position (google.maps.LatLng. 12.97, 77.59)
                             :title "Hello Event"})
        marker-options2 (clj->js {:position (google.maps.LatLng. 14.97, 78.59)
                             :title "Hello Event2"})]
        (.setMap (js/google.maps.Marker. marker-options) map-drawn)
        (.setMap (js/google.maps.Marker. marker-options2) map-drawn)))


        ;;(.setMap (js/google.maps.Marker. map-marker2) (js/google.maps.Map. map-canvas map-options))))
       ;;(.setMap (js/google.maps.Marker. map-marker map-drawn))))

(defn map-component []
  (reagent/create-class {:reagent-render map-render
                         :component-did-mount map-did-mount}))

;; Initialize app
(defn fetch-docs! []
  (GET (str js/context "/docs") {:handler #(session/put! :docs %)}))


(defn current-page-will-mount []
   (log (str "current page will mount"))
)

(defn current-page-render []
   (log (str "current page rendering " (if (= (session/get :current-page) "home") (log "HOE PAGE"))))
  [(pages (session/get :page))])

(defn current-page-did-mount []
  (log (str "current page did mount"))
)

(defn current-page-did-update []
  (log (str "current page did update")))


(defn current-page []
  (reagent/create-class {:component-will-mount current-page-will-mount
                         :reagent-render current-page-render
                         :component-did-mount current-page-did-mount
                         :component-did-update current-page-did-update}))


(defn mount-components []
  ;;;;;(reagent/render [#'navbar] (.getElementById js/document "navbar"))
  (reagent/render [#'reactnavbar] (.getElementById js/document "reactnavbar"))
  ;;;;;;(reagent/render [#'page] (.getElementById js/document "app"))
  ;;;;;;(reagent/render [#'services] (.getElementById js/document "services"))
  (reagent/render [current-page] (.getElementById js/document "app"))
  ;;(reagent/render [home] (.getElementById js/document "app"))
  (reagent/render [#'footer] (.getElementById js/document "footer"))
  )

(defn init! []
  (fetch-docs!)
  (hook-browser-navigation!)
  (mount-components)
  (fetch_getty_images "/getty_images")
)






