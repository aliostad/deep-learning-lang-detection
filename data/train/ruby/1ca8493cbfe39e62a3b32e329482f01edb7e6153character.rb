class Stats
	attr_reader :level, :strength, :perception, :endurance, :charisma, :intelligence, :agility, :luck, :max_hp, :max_sp, :max_lp

	def initialize(level, strength, perception, endurance, charisma, intelligence, agility, luck)
		@level = data[:level]
		@strength = data[:strength]
		@perception = data[:perception]
		@endurance = data[:endurance]
		@charisma = data[:charisma]
		@intelligence = data[:intelligence]
		@agility = data[:agility]
		@luck = data[:luck]

		first_roll
		re_roll_1
		re_roll_2
		re_roll_3
		calculate_max_hp
		calculate_max_sp
		calculate_max_lp
	end
	

	private
	def first_roll
		#stuff regarding randomization for the first 7-stat roll
		#likely to use 1 + rand(10) for each stat
		#Additional possibilities include creating a Dice class which could then be used to directly replace responses related to dice or random integers.
	end
	def re_roll_1
		#enable selection of a full reroll or move to singular rerolls
	end
	def re_roll_2
		#if singular reroll, choose new target, else give options
	end
	def re_roll_3
		#if singular reroll, choose new target, else give options
	end
	def calculate_max_hp
		@max_hp = (5 * :level) + (5 * :strength) + (10 * :endurance)
	end
	def calculate_max_sp
		@max_sp = (5 * :level) + (10 * :endurance) + (5 * :intelligence)
	end
	def calculate_max_lp
		@max_lp = 1 + (:level / 5).floor + (:endurance / 3).floor
	end
end

class Skills
	attr_reader :stats, :energy_weapons, :explosives, :heavy_weapons, :lockpick, :medicine, :melee_weapons, :repair, :science, :small_arms, :sneak, :speech, :unarmed
	def initialize(level, strength, perception, endurance, charisma, intelligence, agility, luck)
		calculate_skill_barter
		calculate_skill_energy_weapons
		calculate_skill_explosives
		calculate_skill_heavy_weapons
		calculate_skill_lockpick
		calculate_skill_medicine
		calculate_skill_melee_weapons
		calculate_skill_repair
		calculate_skill_science
		calculate_skill_small_arms
		calculate_skill_sneak
		calculate_skill_speech
		calculate_skill_unarmed
	end
	
	private

	def calculate_skill_barter
		@barter = (2 * :charisma) + :intelligence
	end
	def calculate_skill_energy_weapons
		@energy_weapons = :perception + :intelligence + :agility
	end
	def calculate_skill_explosives
		@explosives = :strength + :perception + :agility
	end
	def calculate_skill_heavy_weapons
		@heavy_weapons = :strength + :endurance + :perception
	end
	def calculate_skill_lockpick
		@lockpick = (2 * :perception) + :agility
	end
	def calculate_skill_medicine
		@medicine = (2 * :intelligence) + :charisma
	end
	def calculate_skill_melee_weapons
		@melee_weapons = (2 * :strength) + :endurance
	end
	def calculate_skill_repair
		@repair = (2 * :perception) + :intelligence
	end
	def calculate_skill_science
		@science = :perception + (2 * :intelligence)
	end
	def calculate_skill_small_arms
		@small_arms = (2 * :perception) + :agility
	end
	def calculate_skill_sneak
		@sneak = :perception + (2 * :agility)
	end
	def calculate_skill_speech
		@speech = (2 * :charisma) + :intelligence
	end
	def calculate_skill_unarmed
		@unarmed = :strength + :endurance + :agility
	end
end

class Character
	attr_reader :stats, :skills

	def initialize(name, faction, stats, skills, traits, three_tags)
		@name = name
		@faction = faction
		@stats = Stats.new
		@skills = Skills.new(@stats)
		@traits = traits
		@three_tags = three_tags
	end
end
