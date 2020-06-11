(ns krivah.user
	(:require [krivah.response :as response]
		[krivah.theme :as theme]
		[krivah.formelements :as fe])
)

(defn store-user [form-value]
	(println "forms " form-value))

(defn register [request params]

 (def form (array-map :email { :id "email" :label "Email" :required true :type "text" :validator {:type "email"}}
 	:password {:id "password" :label "Password" :required true :type "password"}
 	:confpass {:id "confpass" :label "Confirm Password" :required true :type "password"}
 	:gender {:id "gender" :label "Select your gender" :type "checkboxes" :options {"male" "Male", "female" "Female", "unknown" "Others"} :value (list "male")}
 	:items {:id "items" :label "Items", :type "select" :options {"plate" "Plate", "remote" "Remote", "mouse" "Mouse"} :value (list "remote")}))
	
	(fe/manage-form form store-user)
 )

