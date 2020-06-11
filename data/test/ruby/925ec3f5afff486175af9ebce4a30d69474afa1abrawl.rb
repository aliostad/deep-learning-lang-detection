# -*- encoding : utf-8 -*-
module Stats
  module Brawl
    def calculate_brawl_bonus_from_special_rules
      0
    end

    def calculate_brawl_bonus_from_skills
      stats_modifiers.select { |sm| sm.modifies=="fighting" && sm.group_name=="Bijatyka" }.collect(&:value).sum
    end

    def calculate_total_brawling(attack_or_defense)
      if attack_or_defense=="attack"
        raw_fencing_when_attacking + calculate_dexterity_and_strength_bonus + calculate_brawl_bonus_from_special_rules + calculate_brawl_bonus_from_skills
      else
        raw_fencing_when_defending + Statistics::BONUS_OR_PENALTY_RANGES_MAP[calculate_current_zr].to_i + Statistics::BONUS_OR_PENALTY_RANGES_MAP[calculate_wi].to_i + calculate_brawl_bonus_from_skills
      end
    end
  end
end