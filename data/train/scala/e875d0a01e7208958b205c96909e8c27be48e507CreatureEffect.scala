package ee.tkasekamp.pliidikivi.card

import ee.tkasekamp.pliidikivi.card.enums.Type

abstract class CreatureEffect {
}

class HealthCreatureEffect(val effectType: Type.Value, val health: Int) extends CreatureEffect {
  override def toString(): String = {
    "HealthEffect. Type: " + effectType.toString() + ", health : " + health
  }

  def getNewValue(oldValue: Int): Int = {
    effectType match {
      case Type.ABSOLUTE => health
      case Type.RELATIVE => oldValue + health
    }
  }
}
class AttackCreatureEffect(val effectType: Type.Value, val attack: Int) extends CreatureEffect {
  override def toString(): String = {
    "AttackEffect. Type:" + effectType.toString() + ", attack : " + attack
  }

  def getNewValue(oldValue: Int): Int = {
    effectType match {
      case Type.ABSOLUTE => attack
      case Type.RELATIVE => oldValue + attack
    }
  }
}
class TauntCreatureEffect(val taunt: Boolean) extends CreatureEffect {
  override def toString(): String = {
    "TauntEffect. taunt : " + taunt
  }
}