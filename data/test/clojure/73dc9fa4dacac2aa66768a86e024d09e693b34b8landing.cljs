(ns app.landing
  (:require [hoplon.core :as h]
            [hoplon.jquery]))

(h/defelem landing-wrapper [attr kids]
  (h/div :id "page-wrapper" attr kids))

(h/defelem landing-banner [attr kids]
  (h/section :id "banner" attr
    (h/div :class [:inner]
      [(h/header (h/h2 (:header attr)))
       kids
       (h/footer
         (h/ul :class [:buttons :vertical]
           (h/li (h/a :href "#main" :class [:button :fit :scrolly] (:button attr)))))])))

(h/defelem landing-main [attr kids]
  (h/article :id "main" attr kids))

(h/defelem main-header [attr kids]
  (h/header :class [:special :container] attr
    [(h/span :class [:icon (:icon attr)]) kids]))

(h/defelem main-promo [attr kids]
  (h/section :class [:wrapper :style2 :container :special-alt] attr
    (h/div :class "row 50%"
      (h/div :class "8u 12u(narrower)"
      [(h/header (h/h2 (:header attr)))
       kids
       (h/footer
         (h/ul :class [:buttons]
           (h/li (:button attr))))])
      (h/div :class "4u 12u(narrower) important(narrower)"))))

(h/defelem main-features [attr kids]
  (h/section :class [:wrapper :style1 :container :special]
    (h/div :class "row"
      kids)))

(h/defelem feature [attr kids]
  (h/div :class "4u 12u(narrower)"
    (h/section
      (h/span :class [:icon :featured (:icon attr)])
      (h/header (h/h3 (:header attr)))
      kids)))

(h/defelem landing-cta [attr kids]
  (h/section :id "cta"
    (h/header (:header attr))
    (h/footer
      (h/ul :class [:buttons]
        (h/li (:button attr))))))

(h/defelem landing-footer [attr kids]
  (h/section :id "footer"
    (h/ul :class [:copyright]
      kids)))

(h/defelem landing [attr kids]
  (landing-wrapper
    (landing-banner
      :header "CANNABIT"
      :button "Tell Me More"
      (h/p "Smart " (h/strong "LP") " Solutions."))
    (landing-main
      (main-header
        :icon "fa-cogs"
        (h/h2 "Smart Solutions for " (h/strong "Licensed Producers"))
        (h/br)
        (h/p "Our " (h/strong "Platform") " provides a " (h/strong "Complete Solution")
             " for Licensed Producers to manage their operations."
             (h/br)
             "Including " (h/strong "ACMPR Compliance") ", " (h/strong "Building Management") " and " (h/strong "Seed to Sale") " software."))
      (main-promo
        :header (h/strong "Free 1-Year License")
        :button (h/a :class [:typeform-share :button] :href "https://degree9.typeform.com/to/wv4Lnz" :data-mode "popup" :target "_blank" "Early Access")
        (h/p "All " (h/strong "Early Access Partners") " will receive " (h/strong "1-Year of Free Access") " to the Cannabit Platform."))
      (main-features
        (feature :icon "fa-tasks" :header "ACMPR Compliance"
          "Track ACMPR Progress and Compliance.")
        (feature :icon "fa-building-o" :header "Building Management"
          "Industrial IOT Solutions provide insight into building operations and help reduce costs, and increase efficiency.")
        (feature :icon "fa-shopping-cart" :header "Seed to Sale"
          "Exceptional oversight of the complete Seed to Sale process."))
      )
    (landing-cta
      :header (h/h2 "Contact a "(h/strong "solution expert") " today.")
      :button (h/a :class [:typeform-share :button] :href "https://degree9.typeform.com/to/wv4Lnz" :data-mode "popup" :target "_blank" "Contact Us"))
    (landing-footer
      (h/li "© 2017 Cannabit Tech Inc.")
      (h/li "POWERED BY: " (h/a :href "http://degree9.io" "DEGREE9")))
    (h/script "(function() { var qs,js,q,s,d=document, gi=d.getElementById, ce=d.createElement, gt=d.getElementsByTagName, id=\"typef_orm_share\", b=\"https://embed.typeform.com/\"; if(!gi.call(d,id)){ js=ce.call(d,\"script\"); js.id=id; js.src=b+\"embed.js\"; q=gt.call(d,\"script\")[0]; q.parentNode.insertBefore(js,q) } })()")
    ))
