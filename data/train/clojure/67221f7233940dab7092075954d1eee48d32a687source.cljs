(ns quilt.views.editor.source
  (:require [quilt.i18n :as i18n]
            [quilt.util :refer [get-value]]
            [re-frame.core :as rf]))

(defn editor []
  (let [code-atom (rf/subscribe [:code])
        undo-atom (rf/subscribe [:undo])
        redo-atom (rf/subscribe [:redo])
        editor-atom (rf/subscribe [:editor])
        source-atom (rf/subscribe [:source])
        eval-code #(rf/dispatch [:eval-code])]
    (fn []
      (when (= :source (:type @editor-atom))
        [:div#source-editor.editor
         [:textarea {:readOnly (:readonly? @editor-atom)
                     :value @source-atom
                     :on-change #(rf/dispatch [:set-source (get-value %)])}]
         [:div#source-controls
          [:button
           {:on-click eval-code}
           (i18n/str "Eval")]
          [:button
           {:on-click #(rf/dispatch [:set-source ""])}
           (i18n/str "Clear")]
          [:button
           {:on-click #(rf/dispatch [:reset-source])}
           (i18n/str "Reset")]
          [:div
           [:button {:on-click #(rf/dispatch [:undo])
                     :disabled (empty? @undo-atom)}
            (i18n/str "Undo")]
           [:button {:on-click #(rf/dispatch [:redo])
                     :disabled (empty? @redo-atom)}
            (i18n/str "Redo")]]]]))))
