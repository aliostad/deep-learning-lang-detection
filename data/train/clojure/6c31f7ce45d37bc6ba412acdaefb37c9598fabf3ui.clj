(ns katello.ui
  (:require [katello.rest :as rest]
            [webdriver :as wd]
            [clj-webdriver.taxi :as browser])
  (:refer-clojure :exclude [read]))

;; Protocols

(defprotocol CRUD
  "Create/read/update/delete operations on katello entities via the UI"
  (create [x] "Create an entity in the UI")
  (read [x] "Get details on an entity from the UI")
  (update* [x new-x] "Change an existing entity in UI, from x to new-x")
  (delete [x] "Delete an existing entity in the UI"))

(defrecord Notification [validationErrors notices level])

;; because protocols don't support varargs
(defn update [x f & args]
  (let [updated (apply f x args)]
    (update* x updated)
    updated))

;;convenience
(defn create-all [ents]
  (doseq [ent ents]
    (create ent)))

(defn ensure-exists [ent]
  {:pre [(satisfies? CRUD ent)]}
  (when-not (or (rest/exists? ent) (instance? katello.Provider ent))
    (create ent)))

(defn create-recursive
  "Recursively create in katello, all the entites that satisfy
   katello.ui/CRUD (innermost first).  Example, an env that contains
   a field for its parent org, the org would be created first, then
   the env." [ent & [{:keys [check-exist?] :or {check-exist? true}}]]
   (doseq [field (vals ent) :when (satisfies? CRUD field)]
     (create-recursive field))
   (if check-exist? 
     (ensure-exists ent)
     (create ent)))

(defn create-all-recursive [ents & [{:keys [check-exist?] :as m}]]
  (doseq [ent ents]
    (create-recursive ent m)))

;; Locators
(def menu-template
  (partial format "//a[contains(@class,'%s') and normalize-space(.)='%s']"))

(def menu-link (partial menu-template "menu-item-link"))
(def menu-dropdown-link (partial menu-template "dropdown-item-link"))
(def menu-flyout-link (partial menu-template "flyout-item-link"))

(wd/template-fns
 {button-div           "//div[contains(@class,'button') and normalize-space(.)='%s']"  
  editable             "//div[contains(@class, 'editable') and descendant::text()[substring(normalize-space(),2)='%s']]"
  environment-link     "//div[contains(@class,'jbreadcrumb')]//a[normalize-space(.)='%s']"
  left-pane-field-list "//div[contains(@class,'left')]//div[contains(@class,'ellipsis') or @class='block tall'][%s]"
  link                 "//a[normalize-space(.)='%s']"
  remove-link          "//a[@class='remove_item' and contains(@href,'%s')]"
  third-level-link     "//*[@id='%s']/a"
  select-system        "//td[@class='ng-scope']/a[contains(text(), '%s')]"
  js-id-click          "$(\"li#%s > a\").click();"
  search-favorite      "//span[contains(@class,'favorite') and @title='%s']"
  slide-link           "//li[contains(@class,'slide_link') and normalize-space(.)='%s']"
  tab                  "link=%s"
  textbox              "xpath=//*[self::input[(@type='text' or @type='password' or @type='file') and @name='%s'] or self::textarea[@name='%<s']]"
  default-star         "//ul[@id='organizationSwitcher']//a[normalize-space(.)='%s']/../i[contains(@id,'favorite')]"
  switcher-link        "//ul[@id='organizationSwitcher']//li//a[normalize-space(.)='%s' and contains(@class, 'org-link')]"
  custom-keyname-list  "xpath=(//td[@class='ra']/label[contains(@for, 'default_info') or contains(@for, 'custom_info')])[%s]"
  custom-value-list    "xpath=(//td/div[@class='editable edit_textfield'])[%s]"})

;;
;; Tells the clojure selenium client where to look up keywords to get
;; real selenium locators.
;; Note, it's designed this way, rather than one big map, so that
;; errors in one component namespace (eg activation keys) don't
;; prevent others from being worked on.
;;
(derive :katello.deployment/katello :katello.deployment/any)
(derive :katello.deployment/headpin :katello.deployment/any)

