(ns kist.routes.manage
  (:use compojure.core)
  (:require [kist.layout :as layout]
            [kist.util :as util]
            [kist.db.core :as db]))

;;
;; ページ レイアウトバインディング 関数群
;;
(defn manage [& [id]]
  (layout/render "manage.html"
                 {:id id
                  :messages (db/get-messages)}))

(defn manage [& [id error]]
  (layout/render "manage.html"
                 {:id id
                  :error error
                  :messages (db/get-messages)}))

;;
;; ページ データバインディング 関数群
;;
(defn delete-message [id]
  ;; selectして存在チェック
  ;; なかったらidとerror_message返して自画面遷移
  ;; あったら該当idのguestbook削除して自画面遷移
  (cond
   (empty? id)
   (manage id "id error")

   :else
   (do
     (db/delete-message!  id)
     (manage))))

(defn manage-edit	[id message]
  ;; message編集処理
  (cond
   (empty? id)
   (manage id "id error")

   :else
   (do
     (db/update-message! id message)
     (manage))))

;;
;; ルート定義関数
;;
(defroutes manage-routes
  (GET  "/manage" [] (manage))
  (POST  "/manage" [] (manage))
  (POST  "/manageedit" [id message] (manage-edit id message))
  (POST "/managedel" [id] (delete-message id)))
