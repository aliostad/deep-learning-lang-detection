(ns navigator-repro.macros)

(defmacro with-om-vars [component & body]
  ;; these should match the 'render case in reshape-map
  `(let [this# ~component
         reconciler# (or om.next/*reconciler*
                         (om.next/get-reconciler this#))
         depth# (or om.next/*depth* (inc (om.next/depth this#)))
         shared# (or om.next/*shared* (om/shared this#))
         instrument# (or om.next/*instrument* (om/instrument this#))
         parent# (or om.next/*parent* this#)]
     (binding [om.next/*reconciler* reconciler#
               om.next/*depth* depth#
               om.next/*shared* shared#
               om.next/*instrument* instrument#
               om.next/*parent* this#]
       ~@body)))
