  # encoding: utf-8
namespace :permissions do
  task :run => :environment do
    puts '*************************************'
    puts '======== START  TASK ========='
    create_permission(:manage_hh_controls,      'User can manage HH controls')
    create_permission(:manage_seller_controls,  'User can manage seller controls')
    create_permission(:manage_sales,            'User can manage sales')
    create_permission(:manage_candidates,       'User can manage candidates')
    create_permission(:self_reports,            'User can manage own reports')
    create_permission(:summary_table_reports,   'User can view summary table reports')
    create_permission(:hr_admin,                'User can manage hr admin room')
    create_permission(:crm_controls_admin,      'User can manage other crm controls')
    create_permission(:all_reports,             'User can view all reports')
    create_permission(:administrate_all,        'User has all rights')
    puts '======== FINISH TASK ========='
    puts '************************************'
  end

  def create_permission(name, description)
    return if Permission.exists?(name: name) 
    Permission.create(name: name, description: description) 
  end
end
