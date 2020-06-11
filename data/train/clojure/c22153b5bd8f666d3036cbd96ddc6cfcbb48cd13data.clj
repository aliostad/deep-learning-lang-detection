(ns grotte.test.data
  (:use [grotte.core :as gc]
        [grotte.data :as data])
  (:use [clojure.test]))

(defn seed-data-fixture
  [testfn]

  (data/create-domain :post)
  (data/add-column :post :timestamp :notype)
  (data/add-column :post :body :notype)

  (data/create-domain :comment)
  (data/add-column :comment :post :notype)
  (data/add-column :comment :author :notype)
  (data/add-column :comment :body :notype)
  (data/add-column :comment :timestamp :notype)

  (data/make-row :post :timestamp (java.util.Date.) :body "First p0st.")
  (data/make-row :post :timestamp (java.util.Date.) :body "Social mobile viral.")
  (data/make-row :post :timestamp (java.util.Date.) :body "Navel gazing.")

  (data/delete-row :post (:id @(data/find-row :post :body "Social mobile viral.")))
  
  (testfn)
  (data/truncate-all)
  )

(use-fixtures :once seed-data-fixture)

(deftest test-has-column
  (is (= 2 (count @data/*domains*))
      "Didn't manage to seed the data properly.")
  (is (data/has-column :post :timestamp))
  (is (data/has-column :post :body))
  (is (data/has-column :comment :post))
  (is (data/has-column :comment :author))
  (is (data/has-column :comment :body))
  (is (data/has-column :comment :timestamp))
  (is (not (data/has-column :post :monkey)))
  (is (not (data/has-column :timestamp :post)))
  (is (not (data/has-column :post :comment))))

(deftest test-row-ops
  (is (= 2 (count @data/*rows*)) "Should have Two domains, so two refs in *rows*.")
  (is (= 3 (count (data/find-rows :post))))
  (is (= "First p0st." (:body @(first (data/find-rows :post)))))
  (is (= "Navel gazing." (:body @(data/find-row :post :body "Navel gazing."))))
  (is (= 2 (count (filter #(not (:deleted @%)) (data/find-rows :post)))))
  (is (= 1 (count (filter #(:deleted @%) (data/find-rows :post)))))
  )


