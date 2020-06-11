package mr.merc.image

import scalafx.scene.image.Image
import scalafx.scene.paint.Color
import scalafx.scene.image.WritableImage
import java.nio.ByteBuffer

object SoldierColorTransformer {
    private case class RGB(red:Int, green:Int, blue:Int) {
      
      def this(color:Color) {
        this(color.red * 255 toInt, color.green * 255 toInt, color.blue * 255 toInt) 
      }
      
      private def normalizeUp(x:Int) = if (x > 255) 255 else x
      def normalize = RGB(normalizeUp(red), normalizeUp(green), normalizeUp(blue))
      def toArbg:Int = {
        val bytes = Array[Byte](255.toByte, red.toByte, green.toByte, blue.toByte)
        ByteBuffer.wrap(bytes).getInt();
      }
      def toColor = Color.rgb(red, green, blue)
    }
    private implicit def tuple2rgb(x:(Int, Int, Int)) = RGB(x._1, x._2, x._3)
  
    private val originalRGB = List[RGB](
        (244,154,193),
          (63,0,22),
          (85,0,42),
          (105,0,57),
          (123,0,69),
          (140,0,81),
          (158,0,93),
          (177,0,105),
          (195,0,116),
          (214,0,127),
          (236,0,140),
          (238,61,150),
          (239,91,161),
          (241,114,172),
          (242,135,182),
          (246,173,205),
          (248,193,217),
          (250,213,229),
          (253,233,241))
  
          
    private def buildColorPairs(desiredColor:Color):List[(RGB, RGB)] = {
      val mid = new RGB(desiredColor)
      val min = RGB(0, 0, 0)
      val max = RGB(255, 255, 255)      
      
      val baseAvg = (originalRGB(0).red + originalRGB(0).green + originalRGB(0).blue) / 3    
    
      originalRGB map {
        case RGB(red, green, blue) => {
          val oldAvg = (red + green + blue) / 3
          
          val rgb = if (oldAvg <= baseAvg) {
            val old_rat = oldAvg / baseAvg.toDouble
            RGB(
            (old_rat * mid.red + (1 - old_rat) * min.red).toInt,
            (old_rat * mid.green + (1 - old_rat) * min.green).toInt,
            (old_rat * mid.blue + (1 - old_rat) * min.blue).toInt)
          } else {
            val old_rat = (255 - oldAvg) / (255 - baseAvg).toDouble
            RGB((old_rat * mid.red + (1 - old_rat) * max.red).toInt,
            (old_rat * mid.green + (1 - old_rat) * max.green).toInt,
            (old_rat * mid.blue + (1 - old_rat) * max.blue).toInt)
          }
          (RGB(red, green, blue), rgb.normalize)      
        }
      }
    }
    
	def transformImage(input:Image, desiredColor:Color):Image = {
	  val anotherPairs = buildColorPairs(desiredColor)
	  val pairs = buildColorPairs(desiredColor).map{case (k, v) => (k.toArbg, v.toColor)}.toMap
	  val width = input.width.value.toInt
	  val height = input.height.value.toInt
	  
	  val newImage = new WritableImage(width, height)
	  val writer = newImage.pixelWrit
	  val reader = input.pixelReader.get
	  
	  for (x <- 0 until width; y <- 0 until height) {
	    val colorInt = reader.getArgb(x, y)
	    pairs.get(colorInt) match {
	      case Some(color) => writer.setColor(x, y, color)
	      case None => writer.setArgb(x, y, colorInt)
	    }	    
	  }
	  
	  newImage
	}
}