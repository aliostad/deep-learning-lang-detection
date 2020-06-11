SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|

    primary.item :indicators, "Справочник показателей", manage_indicators_path do |indicators|
      if @period
        indicators.item :new_indicator, 'Новый показатель', new_manage_period_indicator_path(@period)
        indicators.item :edit_indicator, @indicator.title, edit_manage_period_indicator_path(@period, @indicator) if @indicator.try(:persisted?)
      end

      indicators.item :indicator,  @indicator.title, manage_indicator_notes_path(@indicator) do |indicator|
        indicator.item :new_note,  'Новая запись', new_manage_indicator_note_path(@indicator)
        indicator.item :edit_note, @note.title, edit_manage_indicator_note_path(@indicator, @note) if @note.try(:persisted?)
      end if @indicator.try(:persisted?)
    end if @indicator

    primary.item :periods, "Управление периодами", manage_periods_path do |period|
      period.item :new_period, 'Новый период', new_manage_period_path
      period.item :edit_period, @period.title, edit_manage_period_path(@period) if @period.try(:persisted?)
    end if @period

    primary.item :permissions, "Права доступа", manage_permissions_path do |permission|
      permission.item :new_permission, 'Добавить права доступа', new_manage_permission_path
    end if @permission

    primary.item :members, "Поиск сотрудника", search_manage_members_path, :highlights_on => /^\/manage$|\/members/ do |members|
      members.item :member, @member.full_name, manage_member_path(@member), :highlights_on => /\/members/
    end if @member && current_user.permissions.any?

    primary.dom_class = 'breadcrumbs'
  end
end
