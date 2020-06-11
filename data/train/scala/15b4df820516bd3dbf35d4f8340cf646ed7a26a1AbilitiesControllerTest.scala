package efa.dsa.abilities.services

import efa.rpg.items.specs.ItemControllerProps
import org.scalacheck.Properties

object AbilitiesControllerTest
 extends Properties("AbilitiesController")
 with ItemControllerProps {

  import AbilitiesController._
  override protected def factory = AbilitiesController

  property("advantages_load") = testLoading(advantageC)
  property("handicap_load") = testLoading(handicapC)
  property("feat_load") = testLoading(featC)
  property("language_load") = testLoading(languageC)
  property("scripture_load") = testLoading(scriptureC)
  property("talentC_load") = testLoading(talentC)
  property("melee_load") = testLoading(meleeC)
  property("ranged_load") = testLoading(rangedC)
  property("spell_load") = testLoading(spellC)
  property("ritual_load") = testLoading(ritualC)
    
}

// vim: set ts=2 sw=2 et:
