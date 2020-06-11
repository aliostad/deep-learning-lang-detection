package gie.aarca

import com.badlogic.gdx.Gdx
import com.badlogic.gdx.graphics.Texture
import com.badlogic.gdx.graphics.g2d.{Sprite, SpriteBatch}
import gie.gdx.{ResourceContext, manageDisposableResource, manageResource}
import gie.gdx.implicits._


trait BackgroundTrait { this: ArcanoidStage=>

    private val backgroud = buildBackgroundSprite()

    private def buildBackgroundSprite() ={

        val backgroundTex = manageDisposableResource (new Texture(Gdx.files.internal("data/background.jpg")))

        val backW = w
        val backH = h

        val sprite = {
            val s = new Sprite(backgroundTex())
            s.setSize(w,h)
            s.setOriginCenter()
            s.setOPosition(0, 0)
            s
        }

        (sprite, backgroundTex)
    }

    protected def renderBackground(batch: SpriteBatch): Unit ={

        backgroud._1.draw(batch)

    }


}