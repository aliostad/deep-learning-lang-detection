package synergia.platri

import scala.collection.mutable.ListBuffer
import TUIO._

abstract class Graphic(val parent: Object) extends GFX

class Object(val source: TuioObject) extends Node with Events {
    var oldClose = new ListBuffer[Object]()
    protected val graphics = new ListBuffer[Graphic]()

    def symbolID = source.getSymbolID

    def angle = source.getAngleDegrees

    def rotationSpeed = source.getRotationSpeed

    override def display {
        super.display
        if(Config.DEBUG) {
            View.fill(Calibration.backgroundColor-10)
            View.ellipse(x, y, 100, 100)
            View.fillBackground
            View.ellipse(x, y, 80, 80)
        }
        displayGraphics
    }

    def move {
        onMoved
        updateCloseObjects(true)
    }

    def remove {
        onRemoved
    }

    def connections = Manager.connections.filter(_.check(this))

    def incomingConnections = Manager.connections.filter(_.to == this)

    def outgoingConnections = Manager.connections.filter(_.from == this)

    def addConnection(connection: Connection){
        Manager.connections += connection
    }

    def removeConnection(obj: Object){
        Manager.removeConnection(this, obj)
    }

    protected def displayGraphics {
        graphics.foreach(_.display)
    }

    protected def updateCloseObjects(recursive: Boolean) {
        val newClose = findCloseObjects(Config.CLOSE_OBJECT_DISTANCE)
        newClose.foreach { o =>
            if(oldClose.contains(o)) {
                oldClose -= o
            } else {
                if(recursive){
                    this.onCloseAdded(o)
                    o.onCloseAdded(this)
                    o.updateCloseObjects(false)
                }
            }
        }

        if(recursive){
            oldClose.foreach { o =>
                this.onCloseRemoved(o)
                o.onCloseRemoved(this)
                o.updateCloseObjects(false)
            }
        }

        oldClose.clear
        oldClose.appendAll(newClose)
    }

    protected def findCloseObjects(range: Int) = Manager.findCloseObjects(this, range)
}
