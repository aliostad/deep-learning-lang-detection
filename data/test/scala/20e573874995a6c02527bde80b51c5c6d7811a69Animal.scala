package edu.luc.cs.cpauliks.cs473.populationmodel

import akka.actor._
import akka.actor.Actor._
import scala.util.Random
import edu.luc.cs.cpauliks.cs473.populationmodel.SimulationMesages._

  /**
   * Animals for the simulation.
   */
  abstract class Animal(xPosition: Int, yPosition: Int, maxAge: Int) extends Actor{
    val rng = new Random()
    var age = 0
    var xPos = xPosition
    var yPos = yPosition
    var oldX: Int = _
    var oldY: Int = _
    
    /**
     * Moves this actor 0-1 spaces in any direction
     */
    def changeLocation() = {
      oldX = xPos
      oldY = yPos
      val forwardX = rng.nextBoolean()
      val forwardY = rng.nextBoolean()
      xPos += (if(forwardX) rng.nextInt(2) else (rng.nextInt(2) * -1))
      yPos += (if(forwardY) rng.nextInt(2) else (rng.nextInt(2) * -1))
    }
    
    def checkIfStillAlive(): Boolean
    
  }
  
  /**
   * Hares move around and only die naturally of old age.
   */
  class Hare(xPosition: Int, yPosition: Int, maxAge: Int) extends Animal(xPosition, yPosition, maxAge) {
    
    def receive = {
      
      case Ping => self reply HarePong(self)
      case Move => {
          changeLocation()
          self reply NewHareLocation(oldX, oldY, xPos, yPos, self)
      }
      case Reproduce => self reply HareCanReproduce(xPos, yPos)
      case CorrectLocation(x, y) => {
        xPos = x
        yPos = y
      }
      case Age => {
	    age += 1
	    if(checkIfStillAlive) None else self reply HareDied(xPos, yPos, self)
	  }
      
      
    }
    
    /**
     * A Hare is dead if it is too old
     */
    def checkIfStillAlive() = {
      if (age <= maxAge) true else false
    }
    
  }
  
  /**
   * Lynx move around and lose energy every year.
   * Lynx will die naturally from having 0 energy or old age.
   */
  class Lynx(xPosition: Int, yPosition: Int, maxAge: Int, startingEnergy: Int, energyPerHare: Int, energyToReproduce: Int) extends Animal(xPosition, yPosition, maxAge) {
   //Only energy level ever changes
    var energy = startingEnergy
   
   /**
    * Receive method for Lynx.
    */
    def receive = {
      case Ping => self reply LynxPong(self)
	  case Move => {
	      changeLocation()
	      self reply NewLynxLocation(oldX, oldY, xPos, yPos, self)
	  }
	  case Eat => energy += energyPerHare
	  case Reproduce => {
	    energy -= 1
	    if(canReproduce()) {
	      energy = energy/2
	      val newLynx = actorOf(new Lynx(xPos, yPos, maxAge, energy, energyPerHare, energyToReproduce)).start()
	      self reply LynxReproduced(xPos, yPos, newLynx)
	    }
	  }
	  case Age => {
	    age += 1
	    if(checkIfStillAlive) None else self reply LynxDied(xPos, yPos, self)
	  }
	  case CorrectLocation(x, y) => {
        xPos = x
        yPos = y
      }
    }
     
   /**
    * A Lynx will reproduce unless it does not have enough energy.
    */
    def canReproduce() = {
      if (energy >= energyToReproduce) true else false
    }
    
   /**
    * A Lynx is dead if it runs out of energy or is too old
    */
    def checkIfStillAlive() = {
      if(age <= maxAge && energy > 0) true else false
    }
    
  }