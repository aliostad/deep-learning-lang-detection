(ns webkipedia.state.core
  (:require [webkipedia.dispatcher :refer [register]]
            [webkipedia.state.logger :as logger]
            [webkipedia.state.history :as history]
            [webkipedia.state.explore :as explore]
            [webkipedia.state.menu :as menu]
            [webkipedia.state.page :as page]
            [webkipedia.state.route :as route]
            [webkipedia.state.search :as search]
            ))

(defn init! []
  (register
    [[:logger logger/dispatch logger/logger]
     [:history history/dispatch history/history]
     [:random explore/dispatch explore/explore]
     [:menu menu/dispatch menu/menu]
     [:page page/dispatch page/page]
     [:route route/dispatch route/current-route]
     [:search search/dispatch search/search]
     ]))
