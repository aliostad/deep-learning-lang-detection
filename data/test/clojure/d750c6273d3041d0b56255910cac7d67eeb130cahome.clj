(ns pages.home
  (:require [noir.session :as session]
            [ring.util.response :as response])
  (:use  [hiccup.form :only [form-to text-field password-field label hidden-field submit-button]]
         [template.template :only [ get-template]]
         [db.db :only [get-user-by-username get-logged-users]]))

(defn home
  "display home page"
  []
  (get-template ":: Clojure Soundcloud ::"
                        
;        ubacivanje pesme na pocetnu stranicu
                
[:script {} "\n SC.initialize({ \n   client_id: '69fc8587cf1f1d3efcaab8c6720c6e95' \n     }); \n function loadMusic(){
       SC.get('/tracks', {limit: 1}, function(tracks){
         var track = tracks[0];
         SC.oEmbed(track.uri, document.getElementById('track'));
   }); \n  jQuery(\"table\").find(\"tr:odd\").css(\"background-color\", \"#EBEBEB\"); \n jQuery(\"table\").find(\"tr:even\").css(\"background-color\", \"white\");  };"]
        
;sc button

             [:div {:class "sc-connect-button", :style "margin-top: 30px; margin-right: auto; margin-left: auto; width: 1170px;"}
              [:a {:href "#", :id "connect-to-soundcloud", :class "sc-connect-button", :targer "_parent"}
               [:img {:border "0", :src "https://googledrive.com/host/0B9gNN6hownJNMk1OMVlEd2lyU00/btn-connect-l.png", :alt "Connect to SoundCloud"}]]]

             [:div {:class "container"} 
              [:div {:class "row"} 
               [:div {:class "span12"} 
                [:div {:class "content"} 
                 
;                 home
                 
                 [:section {:class "page", :id "home"} 
                  [:div {:class "page-header"} 
                   [:h1 {} "Welcome"]] 
                  [:p {}
                   "Welcome to my little Clojure project. This is simple student's project with wich you can connect to your soundcloud account and manage with all its' activities."]
                  [:p {:style "color: green; font-weight: bold; font-style: italic"} "Randomize generated track from soundcloud."]
                   [:div {:id "track"}]]
                 
;                 search
                 
                 [:section {:class "page", :id "search"} 
                  [:div {:class "page-header"} 
                   [:h1 {} "Search"]] 
                  [:input {:type "text", :id "search-field", :class "search-field"}]
                  [:br]
                  [:button {:id "btn-search", :class "btn btn-primary", :onclick "return search()"} "Search"]
                  [:button {:id "btn-clear-search", :class "btn btn-primary", :onclick "clearSearch()"} "Clear"]
                  [:br]
                  [:br]
                  [:div {:id "table-result", :class "table-result", :style "display: none;"}
                   [:table {}
                    [:thead {:style "color: blue; width: 100%; border-bottom: solid 1px;"}
                     [:tr
                      [:th {:width "390px;"} "Title"]
                      [:th {:width "390px;"} "Genre"]
                      [:th {:width "390px;"} "URL"]]]
                    [:tfoot {:style "width: 100%;"} ]]]
                   ]
                
;                 soundcloud account
                 
                 [:section {:class "page", :id "sc-account"} 
                  [:div {:class "page-header"} 
                   [:h1 {} "Soundcloud account"]]
                  [:p {} " " 
                   [:img {:class "avatar", :style " height: 100px; width: 100px", :id "avatar-sc-account", :src "https://googledrive.com/host/0B9gNN6hownJNMk1OMVlEd2lyU00/user-avatar.png"}]]
                  
                  [:div {:class "profile-left", :id "profile-left", :style "float: left; width: 25%; margin-bottom: 20px;"}
                  [:p {} "Full name: " ]
                   [:input {:type "text", :id "fullname-sc-account", :disabled "true"}]
                  [:p {} "Username: " ]
                   [:input {:type "text", :id "username-sc-account", :disabled "true"}]
                  [:p {} "Country: " ]
                   [:input {:type "text", :id "country-sc-account", :disabled "true"}]
                  [:p {} "City: " ]
                   [:input {:type "text", :id "city-sc-account", :disabled "true"}]
                  [:p {} "Website: " ]
                   [:input {:type "text", :id "website-link-sc-account", :placeholder "http://", :disabled "true"}]
                   [:p {} "Website title: " ]
                   [:input {:type "text", :id "website-title-sc-account", :disabled "true"}]
                   [:br]
                   [:br]
                   [:button {:id "btn-update-sc-account", :class "btn btn-primary", :disabled "true"} "Update"]]
                  
                  [:div {:class "profile-middle-1", :id "profile-middle", :style "float: left; width: 25%;"}
                  [:p {} "Playlists: " ]
                   [:textarea {:rows "5", :cols "50", :id "playlists-sc-account", :disabled "true"}]
                  [:p {} "Favorites: " ]
                   [:textarea {:rows "5", :cols "50", :id "favorites-sc-account", :disabled "true"}]
                  [:p {} "Follow: " ]
                   [:textarea {:rows "5", :cols "50", :id "follow-sc-account", :disabled "true"}]
                   ]
                  
                  [:div {:class "profile-middle-2", :id "profile-middle", :style "float: left; width: 25%;"}
                   [:p {} "Followers: " ]
                   [:textarea {:rows "5", :cols "50", :id "followers-sc-account", :disabled "true"}]
                   [:p {} "Tracks: " ]
                   [:textarea {:rows "5", :cols "50", :id "tracks-sc-account", :disabled "true"}]
                   [:p {} "Description: " ]
                   [:textarea {:rows "5", :cols "50", :id "description-sc-account", :disabled "true"}]
                   ]
                  
                  [:div {:class "profile-right", :id "profile-right", :style "float: left; width: 25%;"}
                   [:p {} "URL: " ]
                   [:a {:id "url-sc-account", :href="", :target "_blank"}]
                   [:p {} "Online: " ]
                   [:img {:id "online-sc-account", :src "https://googledrive.com/host/0B9gNN6hownJNMk1OMVlEd2lyU00/Status-user-busy-icon.png", :style "margin-bottom: 10px;"}]]]                 
                 
                 ]]]]))