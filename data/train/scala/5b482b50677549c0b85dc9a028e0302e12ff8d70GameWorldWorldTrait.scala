package gie.aarca

import com.badlogic.gdx.math.Vector2
import com.badlogic.gdx.physics.box2d.World
import gie.gdx.{ResourceContext, manageDisposableResource, manageResource}

import scala.collection.mutable


trait UpdatableWorldTrait {
    def updateWorld(): Unit
}


object CollisionCategories {
    val batDynamic: Short = 2
    val batStatic: Short = 4
}


trait GameWorldWorldTrait { this: ArcanoidStage =>

    protected val w:Float = 20  //blocks
    protected val h:Float = (w*1.66f).toInt

    protected implicit def implicitBoxWorld:World = world.apply()

    val world = manageDisposableResource (new World(new Vector2(0, 0), true))


    private val afterWorldCmdQueue = new mutable.ArrayBuffer[()=>Unit]()

    protected def applyAfterWorldCmdQueue(): Unit ={
        afterWorldCmdQueue.foreach(_.apply())
        afterWorldCmdQueue.clear()
    }

    protected def enqueueAfterWorldCmd(f: ()=>Unit): Unit ={
        afterWorldCmdQueue += f
    }


}