(defn current-session-deployment []
  (if (rest/is-katello?)
    :katello.deployment/katello
    :katello.deployment/headpin))

(defn component-deployment-dispatch
  "Dispatches for a multimethod based on the namespace of a keyword
  and a katello deployment name"
  [dest-ns deployment]
  (vector dest-ns deployment))

(defmulti elements component-deployment-dispatch)

(defmacro defelements
  "Define locators needed in this namespace and its dependent
   namespaces.  deployment is a keyword specifying katello or
   headpin (see katello.ui). others is a list of other namespace
   symbols whose locators are also required. m is a map of keyword to
   locators.  Optionally, provide other maps containing locators
   needed in this namespace, for m to be merged with.
   Example, (deflocators :katello.deployment/any [other.ns/locators] {:foo 'bar'})"
  [deployment others m]
  `(let [m# ~m]
     (defmethod elements [(-> *ns* .getName symbol) ~deployment] [_# _#]
       (apply merge m# (for [other# (quote ~others)]
                         (elements other# ~deployment))))))

(defelements :katello.deployment/any []
  {::save-inplace-edit       "//div[contains(@class, 'editable')]//button[@type='submit']|//span[contains(@class, 'editable')]//button[@type='submit']"
   ::confirmation-dialog     "//div[contains(@class, 'confirmation')]"

   ;; use index, no other identifiable info in the DOM
   ::confirmation-yes        "//button/span[normalize-space(.)='Yes']"
   ::confirmation-no         "//button/span[normalize-space(.)='No']"
   ::save-button             "//button[@ng-click='save()']"
   ::commit                  {:name "commit"}
   
   ::switcher                "organizationSwitcher"
   ::active-org              "//a[contains(@class,'organization-name')]"
   ::manage-orgs             "//li[@id='manage_orgs']//span[contains(.,'Manage Organizations')]"
   ::back                    "//div[@id='nav-container']/a[contains(.,'Back')]"

   ::keyname-list            {:xpath "//td[@class='ra']/label[contains(@for, 'default_info') or contains(@for, 'custom_info')]"}

   ::left-pane-list          "//div[contains(@class,'left')]//div[contains(@class,'ellipsis') or @class='block tall']"
   ::search-bar              "search"
   ::search-menu             "//form[@id='search_form']//span[@class='arrow']"
   ::search-save-as-favorite "search_favorite_save"
   ::search-clear-the-search "search_clear"
   ::search-submit           "//button[@form='search_form']"
   ::notification-container  {:tag "div" :class "jnotify-container"}
   ::notification-close      {:tag :a :class "jnotify-close"}
   ::expand-path             "path-collapsed"
   ::total-results-count     "total_results_count"
   ::current-items-count     "current_items_count"
   ::user-menu               "//nav[@alch-menu='userMenu']"
   ::log-out                 "//section[@id='navigation']//a[contains(@href,'logout')]"})

(extend-protocol wd/SeleniumLocatable
  clojure.lang.Keyword
  (wd/sel-locator [k] (get (elements (-> k namespace symbol) (current-session-deployment)) k))
  String
  (wd/sel-locator [x] x))

(defn toggler
  "Returns a function that returns a locator for the given on/off text
   and locator strategy. Used for clicking things like +Add/Remove for
   items in changesets or permission lists."
  [[on-text off-text] loc-strategy]
  (fn [associated-text on?]
    (loc-strategy (if on? on-text off-text) associated-text)))

(def add-remove ["+ Add" "Remove"])

(defn- item-count [loc]
  (->> loc
     (browser/text)
     Integer/parseInt))

(def current-items
  ^{:doc "Returns the number of shown left pane items according to the katello ui."}
  (partial item-count ::current-items-count))

(def total-items
  ^{:doc "Returns the number of total left pane items according to the katello ui."}
  (partial item-count ::total-results-count))

(defn go-to-system
  [system]
  (Thread/sleep 5000)
  (browser/click (select-system (:name system))))
