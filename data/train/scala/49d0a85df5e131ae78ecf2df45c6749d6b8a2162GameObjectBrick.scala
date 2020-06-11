package gie.aarca

import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.graphics.g2d.Sprite
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType
import com.badlogic.gdx.physics.box2d._
import gie.gdx.{ResourceContext, manageDisposableResource, manageResource}
import gie.gdx.implicits._

class GameObjectBrick(texture: Texture,posX: Float, posY: Float)(implicit world: World, resourceContext: ResourceContext) extends GameObjectTrait { go=>

    protected var hitCounter = 0


    def hitLimitReached: Boolean = {
        hitCounter>=1
    }

    def hit(): Unit ={
        hitCounter +=1
    }

    protected val m_sprite = {
        val s = new Sprite(texture)
        s.setSize(2-0.1f,1-0.1f)
        s.setOriginCenter()
        s.setOPosition(posX, posY)
        s
    }

    private val m_body = world.createBody(new BodyDef {
        `type` = BodyType.StaticBody
        position.set(go.x, go.y)
    })

    private val goShape = manageResource(new PolygonShape(){
        override def toString = "GameObjectBrick.PolygonShape()"
        setAsBox(go.width/2, go.height/2)
    })

    private val fixture0 = m_body.createFixture( new FixtureDef{
        shape = goShape()
        density = 1f
        restitution = 1f
        friction = 0f
    })

    def sprite: Sprite = m_sprite
    protected def body: Body = m_body

    init()

}


class GameObjectBrick2(texture: Texture, texture2: Texture, posX: Float, posY: Float)(implicit world: World, resourceContext: ResourceContext) extends GameObjectBrick(texture, posX, posY){

    override def hitLimitReached: Boolean = {
        hitCounter>=2
    }

    protected val m_sprite2 = {
        val s = new Sprite(texture2)
        s.setSize(2-0.1f,1-0.1f)
        s.setOriginCenter()
        s.setOPosition(posX, posY)
        s
    }

    override def sprite: Sprite = if(hitCounter<=0) m_sprite else m_sprite2


}
