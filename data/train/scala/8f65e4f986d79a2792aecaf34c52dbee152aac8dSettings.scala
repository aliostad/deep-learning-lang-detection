package com.tyoverby.canvas.components

import com.tyoverby.canvas.Setting._
import java.awt.image.BufferedImage


trait Settings {
    var imageBuffer: BufferedImage
    def setNewImage(newImage: BufferedImage)

    private[this] var _width = 255
    def width = _width
    def width_= (w: Int) {
        _width = w
        val oldImage = imageBuffer
        val newImage = new BufferedImage(w, oldImage.getHeight, BufferedImage.TYPE_INT_RGB)
        setNewImage(newImage)
    }


    private[this] var _height = 255
    def height = _height
    def height_= (h: Int){
        _height = h
        val oldImage = imageBuffer
        val newImage = new BufferedImage(oldImage.getWidth, h, BufferedImage.TYPE_INT_RGB)
        setNewImage(newImage)

    }

}
