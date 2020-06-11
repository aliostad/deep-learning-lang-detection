package gie.aarca

import com.badlogic.gdx.{Gdx, Input, InputProcessor}
import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.math.{Vector2, Vector3}
import gie.gdx.{ResourceContext, manageDisposableResource, manageResource}

trait BatTrait { this: ArcanoidStage=>

    protected val bat = new GameObjectBat(manageDisposableResource (new Texture(Gdx.files.internal("data/bat_yellow.png"))), 0, -h/2+1)

    addRenderable(bat)

    private val leftVelocity = new Vector2(-10,0)
    private val rightVelocity = new Vector2(10,0)


    protected val inputProcessor = new InputProcessor {

        var touchX:Float = 0
        var posOnTouchX:Float = 0

        def keyTyped(character: Char): Boolean = false

        def mouseMoved(screenX: Int, screenY: Int): Boolean = false

        def keyDown(keycode: Int): Boolean = false

        def touchDown(screenX: Int, screenY: Int, pointer: Int, button: Int): Boolean ={
            touchX = unprojectX(screenX)
            posOnTouchX = bat.x
            true
        }

        def keyUp(keycode: Int): Boolean = false

        def scrolled(amount: Int): Boolean = false

        def touchUp(screenX: Int, screenY: Int, pointer: Int, button: Int): Boolean ={
            touchX = 0
            true
        }

        def touchDragged(screenX: Int, screenY: Int, pointer: Int): Boolean ={

            val delta = touchX - unprojectX(screenX)

            bat.body.setTransform(posOnTouchX - delta, bat.y, 0)

            true
        }

        private def unprojectX(x:Float) = camera.unproject( new Vector3(x, 0, 0), viewport.getScreenX, viewport.getScreenY, viewport.getScreenWidth, viewport.getScreenHeight).x
    }


}