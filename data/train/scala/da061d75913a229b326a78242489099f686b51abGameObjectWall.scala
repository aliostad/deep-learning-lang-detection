package gie.aarca

import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.graphics.g2d.Sprite
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType
import com.badlogic.gdx.physics.box2d._
import gie.gdx.{ResourceContext, manageDisposableResource, manageResource}
import gie.gdx.implicits._

class GameObjectWall(posX: Float, posY: Float, override val width: Float , override val height: Float)(implicit world: World, resourceContext: ResourceContext) extends GameObjectTrait { go=>

    override def x = m_body.getPosition.x
    override def y = m_body.getPosition.y

    private val m_body = world.createBody(new BodyDef {
        `type` = BodyType.StaticBody
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
    })

    def sprite: Sprite = null
    def body: Body = m_body

    init()

}
