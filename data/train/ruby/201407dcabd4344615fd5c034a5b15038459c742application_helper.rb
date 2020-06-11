module ApplicationHelper

  def fetch_filters
    case params[:model_type]
    when"Feed"
      FeedType.all.collect{|ft| [ft.post_type, ft.id]}
    when "User"
      UserType.all.collect{|ut| [ut.name, ut.id]}
    else
      []
    end
  end

  def account_setting_hash
    {"Account Management" => ["General", "Status"],  "My Wall Profile" => ["Create About me","Sort About me list", "Add Profile Photos"],  "Manage Connections" => [ "Create List names", "Lists Update"],   "Manage Circles" => ["Manage Social Circles", "Other's Edit"],   "Manage Catalogs" => ["Manage Fan Pages", "Other's Edit"] }
  end

end
