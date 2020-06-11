(ns sketchpad.menu.goto
  (:require [seesaw.core :as seesaw.core]
            [sketchpad.fuzzy.manage :as fuzzy]
            [seesaw.keystroke :as keystroke]))

(defn toggle-fuzzy
  []
  (fuzzy/toggle-fuzzy))

(defn make-goto-menu-items []
 {:goto-anything (seesaw.core/menu-item :text "Goto file..." 
                              :mnemonic "P" 
                              :key (keystroke/keystroke "meta P") 
                              :listen [:action (fn [_] (toggle-fuzzy))])})

(defn make-goto-menu
  []
  (let [menu-items (make-goto-menu-items)]
    (seesaw.core/menu :text "Goto"
          :mnemonic "G"
          :items [
                  (menu-items :goto-anything)])))