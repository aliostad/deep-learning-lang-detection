(ns katello.menu
  (:require [webdriver :as browser]
            [katello :as kt]
            (katello [ui :as ui]
                     [navigation :as nav])))

(defn fmap "Passes all values of m through f." [f m]
  (into {} (for [[k v] m] [k (f v)])))

;; Locators
(def top-level-items {::administer-link "Administer"
                      ::dashboard-link  "Dashboard"
                      ::systems-link    "Systems"
                      ::content-link    "Content"})

(def menu-items {::by-environments-link          "By Environment"
                 ::content-search-link           "Content Search"
                 ::content-view-definitions-link "Content View Definitions"
                 ::manage-organizations-link     "Organizations"
                 ::repositories-link             "Repositories"
                 ::roles-link                    "Roles"
                 ::changesets-link               "Changesets"
                 ::sync-management-link          "Sync Management"
                 ::system-groups-link            "System Groups"
                 ::systems-all-link              "All"
                 ::users-link                    "Users"
                 ::setup-link                    "setup"})

(def subscriptions {::subscriptions-link "Subscriptions"})

(def flyout-items {::products-link                    "Products"
                   ::red-hat-repositories-link        "Red Hat Repositories"
                   ::gpg-keys-link                    "GPG Keys"
                   ::sync-plans-link                  "Sync Plans"
                   ::sync-schedule-link               "Sync Schedule"
                   ::sync-status-link                 "Sync Status"
                   ::changeset-history-link           "Changesets History"
                   ::changeset-management-link        "Changeset Management"})

(def subscriptions-menu-items {::red-hat-subscriptions-link "Red Hat Subscriptions"
                               ::distributors-link          "Subscription Manager Applications"
                               ::activation-keys-link       "Activation Keys"
                               ::import-history-link        "Import History"})

(def others {::notifications-link "//span[@id='unread_notices']" })

;; Define menus for katello and headpin (in headpin, Subscriptions is a top level menu,
;; in katello it's under Content).

(ui/defelements :katello.deployment/katello []
  (merge (fmap ui/menu-link top-level-items)
         (fmap ui/menu-dropdown-link (merge menu-items subscriptions))
         (fmap ui/menu-flyout-link (merge flyout-items subscriptions-menu-items))
         others))

(ui/defelements :katello.deployment/headpin []
  (merge (fmap ui/menu-link (merge top-level-items subscriptions))
         (fmap ui/menu-dropdown-link (merge menu-items subscriptions-menu-items))
         (fmap ui/menu-flyout-link flyout-items)
         others))

;; Functions

;; Nav
(def subscriptions-menu
  [:subscriptions (fn [_] (browser/move-to ::subscriptions-link)
                          (Thread/sleep 3000))
   [:katello.subscriptions/page (fn [_] (browser/click ::red-hat-subscriptions-link))]
   [:katello.distributors/page (fn [_] (browser/click ::distributors-link))]
   [:katello.activation-keys/page (fn [_] (browser/click ::activation-keys-link))]
   [:katello.subscriptions/import-history-page (fn [_] (browser/click ::import-history-link))]])

(def systems-menu
  [::systems-menu (fn [_] (browser/move-to ::systems-link)
                          (Thread/sleep 3000))
   [:katello.systems/page (fn [_] (browser/click ::systems-all-link))]
   [:katello.systems/by-environments-page (fn [_] (browser/click ::by-environments-link))]
   [:katello.system-groups/page (fn [_] (browser/click ::system-groups-link))]])

(def right-hand-menus
  (list [:katello.notices/page (fn [_] (browser/click ::notifications-link))]

        [::administer-menu (fn [_] (browser/move-to ::administer-link))
         [:katello.users/page (fn [_] (browser/click ::users-link))]
         [:katello.roles/page (fn [_] (browser/click ::roles-link))]
         [:katello.organizations/page (fn [_] (browser/click ::manage-organizations-link))]]))

(nav/defpages :katello.deployment/katello katello.navigation
  (concat [::nav/top-level

           [::org-context (fn [ent] (nav/switch-org (kt/org ent)))
            systems-menu

            [::content-menu (fn [_] (browser/move-to ::content-link))
             subscriptions-menu

             [::repositories-menu (fn [_] (browser/move-to ::repositories-link))
              [:katello.providers/products-page (fn [_] (browser/click ::products-link))]
              [:katello.redhat-repositories/page (fn [_] (browser/click ::red-hat-repositories-link))]
              [:katello.gpg-keys/page (fn [_] (browser/click ::gpg-keys-link))]]

             [::sync-management-menu (fn [_] (browser/move-to ::sync-management-link))
              [:katello.sync-management/status-page (fn [_] (browser/click ::sync-status-link))]
              [:katello.sync-management/plans-page (fn [_] (browser/click ::sync-plans-link))]
              [:katello.sync-management/schedule-page (fn [_] (browser/click ::sync-schedule-link))]]

             [:katello.content-view-definitions/page (fn [_] (browser/click ::content-view-definitions-link))]

             [:katello.content-search/page (fn [_] (browser/click ::content-search-link))]

             [::changesets-menu (fn [_] (browser/move-to ::changesets-link))
              [:katello.changesets/page (fn [_] (browser/click ::changeset-management-link))]
              [:katello.changesets/history-page (fn [_] (browser/click ::changeset-history-link))]]]]]
          right-hand-menus))



(nav/defpages :katello.deployment/headpin katello.navigation
  (concat [::nav/top-level

           [::org-context (fn [ent] (nav/switch-org (kt/org ent)))
            systems-menu
            subscriptions-menu]]

          right-hand-menus))
