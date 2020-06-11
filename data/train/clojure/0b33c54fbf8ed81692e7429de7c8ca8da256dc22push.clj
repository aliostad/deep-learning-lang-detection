(ns ave40.push
  (:require [clj-http.client :as http]
            [ave40.db :refer :all]
            [clojure.string :as str]
            [net.cgrand.enlive-html :as enlive]
            [clojure.walk :as w]
            [clojure.tools.logging :as log]))



(defn- push-article
  "将文章推送到指定的博客"
  [domain {:keys [title article]}]
  (log/info (str "pushing to " domain ", article: " title))
  (println (:body (http/post "http://manage.ecigview.com/posts/create"
                             {:form-params {:domain domain
                                            :title title
                                            :content article}}))))

(defn- add-image-to-article
  "将图片加到文章中"
  [article]
  (let [url (:source_url (select-rand-image article-db))]
    (str "<img src=\"" url "\" style=\"display:block;\" />" article)))


(defn- wrap-paragraph [text]
  "包裹段落"
  (apply str (map #(apply str (enlive/emit* ((enlive/wrap :p) %)))
                  (str/split text #"\n"))))

(defn patch-push-article
  "批量推送文章到博客"
  [domain amount]
  (let [article-list (select-all article-db
                                 {:table "articles"
                                  :cols ["id" "spinner_title" "spinner_article"]
                                  :where (str "ISNULL(post_domain) and not isnull(spinner_title) and not isnull(spinner_article) and spinner_article<>'' limit " amount)})]
    (doseq [article-info article-list]
      (push-article domain {:title (:spinner_title article-info)
                            :article (add-image-to-article (:spinner_article article-info))})
      (update-data article-db {:table "articles"
                               :updates {:post_time (quot (System/currentTimeMillis) 1000)
                                         :post_domain domain}
                               :where (str "id=" (:id article-info))}))))


(def domains ["www.vapinggift.com"
              "www.eciggadget.com"
              "www.ecigsmok.com"
              "www.vapingblog.net"
              "www.eciggod.com"
              "www.vapingpromo.com"
              "www.ecigcommunity.com"
              "www.ecigblog.in"
              "www.vapingblog.in"
              "www.vaping10.com"])

(defn do-push []
  (doseq [domain domains]
    (patch-push-article domain 10)))

