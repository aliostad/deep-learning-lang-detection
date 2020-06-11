package gie.aarca

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.graphics.g2d.{Sprite, SpriteBatch}
import com.badlogic.gdx.graphics.{GL20, OrthographicCamera, Texture}
import com.badlogic.gdx.math.Vector2
import com.badlogic.gdx.physics.box2d.BodyDef.BodyType
import com.badlogic.gdx.physics.box2d._
import com.badlogic.gdx.utils.viewport.{FitViewport, Viewport}
import gie.gdx.{ResourceContext, manageDisposableResource, manageResource}
import gie.gdx.stage.{StageControllerApiTrait, StageTrait, StageWrapper}
import gie.gdx.implicits._
import slogging.{Logger, LoggerHolder, StrictLogging}

import scala.collection.mutable


class ArcanoidStage(val currentLevel: Int, val stageController: StageControllerApiTrait)
    extends StageTrait
        with StrictLogging
        with RenderableQueueTrait
        with GameWorldWorldTrait
        with ContactResolverTrait
        with GameWorldWallsTrait
        with LooserTrait
        with BatTrait
        with LevelBuilderTrait
        with BackgroundTrait
        /*trait order does matter*/
{ asThis =>

    protected val camera = new OrthographicCamera()
    val viewport = new FitViewport(w,h, camera)

    protected val batch = manageDisposableResource(new SpriteBatch())

    val brickTex = manageDisposableResource (new Texture(Gdx.files.internal("data/bricks/brick_pink_small.png")))
    val brickTexBroken = manageDisposableResource (new Texture(Gdx.files.internal("data/bricks/brick_pink_small.png")))

    val brickGreenTex = manageDisposableResource (new Texture(Gdx.files.internal("data/bricks/brick_green_small.png")))
    val brickGreenTexBroken = manageDisposableResource (new Texture(Gdx.files.internal("data/bricks/brick_green_small_cracked.png")))

    val sndKick01 = manageDisposableResource (Gdx.audio.newSound(Gdx.files.internal("sound/kick2.ogg")))
    val sndKick02 = manageDisposableResource (Gdx.audio.newSound(Gdx.files.internal("sound/kick2.ogg")))

    private lazy val boxDebugRenderer = manageDisposableResource( new Box2DDebugRenderer() )

    //(for(i<-(-9 to 9 by 2)) yield new GameObjectBrick(brickTex(), i, h/2 -1)).foreach(addRenderable _)

    protected var aliveBricks = 0
    loadLevel(f"${currentLevel}%02d.txt").foreach{ brick=>
        addRenderable(brick)
        aliveBricks +=1
    }

    protected val ball = new GameObjectBall(manageDisposableResource (new Texture(Gdx.files.internal("data/ball_orange.png"))), 0,0)

    addRenderable(ball)


    def update(delta: Float): Unit = {

        if(aliveBricks==0){
            stageController.enqueue_replaceStage{ stageController =>
                new ArcanoidStage(currentLevel+1, stageController)
            }
        }

        implicitly[World].step(delta, 8, 3)
        bat.updateWorld() //TODO: generalize
        applyAfterWorldCmdQueue()
    }

    def onSurfaceChanged(width: Int, height: Int): Unit ={
        viewport.update(width, height)
    }

    def onPause(): Unit ={
        Gdx.input.setInputProcessor(null)
    }

    def onSaveState(): Unit ={}

//    var debug_timer = 0f

    def render(delta: Float): Unit ={

//        debug_timer += delta
//
//        if( debug_timer>30f){
//            stageController.enqueue_replaceStage( new ArcanoidStage(_) )
//        }


        val lb = batch()

        Gdx.gl.glClearColor(1, 1, 1, 1)
        Gdx.gl.glClear(GL20.GL_COLOR_BUFFER_BIT)

        lb.setProjectionMatrix(camera.combined)
        lb.begin()
        renderBackground(lb)
        renderRenderable(lb)
        lb.end()
    }


    def renderDebugInfo(): Unit ={
        Gdx.gl.glLineWidth(5)
        boxDebugRenderer().render( world(), camera.combined)
    }

    def onResume(): Unit ={
        Gdx.input.setInputProcessor(inputProcessor)
    }

    def onDestroy(): Unit ={
        implicitly[World].setContactListener(null)  // for preventing native object ('world') holding this and stopping GC
    }

    def onCreate(): Unit ={}


}
