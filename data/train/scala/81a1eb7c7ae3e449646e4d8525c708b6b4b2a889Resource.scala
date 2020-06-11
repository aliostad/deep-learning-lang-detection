package io.github.suitougreentea.VariousMinos

import org.newdawn.slick.Image
import io.github.suitougreentea.util.AngelCodeFontXML

object Resource {
  var frame,
  design,
  block,
  bomb,
  hr: Image = _
  
  var jpfont,
  boldfont: AngelCodeFontXML = _

  def load(){
    frame = loadImage("image/frame.png")
    design = loadImage("image/design.png")
    block = loadImage("image/block.png")
    bomb = loadImage("image/bomb.png")
    hr = loadImage("image/hr.png")
    
    //jpfont = new AngelCodeFontXML("res/font/jpfont16.fnt")
    boldfont = new AngelCodeFontXML("res/font/16bold.fnt")
  }
  
  def loadImage(path: String): Image = {
    new Image("res/" + path) 
  }

}