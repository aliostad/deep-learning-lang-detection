(ns testify.views.admin
    (:use
        testify.remain
        testify.appear
        testify.process
    )
    (:require
        [testify.process.dyn-html :as dhtml]
        [testify.util :as util]
        [clojure.string :as string]
        [clojure.contrib.io :as io]
    ))

(defn admin-menu []
    (link-base
        "Administration"
        "Back to User's View"
        "/"
        (list
            (ul-link "Manage pages" "/admin/page")
            (ul-link "Manage templates" "/admin/template")
            (ul-link "Manage resources" "/admin/resource")
        )
    )
)

(defn admin-page []
                      ;get ids from full keynames
    (let [paglist (map id (dump "page" "token"))]
            ;use the ids to populate a linklist
        (link-base
            "Manage pages" "Add a Page" "/template"
            (form "POST" "/admin/page/delete"
                (dbl-linknodes paglist "/page/view?pname=" "delete" "Delete ")
            )
        )
    )
)

(defn admin-template
    "retrive a list of templates from the data store and return html link list"
    []
                  ;get ids from full keynames
    (let [tmpltlist (map id (dump "template" "html"))]
                        ;use the ids to populate a linklist

        (link-base
            "Manage templates" "Add a Template" "/admin/template/form"
            (form "POST" "/admin/template/delete"
                (dbl-linknodes tmpltlist "/template/preview?tname=" "delete" "Delete ")
            )
        )
    )
)

(defn admin-resource
    "retrive a list of resources from the data store and return html link list with admin properties"
    []
                  ;get ids from full keynames
    (let [reslist (map id (dump "resource" "file"))]
            ;use the ids to populate a linklist
        (link-base
            "Manage resources" "Add a Resource" "/admin/resource/form"
            (form "POST" "/admin/resource/delete"
                (dbl-linknodes reslist "/resource/" "delete" "Delete ")
            )
        )
    )
)

(defn admin-delete-page []
;TODO codethis
)
