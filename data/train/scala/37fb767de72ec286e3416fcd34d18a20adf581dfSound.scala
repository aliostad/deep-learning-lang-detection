package com.mojang.metagun

import com.badlogic.gdx.Gdx

object Sound {
  lazy val boom = load("res/boom.wav")
  lazy val hit = load("res/hit.wav")
  lazy val splat = load("res/splat.wav")
  lazy val launch = load("res/launch.wav")
  lazy val pew = load("res/pew.wav")
  lazy val oof = load("res/oof.wav")
  lazy val gethat = load("res/gethat.wav")
  lazy val death = load("res/death.wav")
  lazy val startgame = load("res/startgame.wav")
  lazy val jump = load("res/jump.wav")

  def load() {
    boom; hit; splat; launch; pew; oof; gethat; death; startgame; jump;
  }
    
  private def load(name : String) : com.badlogic.gdx.audio.Sound = {
    Gdx.audio.newSound(Gdx.files.internal(name))
  }
}
