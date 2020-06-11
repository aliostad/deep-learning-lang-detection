;; The functions in this namespace provide the necessary html pages
;; that the users will interact with.
(ns holytools.server.views.maps
  (:require [holytools.server.models :as models]
            [holytools.server.commons :as commons]
            [holytools.server.views.commons :as vc]
            [hiccup.element :as hice]))

;; try to improve performance by having hints when reflection is needed.
(set! *warn-on-reflection* true)

(defn canvas
  "Create the canvas elements for a map view."
  [mapdef]
  [:section.map
   [:canvas {:id "hiddencanvas"} " "]
   [:canvas {:id "discoveredcanvas"} " "]
   [:canvas {:id "mapcanvas"} " "]
   [:canvas {:id "objectcanvas"} " "]
   [:canvas {:id "markercanvas"} " "]
   [:script (str "setup('" mapdef "');")]])

(defn map-page
  "Render the page for a map."
  [charname mapdef]
  (.replaceFirst
    (vc/page-skeleton
      (str "map " mapdef)
      (canvas (str mapdef ".cljs")))
    "<html"
    (str "<html manifest=\"" mapdef "/manifest\" ")))

(defn managemaps-page
  "Render the list of maps and allow management of them."
  [charname]
  (vc/page-skeleton
    (str "manage maps")
    [:table
     [:tr
      [:td
       [:img {:src (str @commons/app-path "/images/logo.png")}]]
      [:td {:class "maps"}
       (for [e (models/list-available-maps)]
         [:div
          [:h2 {:class "title"} (:system e)]
          (for [fo (:folders e)]
            [:div
             [:p {:class "link"}
              (hice/link-to (str @commons/app-path "/managemaps/" (:system e) "/" (:name fo)) (:name fo))
              ]])
          [:br]])
       [:br]
       [:div {:id "clid"}]
       [:br]
       [:div
        [:p {:class "link" :onclick (str "createLocation('clid');")} [:img {:src (str @commons/app-path "/images/plus.png")}]]]
       [:br]
       [:div
        (hice/link-to (str @commons/app-path "/maps") "back to maps")]]]]
    (vc/footer "/" charname)))

(defn managemap-page
  "Show management options for a map."
  [charname folder subfolder]
  (let [files (models/load-map-files (str folder "/" subfolder))]
    (vc/page-skeleton
      (str "managing " subfolder)
      [:div {:class "title"} (str "Managing " folder " " subfolder)]
      [:form {:method "POST" :action ""}
       [:table {:style "width: 95%"}
        [:tr
         [:td {:class "subtitle" :style "width: 90%"} "Name"]
         [:td {:class "subtitle" :style "width: 30px"} "Show"]
         [:td {:class "subtitle" :style "width: 30px"} "Manage"]
         [:td {:class "subtitle" :style "width: 30px"} "Edit"]]
        (for [f files]
          [:tr
           [:td {:style "width: 90%"} f]
           [:td {:style "width: 30px"} (when (or (.endsWith ^String f ".jpg") (.endsWith ^String f ".png"))
                                         [:p {:class "link"}
                                          [:a {:href (str @commons/app-path "/managemaps/" folder "/" subfolder "/" f)}
                                           [:img {:src (str @commons/app-path "/images/page-pencil.png")}]]])]
           [:td {:style "width: 30px"} [:p {:class "link" :onclick (str "deletefile('" subfolder "/" f "');")} [:img {:src (str @commons/app-path "/images/cross.png")}]]]
           [:td {:style "width: 30px"} (when (.endsWith ^String f ".cljs")
                                         [:p {:class "link"}
                                          [:a {:href (str @commons/app-path "/managemaps/" folder "/" subfolder "/" f)}
                                           [:img {:src (str @commons/app-path "/images/page-pencil.png")}]]])]])
        [:tr
         [:td {:class "subtitle" :style "width: 90%"} [:div {:id "uplid"}]]
         [:td {:class "subtitle" :style "width: 30px"}
          [:div {:class "link" :onclick (str "uploadfile('" subfolder "', 'uplid');")}
           [:img {:src (str @commons/app-path "/images/plus.png")}]]]
         [:td {:class "subtitle" :style "width: 30px"} ""]]
        ]
       [:br]
       [:br]]
      (vc/footer-content (str "/managemaps") charname))))

(defn editor
  "Dispatch rendering a character based on the system."
  [charname folder subfolder file]
  (let [c (slurp (str @commons/mapsdir folder "/" subfolder "/" file ".cljs"))]
    (vc/page-skeleton
      (str "editing " file)
      [:div {:class "title"} (str "Editing " file)]
      [:form {:method "POST" :action (str @commons/app-path "/managemaps/" folder "/" subfolder "/" file ".cljs/update")}
       [:textarea {:id "editor" :name "map" :rows "20"} c]
       [:br]
       [:input {:type "submit" :class "submit" :value "save"}]
       ]
      (vc/footer-content (str "/managemaps/" folder "/" subfolder) charname))))
