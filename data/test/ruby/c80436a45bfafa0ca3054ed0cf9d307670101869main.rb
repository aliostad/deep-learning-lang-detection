# -*- encoding : utf-8 -*-
module Stats
  module Main
    def calculate_main_stats
      [calculate_s, calculate_zr, calculate_wt, calculate_int, calculate_wi, calculate_o]
    end

    def calculate_s
      strength + calculate_main_skill_bonus_for("S") + trait_modifier_for_main_skill_named("S")
    end

    def calculate_int
      intelligence + calculate_main_skill_bonus_for("INT") + trait_modifier_for_main_skill_named("INT")
    end

    def calculate_zr
      dexterity + calculate_main_skill_bonus_for("ZR") + trait_modifier_for_main_skill_named("ZR")
    end

    def calculate_wi
      faith + calculate_main_skill_bonus_for("WI") + trait_modifier_for_main_skill_named("WI")
    end

    def calculate_wt
      endurance + calculate_main_skill_bonus_for("WT") + trait_modifier_for_main_skill_named("WT")
    end

    def calculate_o
      polish + calculate_main_skill_bonus_for("O") + trait_modifier_for_main_skill_named("O") +
          special_bonus_from_weapons(character) #TODO Refactor this, if there is more of item stats modifiers cases
    end

    def calculate_current_zr
      armor = character.character_armors.detect { |armor| armor.favorite? }
      character.wield_style.name=="Styl walki bronią i tarczą" ? shield = character.character_shields.detect { |shield| shield.favorite? } : shield = nil

      combined_dexterity_cap = [armor.try(:calculate_dexterity_cap), shield.try(:calculate_dexterity_cap)].compact.min.to_i
      combined_dexterity_cap = 666 if combined_dexterity_cap.zero?
      combined_dexterity_nerf = armor.try(:calculate_dexterity_nerf).to_i + shield.try(:calculate_dexterity_nerf).to_i

      result = combined_dexterity_nerf + calculate_zr
      return 1 if result < 1
      return combined_dexterity_cap if result > combined_dexterity_cap
      return result if result <= combined_dexterity_cap
    end

    def calculate_main_skill_bonus_for(name)
      stats_modifiers.select { |sm| sm.modifies==name }.collect(&:value).sum
    end

    def trait_modifier_for_main_skill_named(name)
      if character.character_background.traits.present? && character.character_background.traits.first.stats_choices.present?
        character.character_background.traits.first.stats_choices.first.stats_modifiers.select { |sm| sm.modifies==name }.map(&:value)[0].to_i #this looks like it, because *you* (I am pointing to myself) are to lazy to push modifiers from traits, like you're doing it with everything else.'
      else
        0
      end
    end

    def trait_modifier_for_auxiliary_parameter_named(name)
      if character.character_background.traits.present? && character.character_background.traits.first.stats_choices.present?
        character.character_background.traits.first.stats_choices.first.stats_modifiers.select { |sm| sm.group_name==name }.map(&:value)[0].to_i
      else
        0
      end
    end

    def calculate_dexterity_bonus
      Statistics::BONUS_OR_PENALTY_RANGES_MAP[calculate_zr].to_i
    end

    def calculate_strength_bonus
      Statistics::BONUS_OR_PENALTY_RANGES_MAP[calculate_s].to_i
    end

    def calculate_dexterity_and_strength_bonus
      statistics_sum = calculate_strength_bonus + calculate_dexterity_bonus
      (statistics_sum.to_f / 2).ceil
    end

    def the_above_fifteen_zr_bonus
      calculate_current_zr - 15 < 0 ? 0 : calculate_current_zr - 15
    end

    def special_bonus_from_weapons(character)
      noble_mace = character.weapons.where(:name => "Obuszek Szlachecki").first
      noble_mace ? 1 : 0
    end
  end
end