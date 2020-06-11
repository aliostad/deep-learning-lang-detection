package gie.aarca

import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.graphics.g2d.Sprite
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType
import com.badlogic.gdx.physics.box2d._
import gie.gdx.{ResourceContext, ResourceHolder, manageDisposableResource, manageResource}
import gie.gdx.implicits._



class GameObjectBat(textureHolder: ResourceHolder[Texture], posX: Float, posY: Float)(implicit world: World, resourceContext: ResourceContext)
    extends GameObjectTrait
    with UpdatableWorldTrait
{ go =>
    def texture = textureHolder()

    private val m_sprite = {
        val s = new Sprite(texture)
        s.setSize(3f,0.5f)
        s.setOriginCenter()
        s.setOPosition(posX, posY)
        s
    }

//    private val goShapeStatic = manageResource(new PolygonShape(){
//        setAsBox(go.width/2+0.5f, go.height/2 + 0.5f)
//    })

    private val goShapeDynamic = manageResource(new PolygonShape(){
        setAsBox(go.width/2, go.height/2)
    })

    private val goShapeStatic = goShapeDynamic


    private val m_bodyDynamic = world.createBody(new BodyDef {
        `type` = BodyType.DynamicBody
        position.set(go.x, go.y)
        fixedRotation = true
        linearDamping = 1f
        allowSleep = false
    })

    private val fixtureDynamic = m_bodyDynamic.createFixture( new FixtureDef{
        shape = goShapeDynamic()
        isSensor = true
        density = 1f
        restitution = 0f
        friction = 0f
        filter.categoryBits = CollisionCategories.batDynamic
        filter.maskBits = (filter.maskBits & (~CollisionCategories.batStatic)).toShort
    })


    private val m_bodyStatic = world.createBody(new BodyDef { //static for ball collision
        `type` = BodyType.StaticBody
        position.set(go.x, go.y)
        fixedRotation = true
    })

    private val fixtureStatic = m_bodyStatic.createFixture( new FixtureDef{
        shape = goShapeStatic()
        density = 1f
        restitution = 1f
        friction = 0f
        filter.categoryBits = CollisionCategories.batStatic
        filter.maskBits = (filter.maskBits & (~CollisionCategories.batDynamic)).toShort
    })


    override def doDestroy(): Unit ={
        val w = world
        w.destroyBody(m_bodyStatic)
        w.destroyBody(m_bodyDynamic)
    }


    def updateWorld(): Unit ={
        val t = m_bodyDynamic.getTransform
        m_bodyStatic.setTransform( t.getPosition, t.getRotation )
    }

    def sprite: Sprite = m_sprite

    def body: Body = m_bodyDynamic

    protected override def init(): Unit ={
        m_bodyDynamic.setUserData(this)
        m_bodyStatic.setUserData(this)
    }

    init()
}
