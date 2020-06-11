#-------------------------------------------------------------------------------
# Name:        Maleficium Game Logic
#                    Made for Maleficium: The Demon Scrolls
#                       malificiumgame.com
#
# Author:      Thomas Gull
#
# Created:     29/12/2011
#-------------------------------------------------------------------------------

import base_vars

class ClassLevel:
    def __init__(self, value, bab, fort_save, ref_save, will_save, specials):
        self.value = value
        self.bab = bab
        self.fort_save = fort_save
        self.ref_save= ref_save
        self.will_save = will_save
        self.specials = specials
        self.spells_per_day = None
        self.spells_known = None

class MonkLevel(ClassLevel):
    def __init__(self, value, bab, fort_save, ref_save, will_save, specials):
        ClassLevel.__init__(self, value, bab, fort_save, ref_save, will_save, specials)
        self.flurry_bonus = None

    def setFlurryBonus(self, value):
        self.flurry_bonus = value

    def setUnarmedDamage(self, value):
        self.unarmed_damage = None

    def setACBonus(self, value):
        self.ac_bonus = value

    def setFastMovement(self, value):
        self.fast_movement = value

class GameClass:
    def __init__(self):
        self.name = None
        self.base_attack_bonus = []
        self.level = 0
        self.fort_save_table = []
        self.fort_save = 0
        self.ref_save_table = []
        self.ref_save = 0
        self.will_save_table = []
        self.will_save = 0
        self.skill_rank_increase = 0
        self.class_skills = []
        self.hit_die = 0
        self.alignments = []

    def setBaseAttackBonus(self, bab):
        self.base_attack_bonus = bab

    def levelUp(self):
        raise NotImplementedError()

    def setSaveTable(self, which, what):
        if which == base_vars.FORT:
            self.fort_save_table = what
        elif which == base_vars.REF:
            self.ref_save_table = what
        elif which == base_vars.WILL:
            self.will_save_table = what

    def setSpecial(self, level, special):
        pass

    def weaponProf(self):
        pass

    def armorProf(self):
        pass

