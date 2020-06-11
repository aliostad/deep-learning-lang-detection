require 'redmine'

Redmine::Plugin.register :redmine_manage_summary do
  name 'Redmine Manage Summary plugin'
  author 'Yuichiro Endo'
  description 'Redmine Manage Summary plugin'
  version '0.1.1'
  url 'https://github.com/jp-yendo/redmine_manage_summary.git'
  author_url 'https://github.com/jp-yendo'

  project_module :time_manage_summary do
    permission :view_time_manage_summary, {:time_summary => [:index]}
    permission :view_time_manage_project_summary, {:time_summary => [:show]}
  end

  menu :top_menu, :time_manage_summary,
    {:controller => 'time_summary', :action => 'index'},
    :caption => :menu_label_time_manage_summary,
    :if => Proc.new{User.current.logged?}

  menu :project_menu, :time_manage_summary,
    {:controller => 'time_summary', :action => 'show'},
    :caption => :menu_label_time_manage_summary #, :after => :new_issue

  project_module :progress_manage_summary do
    permission :view_progress_manage_summary, {:progress_summary => [:index]}
    permission :view_progress_manage_project_summary, {:progress_summary => [:show]}
  end
  
  menu :top_menu, :progress_manage_summary,
    {:controller => 'progress_summary', :action => 'index'},
    :caption => :menu_label_progress_manage_summary,
    :if => Proc.new{User.current.logged?}

  menu :project_menu, :progress_manage_summary,
    {:controller => 'progress_summary', :action => 'show'},
    :caption => :menu_label_progress_manage_summary
  
  settings :partial => 'settings/managesummary_settings',
           :default => {
              'region' => :jp,
              'threshold_lowtime'   => 0.1,
              'threshold_normalload'=> 7.6,
              'threshold_overtime'  => 9.6,
              'threshold_hardtime'  => 11.6,
              'threshold_progress_good' => 3,
              'threshold_progress_bad' => 3,
              'threshold_progress_very_bad' => 10
           }
end
