package gie.aarca

import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.graphics.g2d.Sprite
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType
import com.badlogic.gdx.physics.box2d._
import gie.gdx.{ResourceContext, ResourceHolder, manageDisposableResource, manageResource}
import gie.gdx.implicits._



class GameObjectBall(textureHolder: ResourceHolder[Texture], posX: Float, posY: Float)(implicit world: World, resourceContext: ResourceContext) extends GameObjectTrait { go =>
    def texture = textureHolder()
    private val m_sprite = {
        val s = new Sprite(texture)
        s.setSize(1f,1f)
        s.setOriginCenter()
        s.setOPosition(posX, posY)
        s
    }

    private val m_body = world.createBody(new BodyDef {
        `type` = BodyType.DynamicBody
        position.set(go.x, go.y)
        linearVelocity.set(15f, 15f)
        linearDamping = 0f
    })

    private val goShape = manageResource(new CircleShape(){
        setRadius(go.width/2)
    })

    private val fixture0 = m_body.createFixture( new FixtureDef{
        shape = goShape()
        density = 1f
        restitution = 1f
        friction = 0f
        filter.maskBits = (filter.maskBits & (~CollisionCategories.batDynamic)).toShort
    })


    def sprite: Sprite = m_sprite

    def body: Body = m_body

    init()
}
