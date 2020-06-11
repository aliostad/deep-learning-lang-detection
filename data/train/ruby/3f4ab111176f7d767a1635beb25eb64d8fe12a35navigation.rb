SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :thanks, 'Благодарности пациентов', manage_thanks_path,
      highlights_on: /\A\/manage(\z|\/thanks)/ if current_user.manager? || current_user.admin?

    primary.item :doctors, 'Земский доктор', manage_doctors_path,
      highlights_on: /\A\/manage\/doctors/ if current_user.manager? || current_user.admin?

    primary.item :evaluation_registries, 'Поликлиника начинается с регистратуры', manage_evaluation_registries_path,
      highlights_on: /\A\/manage\/evaluation_registries/ if current_user.manager? || current_user.admin?

    primary.item :video_messages, 'Видео обращения', manage_video_messages_path,
      highlights_on: /\A\/manage\/video_messages/ if current_user.manager? || current_user.admin?

    primary.item :eco_coupons, 'ЭКО талоны', eco_coupons_path,
      highlights_on: /\A\/eco\/coupons/ if current_user.operator? || current_user.admin?

    primary.item :users, 'Пользователи', manage_users_path,
      highlights_on: /\A\/manage\/users/ if current_user.admin?
  end
end
