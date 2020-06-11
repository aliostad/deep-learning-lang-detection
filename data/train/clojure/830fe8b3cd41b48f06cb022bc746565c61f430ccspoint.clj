;;; Sales point views
(ns blog.views.spoint
  (:use blog.views.common
        noir.core
        [hiccup.element :only [link-to image]]))

(defpartial row-divider []
  [:div.row
   [:hr]])

(defpartial title []
  [:div.row
   [:h1 "Sales point and admin site"]
   [:p "This system allows for the administration of a small or medium business and has the ability to function as a cashier. It works over the internet or locally. Any computer with a modern web browser can run it. And it supports common devices such as barcode scanners and ticket printers."]
   [:p "A list of features follows:"]])

(defpartial cashier-feature []
  [:div.row
   [:div.twelve.columns.product-feature
    [:div.four.columns.feature-description
     [:h2 "Cashier"]
     [:p "A fully featured cashier, beautiful and simple."]
     [:ul.feature-description-list
      [:li "Fully controllable by keyboard and barcode scanner; although a mouse can help."]
      [:li "Easy to use interface that requires minimal training."]
      [:li "Permits the adding of miscelaneous articles not found in the database."]
      [:li "Includes more options, more intuitive and pleasant than a common sales point as it uses the full power of modern web graphical tools."]]]
    [:div.eight.columns.feature-image
     (image "/images/sp-pitch.png" "Cashier")]]])

(defpartial ticket-feature []
  [:div.row
   [:div.twelve.columns.product-feature
    [:div.four.columns.feature-description
     [:h2 "Tickets & Bills"]
     [:p "Allows for the printing of either. Works with conventional printers. If the device can be plugged in to your computer, the system can use it."]]
    [:div.eight.columns.feature-image
     (image "/images/sp-ticket.png" "Ticket")]]])

(defpartial articles-feature []
  [:div.row
   [:div.twelve.columns.product-feature
    [:div.four.columns.feature-description
     [:h2 "User-centered design"]
     [:p "Personalized administration of products according to the user's needs."]
     [:ul.feature-description-list
      [:li "Fully featured admin system."]
      [:li "Personalized options."]
      [:li "The required information, accessible in the fastest and clearest manner possible."]]]
    [:div.eight.columns.feature-image
     (image "/images/sp-search.png" "Search results")]]])

(defpartial dataquality-feature []
  [:div.row
   [:div.twelve.columns.product-feature
    [:div.four.columns.feature-description
     [:h2 "The system can work with your existing database"]
     [:p "It provides an easy transition for your working database and grants easy tools for the creation of one in case you don't have one."]
     [:ul.feature-description-list
      [:li "Tools for quality control of your data."]
      [:li "Allows you to detect errors and fix them in an easy way."]
      [:li "Personalized criteria to keep your database in good shape."]]]
    [:div.eight.columns.feature-image
     (image "/images/sp-dberrors.png" "Fix database errors")]]])

(defpartial backups-feature []
  [:div.row
   [:div.twelve.columns.product-feature
    [:div.four.columns.feature-description
     [:h2 "A great backup & restore system"]
     [:p "Choose where and when to restore your business data"]
     [:ul.feature-description-list
      [:li "Automatic or manual backups."]
      [:li "Easy to start working from a backup."]]]
    [:div.eight.columns.feature-image
     (image "/images/sp-backups.png" "Database backups")]]])

(defpartial security-feature []
  [:div.row
   [:div.twelve.columns.product-feature
    [:div.four.columns.feature-description
     [:h2 "Built with security as a main concern."]
     [:p "User accounts system."]
     [:ul.feature-description-list
      [:li "Each account customizable with their own rights."]
      [:li "Protection against unwanted access."]]]
    [:div.eight.columns.feature-image
     (image "/images/sp-security.png" "System security")]]])

(defpartial platforms-feature []
  [:div.row
   [:div.twelve.columns.product-feature
    [:div.four.columns.feature-description
     [:h2 "Multiplatform system"]
     [:p "Works on Windows, Mac OS and Linux, with a modern web browser."]
     [:ul.feature-description-list
      [:li "The system can be distributed or contained completely in a single computer."]
      [:li "Each computer can have its own operating system, including mobile!"]
      [:li "The experience is the same for any desktop platform."]
      [:li "Manage your business from your mobile phone or tablet."]]]
    [:div.eight.columns.feature-image
     (image "/images/sp-platforms.png" "Multiplatform system")]]])

(defpartial main-section []
  [:section.main
   (title)
   (row-divider)
   (cashier-feature)
   (ticket-feature)
   (articles-feature)
   (dataquality-feature)
   (backups-feature)
   (security-feature)
   (platforms-feature)])

(defpage "/sales-point/" []
  (base-layout {:content (main-section)
                :active "Company"}))