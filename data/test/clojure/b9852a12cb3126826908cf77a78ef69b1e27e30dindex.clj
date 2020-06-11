(ns homepage.index
  (:use
    [hiccup.core :only (html)]
    [hiccup.page :only (html5 include-css include-js)])
  (:require
    [clojure.string :as s]
    [homepage.integrations :refer
     [google-analytics hubspot-analytics inspectlet]]
    [config :refer [config]]))

(def www-url (config :www-url))
(def node-appboard-url (config :node-appboard-url))

(def intro
  {:header     "The complexity of mobile made easy"
   :sub-header "Mobile Workflow Management"})

(def overview
  {:fe     [{:header     "Not sure what to build?"
             :sub-header "Or who should build it?"
             :link       (str www-url "/appbuilder")
             :link-text  "Go to App Builder"}
            {:header "Is your organisation performing as well as you would like in mobile?"
             :link   (str www-url "/appboard")}
            {:header "Want your apps to have more impact?"
             :link   (str www-url "/appboard")}]
   :header "The AppBoard"

   :le     [{:header "Less Hassle"
             :text   "Secure dashboard with tools, analytics +
               resources for your team"}
            {:header "More Power"
             :text   "Business intelligence to make smarter
               decisions and improve your ROI"}
            {:header "Better Apps"
             :text   "Be guided through defining an app + get matched with
               3 great development companies"}]})

(def testimonials
  [{:photo       "/img/testimonials/richard-sofer.png"
    :logo        "/img/testimonials/every-hotels.jpg"
    :name        "Richard Sofer"
    :title       "Brand CEO, every hotels"
    :testimonial "I give them credit for teaching me everything
                 I know about APIs! It has been a great partnership,
                 they are smart, responsive and the access to apps
                 made us think about our brands very differently
                 in terms of what we could be doing in digital.
                 On top of the work on APIs and APPs they have
                 also been great at 'thought-provoking' with our
                 brand and technology innovation and are ALWAYS
                 and excellent resource for up to date thinking
                 and industry insight."}

   {:photo       "/img/testimonials/christopher-david.png"
    :logo        "/img/testimonials/schneider-electric.png"
    :name        "Christopher David"
    :title       "CTO Digital Customer Experience & SVP Software,
           Schneider Electric"
    :testimonial "Managing developers was crucial to our business.
                        Exicon helped us build the foundation on which to
                        drive our new products, bringing new developers
                        into our prefered developer programs in over
                        20 countries which helped us generate a whole
                        suite of local applications for the different
                        markets."}

   {:photo       "/img/testimonials/aran-dadswell.png"
    :logo        "/img/testimonials/get-to-know-your-brain.png"
    :name        "Aran Dadswell"
    :title       "Founder of Get to know your Brain"
    :testimonial "Wow, great service - thanks! Thanks a million!
                 Thanks for your support so far - we're
                 getting close now!"}])

(def appboard
  {:header     "AppBoard"
   :sub-header "The Command Center for your app(s)"
   :text       "Business intelligence and tools to help your team take
         action on your app portfolio"
   :img        "http://cdn2.hubspot.net/hubfs/511335/website/appboard/magnifying-appboard.png"
   :cta        (str www-url "/pricing/")})

(def customers
  {:header "Our customer portfolio speaks for itself"
   :img    "/img/landing-page/customers.png"})

(def footer
  [{:header "Company"
    :items  [{:text "About Us"
              :link (str www-url "/about-us/")}
             {:text "Customers"
              :link (str www-url "/customers/")}
             {:text "Media & Press"
              :link (str www-url "/news/")}
             ]}
   {:header "Products"
    :items  [{:text "ApiAxle"
              :link "http://apiaxle.com/"}
             {:text "AppBuilder"
              :link (str www-url "/appbuilder/")}
             {:text "AppBoard"
              :link (str www-url "/appboard/")}
             ]}
   {:header "Developers"
    :link   (str www-url "/developers/")}
   {:header "Legal"
    :items  [{:text "Privacy"
              :link (str www-url "/privacy-policy/")}
             {:text "Terms & Conditions"
              :link (str www-url "/terms-of-use/")}]}
   {:header "Follow Us"
    :items  [{:image "/img/footer/white-g.png"
              :link  "https://plus.google.com/115123733707845359729/posts"}
             {:image "/img/footer/white-fb.png"
              :link  "https://www.facebook.com/exicon.mobi"}
             {:image "/img/footer/white-twitter.png"
              :link  "https://twitter.com/exicon"}
             {:image "/img/footer/white-linkedin.png"
              :link  "http://www.linkedin.com/company/exicon-ltd-"}
             {:image "/img/footer/white-youtube.png"
              :link  "https://www.youtube.com/user/Exicon1"}
             {:image "/img/footer/white-pinterest.png"
              :link  "http://www.pinterest.com/exicon/pins/follow/?guid=CqzN7JCYsQQy-0"}]}])

(def top-nav
  [{:text "Calculator"
    :link (str www-url "/app-idea/#calculate")}
   {:text "AppBuilder"
    :link (str www-url "/appbuilder/")}
   {:text "AppBoard"
    :link (str www-url "/appboard/")}
   {:text "Pricing"
    :link (str www-url "/pricing/")}
   {:text "Blog"
    :link "http://blog.exiconglobal.com/"}
   {:text "Resources"
    :link (str www-url "/reports/")}
   {:text "About Us"
    :link (str www-url "/about-us/")}])

(defn hide-menu []
  [:script {:type "text/javascript"}
   "function closeMenu(){\n  document.getElementById('nav-trigger').checked = false;\n}"])

(defn render [{global-meta :meta posts :entries}]
  (html5
    {:lang "en"}
    [:head
     [:meta {:charset "utf-8"}]
     [:meta {:http-equiv "X-UA-Compatible" :content "IE=edge,chrome=1"}]
     [:meta {:name "viewport" :content "width=device-width, initial-scale=1.0, user-scalable=no"}]
     [:meta {:itemprop "author" :name "author" :content "Exicon (admin@exiconglobal.com)"}]
     [:meta {:name    "keywords" :itemprop "keywords"
             :content "Manage Apps, Exicon, App Management, Mobile Relationship Management,
                      What Is Mobile Relationship Management, MRM, AppBoard,
                      Find The Right Developer, Mobile App Strategy, Do I Need Mobile
                      Analytics, Best Tool for Mobile App Analytics, Digital
                      Asset Management"}]
     [:meta {:name    "description" :itemprop "description"
             :content "Exicon AppBoard Is An App Management Platform That Helps
                      SMEs & Enterprises Build, Manage & Promote Their Mobile Apps."}]
     [:title "Manage Your Apps | Exicon | Mobile Relationship Management | AppBoard"]
     [:link {:rel "shortcut icon" :href "/img/favicon.ico"}]
     (include-css "/css/site.css")
     (google-analytics)
     (hubspot-analytics)
     (inspectlet)
     (hide-menu)]

    [:body {:onresize "closeMenu()"}

     [:ul#mobile-nav.navigation
      [:li [:a {:href (str www-url "/pricing/")} "Sign Up"]]
      [:li [:a {:href node-appboard-url} "Login"]]
      (for [item top-nav]
        [:li {:onclick "closeMenu()" :class "nav-item"}
         [:a {:href (:link item)}
          (:text item)]])]

     [:div#top-nav
      [:img.item {:src "/img/exicon-logo.png"}]
      [:div.item
       (for [item top-nav]
         [:a {:href (:link item)}
          (:text item)])]
      [:div.item
       [:a.top-nav-button {:href (str www-url "/pricing/")} "Sign Up"]
       [:a {:href node-appboard-url} "Login"]]]

     [:input.mobile-nav {:type "checkbox" :id "nav-trigger" :class "nav-trigger"}]
     [:label.mobile-nav {:for "nav-trigger"}]
     [:img.mobile-logo {:src "/img/exicon-logo.png"}]
     [:div.mobile-top-bar]

     [:div.main.site-wrap
      [:div#intro
       [:div.container.column.centered
        [:div
         [:h1 (s/upper-case (:header intro))]
         [:h2 (:sub-header intro)]]
        [:iframe.embed-video {:frameborder     "0"
                              :src             "https://www.youtube.com/embed/ajPA6AhUilI?loop=1&playlist=ajPA6AhUilI"
                              :allowfullscreen true
                              :fullScreen      true}]]]

      [:section#overview
       [:div.container.hor-centered.row
        (for [item (:fe overview)]
          [:h3.item (:header item)
           (when (:sub-header item)
             [:span
              [:br]
              (:sub-header item)])
           [:br]
           [:a {:href (:link item)}
            (if (:link-text item)
              (:link-text item)
              "Find out more..")]])]]

      [:div.container.divider]

      [:section#appboard
       [:div.container.column.centered
        [:div.header
         [:h2 (:header appboard)
          [:br]
          (:sub-header appboard)]
         [:h3 (:text appboard)]]]
       [:div.container.vert-centered.row
        [:div.basis-item.centered.screenshot
         [:img.image {:src (:img appboard)}]]
        [:div.basis-item
         [:div.container.overview.row
          (for [item (:le overview)]
            [:div.appboard-item
             [:b [:h3 (:header item)]]
             [:div (:text item)]])]
         [:div.container.row.cta
          [:div.item]
          [:div.item
           [:a.button {:href (str www-url "/appboard")}
            "Find out more"]]
          [:div.item
           [:a.button {:href (:cta appboard)}
            "Get started now"]]
          [:div.item]]]]]

      [:section#testimonials
       [:div.container.row
        (for [item testimonials]
          [:div.item.segment
           [:img {:src (:photo item)}]
           [:img.right-img {:src (:logo item)}]
           [:div [:b (:name item)]]
           [:div (:title item)]
           [:p
            [:i (:testimonial item)]]
           ])]]

      [:section#customers
       [:div.container.column.centered
        [:h2 (:header customers)]
        [:div.container.centered
         [:div.item
          [:img.image {:src (:img customers)}]]]]]

      [:div#footer
       [:div.container.row
        (for [elem footer]
          [:div.item
           [:div [:b (:header elem)]]
           (for [item (:items elem)]
             (if (:image item)
               [:a {:href   (:link item)
                    :target "_blank"}
                [:img {:src (:image item)}]]
               [:div
                [:a {:href (:link item)}
                 (:text item)]]))])]]]]))

