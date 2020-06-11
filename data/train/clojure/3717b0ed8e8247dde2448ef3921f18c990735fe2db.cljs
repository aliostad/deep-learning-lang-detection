(ns open-source.db)

(def forms
  {:projects {:path   "manage/projects"
              :create {:submit-form-success-handler :create-project-success}
              :update {:submit-form-success-handler :create-project-success}}})

(def form-default {:data    {}
                   :errors  {}
                   :state   :sleeping})

(def default-value {:projects     {:selected nil}

                    :forms {:projects {:create form-default
                                       :update form-default
                                       :search form-default}}

                    :data {}
                    :nav {}
                    :initialized false})
