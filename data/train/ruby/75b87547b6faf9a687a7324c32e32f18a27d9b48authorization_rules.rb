authorization do
  
  role :system do
    has_permission_on :configurations, :to => :manage
  end
  
end
privileges do
  privilege :manage do
    includes :create, :update, :dstroy
  end
  privilege :manage, :configurations,:includes =>[:index,:add_permissions_user,:create_permission_user]
  privilege :manage, :home,:includes =>[:index]
  privilege :manage, :cites,:includes =>[:index,:new,:edit,:show]
  privilege :manage, :consults,:includes =>[:index,:new,:edit,:show,:print_prenscription]
  privilege :manage, :medicaments,:includes =>[:index,:new,:edit,:show]
  privilege :manage, :organizations,:includes =>[:index,:new,:edit,:show,:add_medicaments]
  privilege :manage, :patients,:includes =>[:index,:new,:edit,:show,:get_patient_for_medic]
  privilege :manage, :time_limits,:includes =>[:index,:new,:edit,:show]
  privilege :manage, :user_sessions, :includes=> [:heartbeat]
end