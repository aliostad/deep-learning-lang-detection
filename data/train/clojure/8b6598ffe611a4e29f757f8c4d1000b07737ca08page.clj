(ns lsnet.page
  (:require [hiccup.core :as h]
            [hiccup.page :as page]))

(defn layout [& body]
  (page/html5
   [:head
    (page/include-css "/lsnet/css/stylesheet.css")
    (page/include-js "/js/jquery-1.10.2.min.js")
    (page/include-js "/lsnet/js/jquery.cookie.js")
    (page/include-js "/lsnet/js/public.js")
    [:title "Laura Shaffer - Independent Beauty Consultant"]]
   [:body
    [:div#info
     [:h1#title "Laura Shaffer - Independent Beauty Consultant"]
     [:h3#contact-info "940-595-1437 | laurashaffer@marykay.com"]]
    [:div#main 
     [:div#login
      [:h3 "To see my sales, enter the 'special' password below"]
      [:form
       [:input#password {:type "text" :required "" :name "password"}]
       [:input#submit {:type "submit" :onclick "checkLogin()" :value "Submit"}]]]
     [:h2.line {:style "display:inline-block"}
      "Welcome to my Mary Kay clearance list!"]
     [:div.content body]]]))

(defn menu-item [link text]
  [:div.cont20
   [:a {:href link}
    [:h4 text]]])

(defn layout-admin [& body]
  (page/html5
   [:head
    (page/include-js "/js/jquery-1.10.2.min.js")
    (page/include-js "/lsnet/js/jquery.cookie.js")
    (page/include-js "/lsnet/js/javascript.js")
    (page/include-js "/lsnet/js/md5.js")
    (page/include-js "/lsnet/js/user-secure.js")
    (page/include-css "/lsnet/css/stylesheet.css")
    [:title "Laura Shaffer - Independent Beauty Consultant"]]
   [:body
    [:script#user-check "userCheck()"]
    [:div#info
     [:h1#title "Laura Shaffer - Independent Beauty Consultant"]
     [:h3#contact-info "940-595-1437 | laurashaffer@marykay.com"]]
    [:div#main
     [:div.content
      [:div.pair
       (menu-item "/staff" "Admin Home")
       (menu-item "/admin-products" "List Products")
       (menu-item "/new-product" "New Product")
       (menu-item "/categories" "Categories")
       (menu-item "/" "Public View")
       (menu-item "/header-footer" "Header/Footer")]]
     body]]))

(def front
  [:h4 "hello world"])

(defn form-inputs [name text content]
  [:div
   [:label {:for name}
    [:span text]]
   [:input {:type "text" :name name :size "60" :id name :value content}]
   [:br]
   [:br]])

(defn visibility-input []
  [:p#visibility-input "Visible: "
   [:input {:type "radio" :value "0" :name "visible"}]
   "No "
   [:input {:type "radio" :checked "" :value "1" :name "visible"}]
   "Yes"])  

(defn edit-visibility-input [visibility]
  [:p#visibility-input "Visible: "
   [:input (if (= visibility 0) {:type "radio" :value "0" :checked "" :name "visible"} {:type "radio" :value "0" :name "visible"})]
   "No "
   [:input (if (= visibility 1) {:type "radio" :value "1" :checked "" :name "visible"} {:type "radio" :value "1" :name "visible"})]
   "Yes"])

(defn product-form [categories]
  [:div
   [:h2 "New Product"]
   [:form
    [:fieldset
     (form-inputs "images" "Image Url" "")
     (form-inputs "product-title" "Product Title" "")
     (form-inputs "content" "Description" "")
     (form-inputs "newprice" "Discounted Price" "")
     (form-inputs "normprice" "Original Price" "")
     (form-inputs "quantity" "Inventory" "")
     (form-inputs "sku" "SKU" "")
     (form-inputs "custom" "Custom Category" "")
     [:span "Category"
      [:select#category {:name "category"}
       (let [categories (sort-by :position categories)
             cat-op-fn (fn [category] [:option (:category category)])]
         (map cat-op-fn categories))]]
     (visibility-input)
     [:br]
     [:div#log]
     [:br]
     [:input {:type "button" :value "Submit" :style "clear:both" :onclick "saveProduct()"}]]]])

(defn edit-product-form [categories product]
  (let [title (:title product)
        id (:_id product)
        img-src (:images product)
        uri (first (:uris product))
        description (:content-html product)
        norm (:normprice product)
        new (:newprice product)
        op (if (> (count norm) 0) (read-string norm) "NaN")
        pp (if (> (count new) 0) (read-string new) "NaN")
        original-price (if (number? op) (str "$" (format "%.2f" (float op))))
        product-price (if (number? pp) (str "$" (format "%.2f" (float pp))))
        discount (if (and (number? op) (number? pp)) (let [old (read-string (:normprice product))
                                                           new (read-string (:newprice product))]
                                                       (str "$" (format "%.2f" (float (- old new))) " (" (- 100 (int (* (/ new old) 100))) "%)")))
        stock (:quantity product)
        sku (:sku product)
        visibility (read-string (:visible product))
        custom (:custom product)
        product-category (:category product)
        categories (sort-by :position categories)]
    [:div
     [:h2 "Edit Product"]
     [:form
      [:fieldset
       (form-inputs "images" "Image Url" img-src)
       (form-inputs "product-title" "Product Title" title)
       (form-inputs "content" "Description" description)
       (form-inputs "newprice" "Discounted Price" new)
       (form-inputs "normprice" "Original Price" norm)
       (form-inputs "quantity" "Inventory" stock)
       (form-inputs "sku" "SKU" sku)
       (form-inputs "custom" "Custom Category" custom)
       [:span "Category"
        [:select#category {:name "category"}
         (let [cat-op-fn (fn [category] [:option (if (= (:category category) product-category) {:selected "selected"}) (:category category)])]
           (map cat-op-fn categories))]]
       (edit-visibility-input visibility)
       [:br]
       [:div#log]
       [:br]
       [:input {:type "button" :value "Submit" :style "clear:both" :onclick (str "updateProduct('" id "')")}]]]]))

(defn list-categories [categories]
  [:ul.categories.compact
   (let [categories (sort-by :position categories)
         cat-item (fn [category]
                    (let [name (:category category)
                          uri (:uri category)
                          id (:_id category)]
                      [:li
                       [:div.cont50.text-left
                        [:a {:href (str "/edit-category/" id)} name]]
                       [:div.cont50.text-right
                        [:a.delete-headerfooter {:onclick "return confirm('Are you sure?')" :href (str "/delete-category/" id)} "Delete Category"]]
                       [:hr {:style "height:1px;border:none;color:#ccc;background-coloe:#ccc"}]]))]
     (map cat-item categories))])

(defn position-input [m stop-value f]
  [:p "Position:"
   [:select#position {:name "position"}
    (let [options (range 1 (+ (count m) (f 1 1)))
          op-fn (fn [n] [:option (if (= n (f (read-string (str stop-value)) 1)) {:selected "selected"}) n])]
      (map op-fn options))]])

(defn category-template [categories]
  [:div
   [:h2 "Categories"]
   [:a {:href "/categories"} "New Category"]
   " | "
   [:a {:href "/sort-cats-abc"} "Sort Alphabetically"]
   (list-categories categories)
   [:h2 "Add Category"]
   [:a {:href "/categories"} "New Category"]
   [:form
    [:p "Category name:"
     [:input#category_name {:type "text" :value "" :name "category_name"}]]
    (position-input categories (count categories) +)
    (visibility-input)
    [:br]
    [:input {:type "button" :value "Add Category" :onclick "saveCategory()"}]]
   [:a {:href "/categories"} "Cancel"]])

(defn category-edit-template [categories category]
  (let [visibility (read-string (:visible category))
        name (:category category)
        id (:_id category)]
    [:div
     [:h2 "Categories"]
     [:a {:href "/categories"} "New Category"]
     " | "
     [:a {:href "/sort-cats-abc"} "Sort Alphabetically"]
     (list-categories categories)
     [:h2 "Edit Category"]
     [:a {:href "/categories"} "New Category"]
     [:form
      [:p "Category name:"
       [:input#category_name {:type "text" :value name :name "category_name"}]]
      (position-input categories (:position category) /)
      (edit-visibility-input visibility)
      [:br]
      [:input {:type "button" :value "Update Category" :onclick (str "updateCategory('" id "')")}]]
     [:a {:href "/categories"} "Cancel"]]))

(defn list-links [link-text]
  (for [[a b] link-text]
    [:li
     [:a {:href a} b]]))

(def staff-page-home
  [:div   
   [:h2 "Staff Menu"]
   [:p#staff-welcome]
   [:script "staffWelcome()"]
   [:ul#staff-home-menu
    (list-links [["/admin-products" "Manage Products"] ["/categories" "Manage Categories"] ["/header-footer" "Manage Header/Footer"] ["/new-user" "Add Staff User"] ["/new-product" "New Product"]])
    [:li
     [:a {:onclick "logoutUser()"} "Logout"]]]])

(defn product-template-core [product]
  (let [title (:title product)
        id (:_id product)
        img-src (:images product)
        uri (first (:uris product))
        description (:content-html product)
        norm (:normprice product)
        new (:newprice product)
        op (if (> (count norm) 0) (read-string norm) "NaN")
        pp (if (> (count new) 0) (read-string new) "NaN")
        original-price (if (number? op) (str "$" (format "%.2f" (float op))))
        product-price (if (number? pp) (str "$" (format "%.2f" (float pp))))
        discount (if (and (number? op) (number? pp)) (let [old (read-string (:normprice product))
                                                           new (read-string (:newprice product))]
                                                       (str "$" (format "%.2f" (float (- old new))) " (" (- 100 (int (* (/ new old) 100))) "%)")))
        stock (:quantity product)
        sku (:sku product)]
    [:div.product-details
     [:img.product-image {:title title :alt title :src img-src}]
     [:p.product-title title]
     [:p.product-description description]
     [:p.original-product-price
      [:span.price-text (if (number? op) "Retail Price: ")]
      [:del original-price]]
     [:p.product-price
      [:span.price-text (if (number? pp) "Price: ")] product-price]
     [:p.percent-off
      [:span.price-text (if (and (number? op) (number? pp)) "You Save: ")] discount]
     [:p.product-stock stock]
     [:p.product-sku sku]]))

(defn product-template [product]
  (let [id (:_id product)
        visibility (read-string (:visible product))
        mail-id (apply str (map #(str %) (take 5 id)))]
    [:div.cont33.product-cont.product-list-item {:onclick (str "emailForm('" mail-id "')") :id mail-id}
     (product-template-core product)]))

(defn admin-product-template [product]
  (let [id (:_id product)]
    [:div.cont33.product-cont.product-list-item
     (product-template-core product)
     [:div#admin-options
      [:p.product-edit
       [:a.product-edit-link {:href (str "/view-product/" id)} "Edit Product"]]
      [:a {:onclick "return confirm('Are you sure?')" :href (str "/delete-product/" id)} "Delete Product"]]]))

(defn login-input-template [& body]
  [:form#login-form
   [:p "Username:"
    [:input#user_name {:type "text" :value "" :name "user_name"}]]
   [:p "Password:"
    [:input#user_password {:type "password" :value "" :name "user_password"}]]
   body])

(def add-user-form 
  [:div   
   [:h2 "New Admin"]
   (login-input-template 
    [:p "Confirm Password:"
     [:input#user_confirm_password {:type "password" :value "" :name "user_confirm_password"}]]
    [:p#login_error]
    [:input {:type "button" :value "Submit" :onclick "checkSend()"}])])

(def login-form
  [:div
   (page/include-css "/lsnet/css/login.css")
   (page/include-js "/lsnet/js/javascript.js")
   (page/include-js "/lsnet/js/md5.js")
   [:h2#lheader "Admin Login"]
   (login-input-template
    [:p#login_error]
    [:input {:type "button" :value "Login" :onclick "loginUser()"}])])

(defn header-footer-template [header-footer]
  (let [id (:_id header-footer)
        content (:content header-footer)
        cont-id (apply str (map #(str %) (take 5 id)))]
    [:div.header-footer-list-item 
     [:a.header-footer-toggle {:onclick (str "toggleElement('" cont-id "')")} "Minimize/Maximize"]
     [:div {:id cont-id}
      [:div#admin-options
       [:li
        [:div.cont50.text-left
         [:a {:href (str "/edit-header-footer/" id)} "Edit"]]
        [:div.cont50.text-right
         [:a.delete-headerfooter {:onclick "return confirm('Are you sure?')" :href (str "/delete-header-footer/" id)} "Delete"]]
        
        [:hr {:style "height:1px;border:none;color:#ccc;background-coloe:#ccc"}]]]
      [:p.header-footer content]]]))

(defn header-footer-form [header-footers]
  [:div
   (page/include-js "http://js.nicedit.com/nicEdit-latest.js")
   [:script "bkLib.onDomLoaded(nicEditors.allTextAreas);"]
   (let [headers (remove nil? (map #(if (= "Top" (:location %)) %) header-footers))
         footers (remove nil? (map #(if (= "Bottom" (:location %)) %) header-footers))]
     [:ul.header-footers.compact
      [:div#headers
       [:h2 "Headers"]
       (let [headers (sort-by :position headers)]
         (map header-footer-template headers))
       [:h2 "New Header"]
       [:a {:href "/header-footer#headerform"} "New Header"]
       [:form#headerform.headerfooterform
        [:div.nctext
         [:div.nctextlatch]
         [:textarea#hfcontent {:value "" :name "hfcontent"}]]
        (visibility-input)
        (position-input headers (count headers) +)
        [:input {:type "button" :value "Submit" :onclick "saveHeader()"}]]]
      [:div#footers
       [:h2 "Footers"]
       (let [footers (sort-by :position footers)]
         (map header-footer-template footers))
       [:h2 "New Footer"]
       [:a {:href "/header-footer#footerform"} "New Footer"]
       [:form#footerform.headerfooterform
        [:div.nctext
         [:div.nctextlatch]
         [:textarea#hfcontent {:value "" :name "hfcontent"}]]
        (visibility-input)
        (position-input footers (count footers) +)
        [:input {:type "button" :value "Submit" :onclick "saveFooter()"}]]]])])

(defn edit-header-footer-form [header-footers header-footer]
  (let [id (:_id header-footer)
        visibility (read-string (:visible header-footer))
        location (:location header-footer)
        content (:content header-footer)]    
    [:div
     (page/include-js "http://js.nicedit.com/nicEdit-latest.js")
     [:script "bkLib.onDomLoaded(nicEditors.allTextAreas);"]
     (let [headers (remove nil? (map #(if (= "Top" (:location %)) %) header-footers))
           footers (remove nil? (map #(if (= "Bottom" (:location %)) %) header-footers))]
       [:ul.header-footers.compact
        [:div#headers
         [:h2 "Headers"]
         (let [headers (sort-by :position headers)]
           (map header-footer-template headers))
         [:h2 "Edit Header"]
         [:a {:href "/header-footer#headerform"} "New Header"]
         (if (= "Top" location)
           [:div            
            [:form#headerform.headerfooterform
             [:div.nctext
              [:div.nctextlatch]
              [:textarea#hfcontent {:value "" :name "hfcontent"} content]]
             (edit-visibility-input visibility)
             (position-input headers (:position header-footer) /)
             [:input {:type "button" :value "Submit" :onclick (str "updateHeader('" id "')")}]
             [:script (str "$(document).ready(function(){$('#headerform .nicEdit-main').html('" content "');});")]]])]
        [:div#footers
         [:h2 "Footers"]
         (let [footers (sort-by :position footers)]
           (map header-footer-template footers))
         [:h2 "Edit Footer"]
         [:a {:href "/header-footer#footerform"} "New Footer"]
         (if (= "Bottom" location)
           [:div            
            [:form#footerform.headerfooterform
             [:div.nctext
              [:div.nctextlatch]
              [:textarea#hfcontent {:value "" :name "hfcontent"} content]]
             (edit-visibility-input visibility)
             (position-input footers (:position header-footer) /)
             [:input {:type "button" :value "Submit" :onclick (str "updateFooter('" id "')")}]]])]])]))

(defn admin-products-by-category [f products categories]
  (let [categories (sort-by :position categories)        
        prod-fn (fn [category] (filter #(= category (:category %)) products))
        cat-fn (fn [category] (let [cat-name (:category category)
                                    cat-products (prod-fn cat-name)
                                    visibility (:visible category)]
                                [:div.category
                                 [:h1 {:style "clear:both"} cat-name]
                                 (f cat-products)]))]
    (map cat-fn categories)))

(defn products-by-category [f products categories]
  (let [products (filter #(= "1" (:visible %)) products)
        categories (filter 
                    (fn [category] 
                      (> (count (filter 
                                 #(= (:category category) (:category %)) products)) 0)) categories)]
    (admin-products-by-category f products categories)))

(defn front-page-headers [hfs]
  (let [headers (sort-by :position (filter #(= "Top" (:location %)) hfs))]
    [:div#headers-cont
     (map #(if (not (= "0" (:visible %))) [:div.header (:content %)]) headers)]))

(defn front-page-footers [hfs]
  (let [footers (sort-by :position (filter #(= "Bottom" (:location %)) hfs))]
    [:div#footers-cont
     (map #(if (not (= "0" (:visible %))) [:div.footer (:content %)]) footers)]))

(defn header-footer-page [request header-footer]
  (layout-admin (header-footer-form header-footer)))

(defn edit-header-footer-page [request header-footer header-footers]
  (layout-admin (edit-header-footer-form header-footers header-footer)))

(defn product-list-xform [products]
  (map product-template products))

(defn admin-product-list-xform [products]
  (map admin-product-template products))

(defn front-page [request products categories header-footers]
  (layout (front-page-headers header-footers) (products-by-category product-list-xform products categories) (front-page-footers header-footers)))

(defn admin-home [request]
  (layout-admin staff-page-home))

(defn new-product-page [request categories]
  (layout-admin (product-form categories)))

(defn edit-product-page [request product categories]
  (layout-admin (product-template product)
                (edit-product-form categories product)))

(defn categories-page [request categories]
  (layout-admin (category-template categories)))

(defn admin-products [request products categories]
  (layout-admin (admin-products-by-category admin-product-list-xform products categories)))

(defn edit-category-page [request category categories]
  (layout-admin (category-edit-template categories category)))

(defn new-user-page [request]
  (layout-admin add-user-form))

(defn login-page [request]
  (layout login-form))
