(ns om-navigate.navigate
  (:require [om.next :as om :refer-macros [ui]]
            [cljs.pprint :as pp]))

(def ReactNavigation (js/require "react-navigation"))

(def StackNavigator (.-StackNavigator ReactNavigation))
(def TabNavigator (.-TabNavigator ReactNavigation))
(def DrawerNavigator (.-DrawerNavigator ReactNavigation))
(def NavigationActions (.-NavigationActions ReactNavigation))

(def StackRouter (.-StackRouter ReactNavigation))
(def TabRouter (.-TabRouter ReactNavigation))

(defprotocol INavOptions
  (options [this props navigation opts] "Return the navigation options for this component"))

(defn get-navigation [c]
  (loop [c c]
    (if-let [n (-> c .-props .-navigation)]
      n
      (recur (-> c .-props .-omcljs$parent)))))

(defn navigate-to 
  ([c target] (navigate-to c target nil))
  ([c target params]
   (.navigate (get-navigation c) (name target) params)))

(defn navigate-back [c]
  (.goBack (get-navigation c) nil))

(defn reset [c route]
  (let [route-name (if (keyword? route) (name route) route)
        params #js {:index 0
                    :actions #js [(.navigate NavigationActions #js {:routeName route-name})]}]
    (.dispatch (get-navigation c) (.reset NavigationActions params))))

(defn open-drawer [c]
  (.navigate (get-navigation c) "DrawerOpen"))

(defn- render-screen [screen-comp navigation props parent]
  (let [screen-factory (om/factory screen-comp)
        reconciler#    (om/get-reconciler parent)
        depth#         (inc (om/depth parent))
        shared#        (om/shared parent)
        instrument#    (om/instrument parent)]
    (binding [om/*reconciler* reconciler#
              om/*depth*      depth#
              om/*shared*     shared#
              om/*instrument* instrument#
              om/*parent*     parent]
      (.cloneElement js/React (screen-factory props) #js {:navigation navigation}))))

(defn- create-screen-proxy [key screen-comp]
  (om/ui
    static field router (.-router screen-comp)
    static field navigationOptions 
    (fn [props]
      (if (implements? INavOptions screen-comp)
        (let [screen-props (-> props .-screenProps :props key)
              navigation   (.-navigation props)
              def-opts     (.-navigationOptions props)]
          (options screen-comp screen-props navigation def-opts))
        (.-navigationOptions screen-comp)))
    Object
    (shouldComponentUpdate [this _ _] true)
    (render [this]
      (let [navigation     (.. this -props -navigation)
            screen-props   (.. this -props -screenProps)
            parent         (:parent screen-props)
            props          (-> screen-props :props key)]
        (render-screen screen-comp navigation props parent)))))

(defn- render-navigator [proxy nav-comp]
  (let [om-props     (om/props proxy)
        screen-props (-> proxy .-props .-screenProps)
        navigation   (-> proxy .-props .-navigation)
        props        (or om-props screen-props)]
    (js/React.createElement nav-comp #js {:navigation navigation :screenProps {:props props :parent proxy}})))

(defn- create-navigator-proxy [nav-comp queries]
  (if (seq queries)
    (om/ui
      static field router (.-router nav-comp)
      static om/IQuery
      (query [this]
        queries)
      Object
      (shouldComponentUpdate [this _ _] true)
      (render [this]
        (render-navigator this nav-comp)))
    (om/ui
      static field router (.-router nav-comp)
      Object
      (shouldComponentUpdate [this _ _] true)
      (render [this]
        (render-navigator this nav-comp)))))

(defn- transform-route [k route]
  (let [screen-comp (goog.object.get route "screen")
        proxy       (create-screen-proxy k screen-comp)]
    (goog.object.set route "screen" proxy)
    route))

(defn- transform-routes [routes]
  (reduce-kv
    (fn [acc k v]
      (goog.object.set acc (name k) (transform-route k v))
      acc)
    #js {}
    routes))

(defn screen-query?
  [query]
  (-> query meta ::screen-query))

(defn- extract-queries [routes]
  (reduce-kv
    (fn [acc k v]
      (if-let [q (om/get-query (.-screen v))]
        (conj acc {k (vary-meta q assoc ::screen-query true)})
        acc))
    []
    routes))

(defn- create-navigator
  [routes nav-factory]
  (let [queries  (extract-queries routes)
        nav-comp (nav-factory (clj->js (transform-routes routes)))
        proxy    (create-navigator-proxy nav-comp queries)]
    proxy))

(defn stack-navigator
  ([routes] (stack-navigator routes #js {}))
  ([routes cfg]
   (create-navigator routes #(StackNavigator % cfg))))

(defn tab-navigator
  ([routes] (tab-navigator routes #js {}))
  ([routes cfg]
   (create-navigator routes #(TabNavigator % cfg))))

(defn drawer-navigator
  ([routes] (drawer-navigator routes #js {}))
  ([routes cfg]
   (create-navigator routes #(DrawerNavigator % cfg))))

(defn custom-navigator
  ([comp router-factory routes] (custom-navigator comp router-factory routes #js {}))
  ([comp router-factory routes cfg]
   (create-navigator
     routes 
     (fn [routes']
       (let [router    (router-factory routes' cfg)
             navigator (.createNavigator ReactNavigation router)]
         (.createNavigationContainer ReactNavigation (navigator comp)))))))

(defn stack-router
  ([routes] (stack-router routes #js {}))
  ([routes cfg]
   (StackRouter routes cfg)))

(defn tab-router
  ([routes] (tab-router routes #js {}))
  ([routes cfg]
   (TabRouter routes cfg)))

(defn add-navigation-helpers [x]
  (.addNavigationHelpers ReactNavigation x))

