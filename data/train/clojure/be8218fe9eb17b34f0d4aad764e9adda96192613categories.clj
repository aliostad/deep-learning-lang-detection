(ns bookmarking.views.categories
  (:require [bookmarking.models.category :as cat]
            [bookmarking.views.layouts.main :refer [main-layout]]
            [bookmarking.views.util :refer [error-list]]
            [hiccup.form :refer [form-to text-field submit-button
                                 label]]
            [hiccup.element :refer [link-to]]
            [validateur.validation :refer [validation-set presence-of
                                           numericality-of length-of
                                           format-of]]))

(declare new-category-form)

(defn new [user & [category]]
  (main-layout user "Create New Category"
               (new-category-form (:id user) category)))

(defn new-category-form [user-id & [{:keys [errors]}]]
  [:div.new-category-wrapper
   (when errors (error-list errors))
   [:fieldset
    [:ul.new-category-form
     (form-to [:post (str "/users/" user-id "/categories")]
              [:li (label "category" "Category: ")
               (text-field "category" "")]
              [:li (label "submit" "")
               (submit-button "Submit")])]]])

(declare manage-categories delete-link)

(defn manage-categories-view [user]
  (main-layout user "Manage categories"
               (manage-categories (:id user))))


(declare management-links)

(defn manage-categories [user-id]
  (let [categories (cat/categories user-id)]
    [:div.categories-wrapper
     [:div.manage-list
      (for [category categories
            :let [cat-name (:category category)]]
        [:div.category
         (management-links category)
         " "
         [:span cat-name]])]]))

(declare edit-link delete-link)

(defn management-links [category]
  [:div.management
   (delete-link category)
   " "
   (edit-link category)])

(defn cat-path [category]
  (let [user-id (:user_id category)
        cat-id  (:category_id category)]
    (str "/users/" user-id "/categories/" cat-id)))

(defn delete-link [category]
  (let [cat-id   (:category_id category)
        cat-name (:category category)
        user-id  (:user_id  category)]
    (link-to {:class "delete-category"}
             (str (cat-path category) "/delete")
             "x")))

(defn edit-link [category]
  (let [cat-id   (:category_id category)
        cat-name (:category category)
        user-id  (:user_id  category)]
    (link-to {:class "edit-category"}
             (str (cat-path category) "/edit")
             "edit")))

(declare edit-category-form)

(defn edit-category [user cat-id & [errors]]
  (main-layout user "Edit Category"
               (edit-category-form (:id user) cat-id errors)))

;; TODO: make error-list return nil when no errors and avoid when call here
(defn edit-category-form [user-id cat-id & [errors]]
  (println "called edit-cat form with: " user-id cat-id errors)
  (let [current-cat (cat/find user-id cat-id)
        current-name (:category current-cat)]
    [:div.edit-category-wrapper
     (when errors (error-list errors))
     (form-to [:post (cat-path current-cat)]
              [:fieldset
               (text-field "new-name" current-name)
               (submit-button "Submit")])]))
