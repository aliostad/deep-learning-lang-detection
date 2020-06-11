(ns softwarebears.routes.portfolio
  (:require [compojure.core :refer :all]
            [hiccup.element :refer [image link-to]]
            [softwarebears.views.layout :as layout]))

(defn alsi []
  [:section.colorful.purple
    [:h2#alsi "Advanced Life Support Institute"]
    [:div
      [:h3 "A modern design"]
      [:p "Software Bears delivered a modern design that focuses on content first. The latest web technologies, HTML 5 and CSS 3, were used."]
      [:figure
        (link-to "/img/alsi_new.png" (image "/img/alsi_new.png" "Screenshot of www.alsi.org"))]]
    [:h4#alsi-less.less
      (link-to "#" "Read more &gt;&gt;&gt;")]
    [:div#alsi-more.more
      {:style "display:none;"}
      [:p "This replaced a website that looked dated, having been designed in 2006."]
      [:h3 "The client's message, streamlined"]
      [:p "Software Bears organized ALSI's content to tell their story. Important messages were brought to the users' attention with dramatic, bold text. With their previous design, ALSI's message was buried in a wall of text."]
      [:p "Take a look at the new design, with important messages highlighted:"]
      [:figure
        (link-to "/img/alsi_text_new.png" (image "/img/alsi_text_new.png" "Highlighted statements on new www.alsi.org"))]
      [:p "Now compare that to the old design, where the statements from the new design are highlighted with the same colors. Their message was unclear, buried in a wall of text."]
      [:figure
        (link-to "/img/alsi_text_old.png" (image "/img/alsi_text_old.png" "Highlighted statements on old www.alsi.org"))]
      [:h3 "A complete website, integrated with a custom CMS"]
      [:p "Software Bears provided eight pages with a consistent design. This gives the user a familiar experience across the entire website."]
      [:p "Additionally, the custom CMS allows ALSI to easily create events that are visible in multiple places on their website. Each event has a page with a unique URL, so they can easily be shared on social media. Shown below is the calendar page, which ALSI's upcoming and past events."]
      [:figure
        (link-to "/img/alsi_calendar.png" (image "/img/alsi_calendar.png" "Screenshot of www.alsi.org events calendar"))]
      [:h3 "Tools of the trade"]
      [:p [:strong "PHP"] " was used for a template that simplified each page's markup. Version 5.3 was used because of ALSI's server's limitations. PHP was also used for custom CMS, alongside " [:strong "MySQL"] " as the database for event storage. " [:strong "HTML 5"] " and " [:strong "CSS 3"] " were used for the design. " [:strong "JavaScript"] " was used to make certain elements of the design interactive. " [:strong "Git"] " is used for source code management."]
      [:h3 "Take a look"]
      [:p "ALSI's new website is live at " (link-to "http://alsi.org" "alsi.org") "."]
      [:h4 (link-to "#alsi" "Show less &gt;&gt;&gt;")]]])

(defn siol []
  [:section.colorful.teal
    [:h2#siol "7 Items or Less"]
    [:div
      [:h3 "A social media website with a twist"]
      [:p "Do you think that social media is fun, but some people share " [:em "too much"] "? Well then " [:em "7 items or less"] " is for you. As the name implies, users are limited to 7 posts per day."]
      [:figure
        (link-to "/img/siol_main.png" (image "/img/siol_main.png" "7 items or less home page"))]]
    [:h4#siol-less.less
      (link-to "#" "Read more &gt;&gt;&gt;")]
    [:div#siol-more.more
      {:style "display:none;"}
      [:p "Also, you can follow or un-follow anyone you want, because following is completely anonymous. Of course, for the sake of privacy, you can choose to approve who follows you, if you wish."]
      [:h3 "A profile for every user"]
      [:p "A unified feed for unauthenticated users. Account creation and login. Each user has their own feed with posts from users they follow, and each user has a profile page. From the profile page, users can approve pending follows if privacy mode is enabled."]
      [:figure
        (link-to "/img/siol_user.png" (image "/img/siol_user.png" "7 items or less user profile"))]
      [:p "Posts consist of any combination of a title, text, image, and a link. You can comment on posts. If you aren't in the mood for conversation, you can disable comments on a post. Also, you can edit and delete your previous posts."]
      [:h3 "Tools of the trade"]
      [:p "The website was written in " [:strong "Clojure 1.6"] " with use of the " [:strong "Ring"] ", " [:strong "Compojure"] ", and " [:strong "lib-noir"] " libraries. The " [:strong "Hiccup"] " library was used to write the HTML. The latest " [:strong "CSS 3"] " features were used for the design. All posts and user info was stored with " [:strong "PostgreSQL 9.x"] ". " [:strong "JavaScript"] " was used for asynchronous requests, such as comments and users follows. " [:strong "Leiningen"] " is used to manage builds. " [:strong "Git"] " is used for source code management."]
      [:h3 "Take a look"]
      [:p [:em "7 items or less"] " is live at " (link-to "https://7itemsorless.com/" "7itemsorless.com") "."]
      [:h4 (link-to "#siol" "Show less &gt;&gt;&gt;")]]])

(defn funner-summer []
  [:section.colorful.green
    [:h2#fs "Funner Summer, an Android app"]
    [:div
      [:h3 "Context-based activity suggestions"]
      [:p "Software Bears created Funner Summer, an Android app that suggests activities based on several factors: time of day, day of week, current weather, and whether you're alone, with someone else, or with a group. The app records your activities and uses your history to improve suggestions."]
      [:figure
        (link-to "/img/funner_main.png" (image "/img/funner_main.png" "Funner Summer home screen"))]]
    [:h4#fs-less.less
      (link-to "#" "Read more &gt;&gt;&gt;")]
    [:div#fs-more.more
      {:style "display:none;"}
      [:h3 "Hundreds of pre-loaded activities"]
      [:p "Funner Summer ships with over a hundred activity suggestions pre-loaded. However, users can enter their own activities. Then, the app can suggest these activities next time."]
      [:figure
        (link-to "/img/funner_create.png" (image "/img/funner_create.png" "Funner Summer activity creation"))]
      [:h3 "Privacy first"]
      [:p "Funner Summer records the history of a user's activities. This history can be shown to the user for reference, and it's used to improve subsequent suggestions. However, Software Bears values privacy. The activity history never leaves the user's mobile device."]
      [:figure
        (link-to "/img/funner_history.png" (image "/img/funner_history.png" "Funner Summer activity history"))]
      [:h3 "A modern REST API"]
      [:p "To obtain current weather conditions, the app leverages an external REST web service. The web service consumes from a third-party weather service that delivers weather conditions based on latitude and longitude. To reduce costs, Funner Summer's web server caches weather conditions internally. The service also groups similar latitudes and longitudes to further reduce the number of external API calls."]
      [:figure
        (link-to "/img/funner_activity.png" (image "/img/funner_activity.png" "Funner Summer activity screen"))]
      [:h3 "Tools of the trade"]
      [:p "The Android app targeted " [:strong "Android 4.1"] " and above. The app and web service were both written in " [:strong "Java 1.7"] ". Android's " [:strong "SQLite"] " database was used to store a user's activity history. The web service is a REST API, and it uses " [:strong "Jersey 2.x"] "'s JAX-RS implementation. The web service is hosted on " [:strong "Amazon EC2"] ". " [:strong "Maven 3"] " was used to manage builds. " [:strong "Git"] " is used for source code management."]
      [:h3 "Take a look"]
      [:p "Funner Summer is available in the " (link-to "https://play.google.com/store/apps/details?id=net.seabears.funner.summer" "Google play store") "."]
      [:h4 (link-to "#fs" "Show less &gt;&gt;&gt;")]]])

(defn portfolio []
  (layout/common
    [:div.intro.headline.full.trnp.plax.plax3
      [:p.middle "We helped these clients solve their problems. We can help you next."]]
    [:main
      [:section.white
        [:p "Please take a look at these samples from my public work. In addition, I have ten years of professional experience as a software engineer and web developer."]]
      (alsi)
      [:div.divider.trnp.plax.plax4]
      (siol)
      [:div.divider.trnp.plax.plax4]
      (funner-summer)]))

(defroutes portfolio-routes
  (GET "/portfolio" [] (portfolio)))
