package com.belfrygames.plat

import com.badlogic.gdx.Gdx

object Sound {
  lazy val birth = load("res/birth.ogg")
  lazy val jump = load("res/jump.ogg")
  lazy val portal = load("res/portal.ogg")
  lazy val shot = load("res/shot.ogg")
  lazy val menu = loadMusic("res/menu.ogg")
  lazy val soundtrack = loadMusic("res/soundtrack.ogg")

  def load() {
    birth; portal; shot; menu; soundtrack; jump
  }
    
  private def load(name : String) = {
    Gdx.audio.newSound(Gdx.files.internal(name))
  }
  private def loadMusic(name : String) = {
    Gdx.audio.newMusic(Gdx.files.internal(name))
  }
}
