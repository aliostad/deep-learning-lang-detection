package game.entity.event

import game.entity.character.Character
import game.random.Bag
import game.tools.StringUtils._
import org.joda.time.DateTime

trait CharacterDeathEvent extends CharacterEvent with TriggerableEvent {
  
  override def resolve(character:Character, date:Option[DateTime] = None):LifeEvent = {
    val oldEvent = super.resolve(character, date)
    
    val event = LifeEvent(LifeEventType.Death,
        oldEvent.date.hourOfDay().addToCopy(1) ,
        oldEvent.character ,
        oldEvent.description )
        
    event
  }
}

