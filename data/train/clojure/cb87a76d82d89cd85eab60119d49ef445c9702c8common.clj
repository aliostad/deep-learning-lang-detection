(ns CPG.views.common
  (:use [noir.core :only [defpartial]]
        [hiccup.page :only [include-css include-js html5]]
        [hiccup.element :only [link-to]]))

(def title "Competence Profile Generator")

(defn js-call [f & args]
  (let [args-formater #(if (string? %) (str "'" % "'") %)
        args (map args-formater args)]
    (str (name f) "(" 
         (clojure.string/join ", " args)
         ");")))

(defn onclick-link [tag-desc event & content]
  (->>
    content
    (cons {:href "#" :onclick event})
    (cons tag-desc)
    vec))

(defpartial nav-list [& coll]
  [:ul.nav (for [x coll] [:li x])])

(defn icon [a]
  [(keyword (str "i.icon-white.icon-" 
                 (name a)))]) 


(defpartial navbar []
  [:div.navbar.navbar-fixed-top
   [:div.navbar-inner
    [:div.container
     [:a.brand {:href "/"} title]
     (nav-list
      (link-to "/manage-data" (icon :list-alt) " Merge fields")
      (link-to "/manage-groups" (icon :tags) " Snippet groups")
      (link-to "/compose-profile" (icon :play-circle) " Make new profile"))]]])

(defpartial layout [& content]
  (html5
    [:head
     [:title title]
     (include-css "/css/bootstrap.min.css")
     [:style {:type "text/css"} "body { padding-top: 60px; padding-bottom:40px; }"]
     (include-js "/js/jquery.min.js")
     (include-js "/js/bootstrap.min.js")
     (include-js "/js/cpg.js")]
    [:body
     (navbar)
     [:div.container
      content
      [:hr]
      [:footer
       [:p "&copy; Torbjørn Marø"]]]]))
