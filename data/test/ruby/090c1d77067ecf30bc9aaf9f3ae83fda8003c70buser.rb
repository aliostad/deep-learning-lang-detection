ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :first_name, :last_name, :enterprise_name, :custom_admin,
                :phone, :education, :experience, :specialize, :category_id, :career_id, :location_id, :permissions => []
  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :first_name
      f.input :last_name
      f.input :category
      f.input :career
      f.input :enterprise_name
      # f.input :permissions, as: :check_boxes, collection: ['manage_config', 'manage_users', 'manage_jobs', 'manage_news', 'manage_galleries'], checked: ['manage_users']
      # f.input :permissions, as: :check_boxes, collection: ['manage_config', 'manage_users', 'manage_jobs', 'manage_news', 'manage_galleries'], :input_html => { :checked => true }
      # f.input :permissions, label: "Notification", as: :check_boxes, collection: ["None", "Daily", "Weekly", "Monthly", "Quarterly", "Yearly"], :item_wrapper_class => 'inline', :checked => ["Daily"]

      div class: 'active_admin_custome_checkbox' do
        f.collection_check_boxes :permissions,[['manage_config', 'Quản lý cài đặt'], ['manage_users', 'Quản lý người dùng'], ['manage_jobs', 'Quản lý việc làm'], 
                                              ['manage_news', 'Quản lý tin tức'], ['manage_galleries', 'Quản lý thư viện']], 
                                              :first, :last, checked: f.object.permissions.present? ? (eval(f.object.permissions).reject { |c| c.empty? }) : ''
      end
      f.input :location_id, as: :select, collection: Location.all.map{|u| ["#{u.name}", u.id]}, include_blank: true
      f.input :phone
      f.input :education
      f.input :experience
      f.input :specialize
    end
    f.actions
  end

  index do
    id_column
    column :email
    column :type
    column :admin
    column :location
    actions
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
      super
    end
  end
end