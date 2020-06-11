(ns clj-jam.query-test
  (:use [clj-jam.query]
        [expectations]))

(expect "some-url?token=some-token" (compute-parameter "some-url" "some-token"))
(expect "some-url?param=1&token=some-token" (compute-parameter "some-url?param=1" "some-token"))

(expect "http://www.marmalade-repo.org/v1/users/ardumont"
        (compute-url URL "/v1/users/ardumont"))
(expect "http://www.marmalade-repo.org/v1/users/ardumont?token=some-token"
        (compute-url URL "/v1/users/ardumont" "some-token"))
(expect "http://www.marmalade-repo.org/v1/users/ardumont?some=parameter&token=some-token"
        (compute-url URL "/v1/users/ardumont?some=parameter" "some-token"))

(expect [:get :multipart]  (dispatch-execute {:method :get :multipart true}))
(expect [:post :multipart] (dispatch-execute {:method :post :multipart true}))
(expect [:put :multipart]  (dispatch-execute {:method :put :multipart true}))
(expect [:get nil]         (dispatch-execute {:method :get}))
(expect [:post nil]        (dispatch-execute {:method :post}))
(expect [:put nil]         (dispatch-execute {:method :put}))
