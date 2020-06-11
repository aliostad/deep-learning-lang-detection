# @author Craig Read
#
# PointsCalculationHelper calculates points for characters and players.
module PointsCalculationHelper
  def attendance_for_period(range = {start:  nil, end: nil}, aggregate_up = true)
    raid_count(range, aggregate_up).to_f / Raid.for_period(range).count.to_f * 100.00
  end

  def attendance
    return 0.00 if Raid.count == 0
    raids_count.to_f / Raid.count.to_f * 100.00
  end

  def recalculate_loot_rates(raids_attended = 0)
    return if @inside_callback
    @inside_callback = true
    calculate_armour_rate(raids_attended)
    calculate_jewellery_rate(raids_attended)
    calculate_weapon_rate(raids_attended)
    calculate_attuned_rate(raids_attended)
    calculate_adornment_rate(raids_attended)
    calculate_dislodger_rate(raids_attended)
    calculate_mount_rate(raids_attended)
    calculate_switch_rate(raids_attended)
  end

  def raid_count(range = {start:  nil, end: nil}, aggregate_up = true)
    if aggregate_up and self.is_a? Character
      self.player.raids.for_period(range).uniq.count
    else
      self.raids.for_period(range).uniq.count
    end
  end

  def calculate_loot_rate(event_count, item_count)
    return 0.0 if event_count.nil? or item_count.nil?
    (Float(event_count) / (Float(item_count) + 1.0) * 100.00).round / 100.00
  end

  def first_drop
    drops.order('drop_time').first
  end

  def last_drop
    drops.order('drop_time desc').first
  end

  def first_instance
    instances.order('start_time').first
  end

  def last_instance
    instances.order('start_time desc').first
  end

  def first_raid
    raids.order('raid_date').first
  end

  def last_raid
    raids.order('raid_date desc').first
  end

  def first_raid_date
    first_raid ? first_raid.raid_date.strftime('%Y-%m-%d') : nil
  end

  def last_raid_date
    last_raid ? last_raid.raid_date.strftime('%Y-%m-%d') : nil
  end

  private

  def calculate_armour_rate(raids_attended)
    self.armour_rate = calculate_loot_rate(raids_attended, self.armour_count)
  end

  def calculate_jewellery_rate(raids_attended)
    self.jewellery_rate = calculate_loot_rate(raids_attended, self.jewellery_count)
  end

  def calculate_weapon_rate(raids_attended)
    self.weapon_rate = calculate_loot_rate(raids_attended, self.weapons_count)
  end

  def calculate_attuned_rate(raids_attended)
    self.attuned_rate = calculate_loot_rate \
      raids_attended, self.armour_count + self.jewellery_count + self.weapons_count
  end

  def calculate_adornment_rate(raids_attended)
    self.adornment_rate = calculate_loot_rate(raids_attended, self.adornments_count)
  end

  def calculate_dislodger_rate(raids_attended)
    self.dislodger_rate = calculate_loot_rate(raids_attended, self.dislodgers_count)
  end

  def calculate_mount_rate(raids_attended)
    self.mount_rate = calculate_loot_rate(raids_attended, self.mounts_count)
  end

  def calculate_switch_rate(raids_attended)
    if self.respond_to? :switches_count
      self.switch_rate = calculate_loot_rate(raids_attended, self.switches_count)
    end
  end
end
