(ns views.reagent.client.component)

(defmacro defvc
  "Defines a Reagent component that works the same as any other defined
   using defn with the addition that view-cursor can be used in the
   render function of these components to access data from subscribed
   views.

   To subscribe to a view, simply call view-cursor with the signature of
   the view you want to subscribe to and read data from. view-cursor and
   components defined with defvc will automatically manage subscribing
   and unsubscribing to views as the view signatures passed to any
   view-cursor calls change across the lifetime of this component."
  {:arglists '([component-name doc-string? attr-map? [params*] body])}
  [component-name & decl]
  (let [attr-map      (if (string? (first decl))
                        {:doc (first decl)}
                        {})
        decl          (if (string? (first decl))
                        (next decl)
                        decl)
        attr-map      (if (map? (first decl))
                        (conj attr-map (first decl))
                        attr-map)
        decl          (if (map? (first decl))
                        (next decl)
                        decl)
        [args & body] decl]
    `(defn ~component-name ~attr-map []
       (reagent.core/create-class
         {:component-will-mount
          (fn [this#]
            (views.reagent.client.component/prepare-for-render! this#))

          :component-did-mount
          (fn [this#]
            ; invoked immediately after the initial render has occurred.
            ; we do this here because component-did-mount does not get called
            ; after the initial render, but will be after all subsequent renders.
            (views.reagent.client.component/update-subscriptions! this#))

          :component-will-unmount
          (fn [this#]
            (views.reagent.client.component/unsubscribe-all! this#))

          :component-will-receive-props
          (fn [this# new-argv#]
            (views.reagent.client.component/prepare-for-render! this#))

          :component-did-update
          (fn [this# old-argv#]
            (views.reagent.client.component/update-subscriptions! this#))

          :component-function
          (fn ~args
            ~@body)}))))
