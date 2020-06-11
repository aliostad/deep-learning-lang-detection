package com.ui.rollingscene

import java.awt.image.BufferedImage

object ChopperImages {
    val imageCache = new ImageCache

    def imageList:Seq[BufferedImage] = Seq(
                                  imageCache.loadOrThrow("/cobra_0.jpg"),
                                  imageCache.loadOrThrow("/cobra_1.jpg"),
                                  imageCache.loadOrThrow("/cobra_2.jpg"),
                                  imageCache.loadOrThrow("/cobra_3.jpg"))

    def possibleImageList:Seq[Option[BufferedImage]] =
        Seq(imageCache.load("/cobra_0.jpg"), imageCache.load("/cobra_1.jpg"),
            imageCache.load("/cobra_2.jpg"), imageCache.load("/cobra_3.jpg"))
}
