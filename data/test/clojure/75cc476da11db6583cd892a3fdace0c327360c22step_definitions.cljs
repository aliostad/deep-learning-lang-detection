(ns jiksnu.step-definitions
  (:require [jiksnu.helpers.action-helpers :as helpers.action]
            [jiksnu.helpers.http-helpers :as helpers.http]
            [jiksnu.helpers.page-helpers :as page-helpers
             :refer [by-css by-model current-page element expect]]
            [jiksnu.pages.LoginPage :as lp :refer [LoginPage login]]
            [jiksnu.pages.RegisterPage :refer [RegisterPage]]
            [jiksnu.PageObjectMap :as pom]
            [taoensso.timbre :as timbre])
  (:use-macros [jiksnu.step-macros :only [step-definitions Given When Then And]]))

(step-definitions

 (timbre/info "loading core spec")

 (this-as this (.setDefaultTimeout this (page-helpers/seconds 60)))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (Given #"^a user exists with the password \"([^\"]*)\"$" [password next]
   (helpers.action/register-user)
   (next))

 (Given #"^another user exists$" [next]
   (helpers.action/register-user "test2")
   (next))

 (Given #"^I am (not )?logged in$" [not-str next]
   (timbre/infof "Not str: %s" not-str)
   (if (empty? not-str)
     (.. (helpers.action/login-user) (then next))
     (do
       (timbre/info "Deleting all cookies")
       (.. js/browser manage deleteAllCookies (then next)))))

 (Given #"^I am at the \"([^\"]*)\" page$" [page-name next]

   (timbre/infof "Page: %s" page-name)

   (timbre/infof "Url: %s" (current-page) )

   (let [page-object (aget pom/pages page-name)]
     (timbre/infof "Page object: %s" page-object)
     (.. (page-object.) get (then next))))

 (Given #"^I am logged in as a normal user$" [next]
   (.. js/browser manage deleteAllCookies)
   (.. (helpers.action/login-user) (then next)))

 (Given #"^I am logged in as an admin$" [next]
   (.click (js/$ ".logout-button"))
   (next))

 (Given #"^that user posts an activity$" [next]

   (.click (element (by-css "#placeholderInput")))

   (element (.css js/by ""))

   (.sendKeys (by-model "activity.content") "drvfdgdfgdfsgdf")

   (next))

 (Given #"^there is a public activity" [next]
   (-> (helpers.http/an-activity-exists)
       (.then (fn [] (next)))))

 (Given #"^there is a user$" [next]
   (.. (helpers.http/user-exists? "test")
       (then (fn [a] true)
             (fn [a] (helpers.action/register-user)))
       (then next)))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (When #"^I click the \"([^\"]*)\" button for that user$" [button-name next]
   (.pending next))

 (When #"^I go to the \"([^\"]*)\" page for that user$" [page-name next]
   (.pending next))

 (When #"^I log out$" [next]
   (.. js/browser
       (wait (fn []
               (.. element
                   (all (by-css ".ui-notification"))
                   (count)
                   (then (fn [c] (zero? c)))))))
   (let [locator (element (by-css ".logout-button"))]
     (.. locator click (then (fn [] (next))))))

 (When #"^I put my password in the \"([^\"]*)\" field$" [field-name next]
   (let [page (LoginPage.)]
     (.waitForLoaded page)
     (-> (lp/set-password page "test")
         (.then (fn [] (next))))))

 (When #"^I put my username in the \"([^\"]*)\" field$" [username next]
   (timbre/info "putting username")
   (let [page (LoginPage.)]
     (.waitForLoaded page)
     (-> (lp/set-username page "test")
         (.then (fn [] (next))))))

 (When #"^I request the user\-meta page for that user with a client$" [next]
   (.pending next))

 (When #"^I submit that form$" [next]
   (.pending next))

 (When #"^that user should be deleted$" [next]
   (.pending next))

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 (Then #"^I should be an admin$" [next]
   (.pending next))

 (Then #"^I should be at the \"([^\"]*)\" page$" [page-name next]
   (timbre/debugf "Asserting to be at page - %s" page-name)
   (.. (expect "home")
       -to -eventually (equal page-name)
       -and (notify next)))

 (Then #"^I should be logged in$" [next]
   (.. js/browser
       (sleep 500)
       (then (fn []
               (timbre/info "Fetching Status")
               (.. (expect (page-helpers/get-username))
                   -to -eventually (equal "test")
                   -and (notify next))))))

 (Then #"^I should not be logged in$" [next]
   (.pending next))

 (Then #"^I should not see a \"([^\"]*)\" button for that user$" [button-name next]
   (let [class-name (str "." button-name "-button")]
     (timbre/infof "Class Name: %s" class-name)
     (.. (expect (-> (by-css class-name) element .isPresent))
         -to -eventually -be -false))
   (next))

 (Then #"^I should see (\d+) users$" [n next]
   (.. (expect (.count (.all element (by-css "show-user-minimal"))))
       -to -eventually (equal (int n))
       -and (notify next)))

 (Then #"^I should see a form$" [next]
   (.. (expect (js/$ "form")) -to -exist)
   (next))

 (Then #"^I should see a list of users$" [next]
   (.pending next))

 (Then #"^I should see an activity$" [next]
   (let [article-element (element (by-css "article"))]
     (timbre/infof "checking activity - %s" article-element)
     (.. (expect (.isPresent article-element))
         -to -eventually (equal true)))
   (next))

 (Then #"^I should see that activity$" [next]
   (.pending next))

 (Then #"^I should wait$" [next]
   ;; http://www.lifeway.com/n/Product-Family/True-Love-Waits
   (.pause js/browser)
   (next))

 (Then #"^it should have a \"([^\"]*)\" field$" [field-name next]
   (.. (expect (js/$ (str "*[name=" field-name "]"))) -to -exist)
   (next))

 (Then #"^that user's name should be \"([^\"]*)\"$" [user-name next]
   (.pending next))

 (Then #"^the alias field matches that user's uri$" [next]
   (.pending next))

 (Then #"^the content\-type is \"([^\"]*)\"$" [content-type next]
   (.pending next))

 ;; (sic)
 (Then #"^the response is sucsessful$" [next]
   (.pending next))

 )
