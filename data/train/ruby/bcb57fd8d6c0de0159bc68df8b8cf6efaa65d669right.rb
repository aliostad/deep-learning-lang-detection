class Right < ActiveRecord::Base
  attr_accessible :operation, :resource

  has_many :grants
  has_many :roles, through: :grants
  
  OPERATION_MAPPINGS = {
    "new" => "CREATE",
    "create" => "CREATE",
    "edit" => "UPDATE",
    "request_featured" => "UPDATE",
    "update" => "UPDATE",
		"set_as_current" => "UPDATE",
    "destroy" => "DELETE",
    "show" => "READ",
    "featured_show" => "READ",
    "index" => "READ",
    "index_for_listing" => "READ",
    "search" => "READ",
		"nearyou" => "READ",
		"current" => "READ",
		"index_dispensaries" => "READ",
		"index_strains" => "READ",
    "user_index" => "MANAGE",
    "pull" => "MANAGE",
    "backend_show" => "MANAGE",
    "backend_search" => "MANAGE",
    "manage" => "MANAGE",
    "home" => "HOME",
		"birthday" => "BIRTHDAY",
		"admin_index" => "ADMIN",
		"confirm" => "ADMIN",
		"admin_destroy" => "ADMIN",
		"admin_update" => "ADMIN",
		"renew_featured" => "ADMIN",
		"renew" => "ADMIN",
		"manage_featured" => "ADMIN",
		"set_as_featured" => "ADMIN"
  }
end
