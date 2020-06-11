//       ___       ___       ___       ___       ___
//      /\  \     /\__\     /\__\     /\  \     /\__\
//     /::\  \   /:/ _/_   /:| _|_   /::\  \   /:/  /
//    /::\:\__\ /::-"\__\ /::|/\__\ /::\:\__\ /:/__/
//    \;:::/  / \;:;-",-" \/|::/  / \;:::/  / \:\  \
//     |:\/__/   |:|  |     |:/  /   |:\/__/   \:\__\
//      \|__|     \|__|     \/__/     \|__|     \/__/

package ru.rknrl.castles.game.state

import protos.GameStateUpdate
import ru.rknrl.castles.game.GameConfig

object GameStateDiff {
  def diff(oldState: GameState, newState: GameState) = {
    val newTime = newState.time
    val createdUnits = newState.units.filter(u ⇒ !oldState.units.exists(_.id == u.id))
    val removedUnits = oldState.units.filter(u ⇒ !newState.units.exists(_.id == u.id))
    val killedUnits = removedUnits.filter(u ⇒ !u.isFinish(newTime))
    val createdFireballs = newState.fireballs.filter(f ⇒ !oldState.fireballs.exists(_ == f))
    val createdVolcanoes = newState.volcanoes.filter(v ⇒ !oldState.volcanoes.exists(_ == v))
    val createdTornadoes = newState.tornadoes.filter(t ⇒ !oldState.tornadoes.exists(_ == t))
    val createdBullets = newState.bullets.filter(b ⇒ !oldState.bullets.exists(_ == b))

    GameStateUpdate(
      newUnits = createdUnits.map(_.dto(newTime)),
      newFireballs = createdFireballs.map(_.dto(newTime)).toSeq,
      newVolcanoes = createdVolcanoes.map(_.dto(newTime)).toSeq,
      newTornadoes = createdTornadoes.map(_.dto(newTime)).toSeq,
      newBullets = createdBullets.map(_.dto(newTime)).toSeq,
      unitUpdates = getUnitUpdates(oldState.units, newState.units).toSeq,
      killUnits = killedUnits.map(_.id),
      buildingUpdates = getBuildingUpdates(oldState.buildings, newState.buildings).toSeq,
      itemStatesUpdates = getItemStatesUpdates(oldState.items, newState.items, oldState.config, newTime).toSeq
    )
  }

  def getUnitUpdates(oldUnits: Iterable[GameUnit], newUnits: Iterable[GameUnit]) =
    for (newUnit ← newUnits;
         oldUnit = oldUnits.find(_.id == newUnit.id)
         if oldUnit.isDefined
         if oldUnit.get differentWith newUnit
    ) yield newUnit.updateDto

  def getBuildingUpdates(oldBuildings: Iterable[Building], newBuildings: Iterable[Building]) =
    for (newBuilding ← newBuildings;
         oldBuilding = oldBuildings.find(_.id == newBuilding.id)
         if oldBuilding.isDefined
         if oldBuilding.get differentWith newBuilding
    ) yield newBuilding.updateDto

  def getItemStatesUpdates(oldItems: GameItems, item: GameItems, config: GameConfig, time: Long) =
    for ((playerId, state) ← item.states;
         oldState = oldItems.states(playerId)
         if state != oldState
    ) yield state.dto(playerId, time, config)
}
