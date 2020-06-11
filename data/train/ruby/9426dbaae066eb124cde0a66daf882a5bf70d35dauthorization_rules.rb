authorization do
  
  role :sessions do
    has_permission_on :p_config_user_sessions, :to => :manage
  end
  
  role :config_all do
    has_permission_on :p_config_products, :to => :manage
    has_permission_on :p_config_product_types, :to => :manage
    has_permission_on :p_config_standards, :to => :manage
    has_permission_on :p_config_stoppages, :to => :manage
    has_permission_on :p_config_users, :to => :manage
    has_permission_on :p_config_boot_variables, :to => :manage
    has_permission_on :p_config_stations, :to => :manage
    has_permission_on :p_config_reasons, :to => :manage
    has_permission_on :p_config_work_times, :to => :manage
    has_permission_on :p_config_inputs, :to => :manage
    has_permission_on :p_config_events, :to => :manage
    has_permission_on :configurations, :to => :manage
    has_permission_on :p_config_fixed_amounts, :to => :manage
    has_permission_on :p_config_standard_types, :to => :manage
    has_permission_on :p_config_line_sets, :to => :manage
  end
  
  role :system do
    includes :config_all
    includes :default
    has_permission_on :authorization_rules, :to => :read
    has_permission_on :p_config_user_sessions, :to => :manage
  end
  
  role :default do
    has_permission_on :home, :to => :manage
    includes :sessions
  end
  
  role :guest do
    includes :sessions
  end
  
end
privileges do
  privilege :manage do
    includes :create, :update, :dstroy
  end
  privilege :manage, :p_config_user_sessions,:includes =>[:create_session, :new, :destroy_session, :heartbeat]
  privilege :manage, :p_config_products,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_product_types,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_standards,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_stoppages,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_users,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_reasons,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_work_times,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_stations,:includes =>[:index, :new, :edit, :show, :comprovate_ip,:choose_products]
  privilege :manage, :p_config_boot_variables,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_fixed_amounts,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_inputs,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_events,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_standard_types,:includes =>[:index, :new, :edit, :show]
  privilege :manage, :p_config_line_sets,:includes =>[:index, :new, :edit, :show]
  
  privilege :manage, :configurations,:includes =>[:index,:home,:add_permissions_user,:create_permission_user]
  privilege :manage, :home,:includes =>[:index, :operator, :manager, :validate_status, :timer_actions, :add_items, :timers, :change_product, :select_graph]
end