module InventoryManagesHelper

  def bind_type_name(bind_type_id)
    ShelfBindType.all.each do |s|
      return s.display_name if s.try(:id) == bind_type_id
    end
    return ""
  end

  def manifestation_type_names(manifestation_type_ids)
    s = ""
    if manifestation_type_ids.present?
      list = ManifestationType.where(:id => manifestation_type_ids).pluck(:display_name)
      if list
        s = list.join(',')
      end
    end
    s
  end

  def shelf_group_names(shelf_group_ids)
    s = ""
    if shelf_group_ids.present?
      list = InventoryShelfGroup.where(:id => shelf_group_ids).pluck(:display_name)
      if list
        s = list.join(',')
      end
    end
    s
  end

  def inventory_manage_state(inventory_manage)
    case inventory_manage.state
    when 0
      I18n.t('activerecord.attributes.inventory_manage.state_name.init')
    when 6
      I18n.t('activerecord.attributes.inventory_manage.state_name.prepare_check')
    when 7
      I18n.t('activerecord.attributes.inventory_manage.state_name.check_start')
    when 8
      I18n.t('activerecord.attributes.inventory_manage.state_name.check_finish')
    when 9
      I18n.t('activerecord.attributes.inventory_manage.state_name.finished')
    else
      I18n.t('activerecord.attributes.inventory_manage.state_name.undefined')
    end
  end

end
