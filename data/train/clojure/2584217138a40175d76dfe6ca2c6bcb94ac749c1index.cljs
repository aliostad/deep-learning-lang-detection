(ns ^{:hoplon/page "index.html"} app.index
  (:require [hoplon.core :as h]
            [hoplon.jquery]
            [uikit-hl.align :as a]
            [uikit-hl.button :as b]
            [uikit-hl.card :as c]
            [uikit-hl.container :as cont]
            [uikit-hl.description-list :as dl]
            [uikit-hl.flex :as flex]
            [uikit-hl.grid :as grid]
            [uikit-hl.icon :as i]
            [uikit-hl.margin :as m]
            [uikit-hl.padding :as p]
            [uikit-hl.text :as t]
            [uikit-hl.utility :as util]
            [uikit-hl.width :as width]
            [meta.ui.uikit :as uik]))

(h/defelem card [attr kids]
  (
    (let [{:keys [header body footer]} attr]
      (cond-> []
        header (conj (c/header header))
        body   (conj (c/body   body))
        footer (conj (c/footer footer))))))

(h/html
  (h/head
    ;(h/link :rel "stylesheet" :href "https://cdnjs.cloudflare.com/ajax/libs/uikit/3.0.0-beta.25/css/uikit.min.css")
    (h/link :rel "stylesheet" :href "css/theme.css")
    )
  (h/body
    (cont/container
        (grid/grid :flex-middle true :child-width-1-3 true :uk-height-viewport true :match true :uk-height-match "target: > div > div"
          (grid/cell
            (c/card :default true
              (c/header
                (grid/grid :small true :flex-middle true
                  (grid/cell :width-auto true (h/img :width "40px" :height "40px" :src "https://pbs.twimg.com/profile_images/749758739494961152/0H4f4o4O_400x400.jpg"))
                  (grid/cell :width-expand true
                    [(c/title :margin-remove-bottom true "Degree9 Solutions Inc.")
                     (t/text :meta true :margin-remove-top true "DevOps & IT Automation Solutions")])))
              (c/body
                [(h/p "Founded in 2014 we provide DevOps and IT Automation solutions to enterprise clients.")
                 (h/p "Degree9 maintains an \"Open-Source Everything\" approach to software development and technology. ")
                 (h/p "All of our work is published on Github and available under the MIT license.")])
              (c/footer
                (b/group :align-right true
                  (b/a-button :primary true "Open-Source" :href "http://github.com/degree9")
                  (b/a-button :secondary true "Dev Blog" :href "http://medium.com/degree9")))))
          (grid/cell
            (c/card :default true  :css {:height "480px"}
              (c/header
                [(c/title :margin-remove-bottom true "Solutions")
                 (t/text :meta true :margin-remove-top true "powered by D9 Enterprise Platform")])
              (h/div :uk-inline true
                [(h/img :src "images/cannabit.png")])
              (c/body
                [(h/p "Cannabit is an Enterprise Management Software for Canadian Licensed Producers of Medical Marijuana.")])))
          (grid/cell
            (c/card :default true
              (c/header
                [(c/title :margin-remove-bottom true "D9 Enterprise Platform")
                 (t/text :meta true :margin-remove-top true "Functional Enterprise Platform-as-a-Service")])
              (c/body
                (grid/grid :small true
                  (grid/cell
                    [(t/text :margin-remove-bottom true (i/icon :icon "check") "Shipped as Code")
                     (t/text :meta true :margin-remove-top true "Shipped as Source Code Repository")])
                  (grid/cell
                    [(t/text :margin-remove-bottom true (i/icon :icon "check") "Continuous Deployment")
                     (t/text :meta true :margin-remove-top true "Automatically build and deploy enterprise applications")])
                  (grid/cell
                    [(t/text :margin-remove-bottom true (i/icon :icon "check") "Modern Lisp")
                     (t/text :meta true :margin-remove-top true "Built entirely using Clojure + ClojureScript")])))
              (c/footer
                [(b/group :align-right true
                 (b/button :disabled true :primary true "Manage" :click #(prn "contact us modal")))])))))))
