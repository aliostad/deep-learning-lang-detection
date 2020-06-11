package gie.aarca

import com.badlogic.gdx.graphics.g2d.Sprite
import com.badlogic.gdx.math.Vector2
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType
import com.badlogic.gdx.physics.box2d._
import gie.gdx.{ResourceContext, manageDisposableResource, manageResource}

class GameObjectLooserDetector(posX: Float, posY: Float, override val width: Float , override val height: Float)(implicit world: World, resourceContext: ResourceContext) extends GameObjectTrait { go=>

    override def x = m_body.getPosition.x
    override def y = m_body.getPosition.y

    private val m_body = world.createBody(new BodyDef {
        `type` = BodyType.DynamicBody
        position.set(posX, posY)
    })

    private val goShape = manageResource(new PolygonShape(){
        setAsBox(go.width/2, go.height/2)
    })

    private val fixture0 = m_body.createFixture( new FixtureDef{
        shape = goShape()
        density = 1f
        restitution = 1f
        friction = 0f
        isSensor = true
    })

    def sprite: Sprite = null
    def body: Body = m_body

    init()

}


trait GameWorldWallsTrait { this:ArcanoidStage=>

    protected def buildWall(x: Float, y: Float, w: Float, h: Float):GameObjectWall ={
        new GameObjectWall(x, y, w, h)
    }

    protected def buildWorldWalls(): Unit ={
        //bottom
        //buildWall(0, -h/2-1, w, 1) // for debug
        new GameObjectLooserDetector(0, -h/2-1, w, 1)

        //top
        buildWall(0, h/2+1, w, 1)

        //left
        buildWall(-w/2-0.5f, 0, 1, h)

        //right
        buildWall(w/2+0.5f, 0, 1, h)
    }

    buildWorldWalls()

}