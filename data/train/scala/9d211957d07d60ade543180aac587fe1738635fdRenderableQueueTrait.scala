package gie.aarca

import com.badlogic.gdx.graphics.g2d.SpriteBatch
import gie.gdx.{ResourceContext, manageDisposableResource, manageResource}

import scala.collection.mutable


trait RenderableQueueTrait { this: ArcanoidStage=>

    private val renderableObjects = mutable.Set[RenderableTrait]()

    protected def addRenderable(o: RenderableTrait): Unit ={
        val isAdded = renderableObjects.add(o)
        assume(isAdded)
    }

    protected def addRenderable(o1: RenderableTrait, o2: RenderableTrait*): Unit ={
        addRenderable(o1)
        o2.foreach(addRenderable _)
    }

    protected def removeRenderable(o: RenderableTrait): Unit ={
        val isRemoved = renderableObjects.remove(o)
        if(!isRemoved){
            logger.warn(s"Renderable ${o} was already destroyed, double free!")
        }
    }

    protected def renderRenderable(lb:SpriteBatch): Unit ={
        renderableObjects.foreach{o=>
            o.update()
            o.render(lb)
        }
    }


}