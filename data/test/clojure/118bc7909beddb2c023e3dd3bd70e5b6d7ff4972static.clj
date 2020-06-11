(ns tinyforum.models.static
  (:use [tinyforum.models.client]))


(defn set-faq! [new-faq]
  @(@r [:set "FAQ" new-faq]))

(defn get-faq []
  (or @(@r [:get "FAQ"]) "Change the faq text in /manage!"))

(defn set-masthead! [new-masthead]
  @(@r [:set "MASTHEAD" new-masthead]))

(defn get-masthead []
  (or @(@r [:get "MASTHEAD"]) "TinyForum"))

(defn set-banner! [new-banner]
  @(@r [:set "BANNER" new-banner]))

(defn get-banner []
  (or @(@r [:get "BANNER"]) "Welcome to TinyForum!"))

(defn set-lead! [new-lead]
  @(@r [:set "LEAD" new-lead]))

(defn get-lead []
  (or @(@r [:get "LEAD"]) "Informative description goes here, change this text to your liking..."))

(defn set-footer! [new-footer]
  @(@r [:set "FOOTER" new-footer]))

(defn get-footer []
  (or @(@r [:get "FOOTER"]) "Copyright 2013 Kyle Travis, MIT License"))
