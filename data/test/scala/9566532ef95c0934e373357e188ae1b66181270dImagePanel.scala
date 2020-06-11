package gui

import com.sksamuel.scrimage.Image
import java.awt.event.{MouseAdapter, MouseEvent}
import java.awt.image.BufferedImage
import java.awt.{Graphics, Dimension, Color}
import java.io.{FileWriter, IOException, File}
import javax.imageio.ImageIO
import javax.swing.{JLabel, BorderFactory, JPanel, JScrollPane}
/**
 * Created by guillaume on 21/05/14.
 */
class ImagePanel(val selectionDone: () => Unit) extends JPanel{

    def this() = this( () => () )

    setBorder(BorderFactory.createLineBorder(Color.BLACK))
    setBackground(Color.PINK)
    setMinimumSize(new Dimension(250, 250))

    private var imageLoaded = false
    private var image : BufferedImage = null

    private var squareX = 0
    private var squareY = 0
    private var squareW = 0
    private var squareH = 0

    private val (textPosX, textPosY) = (10, 20)

    addMouseListener(new MouseAdapter() {
        override def mousePressed(e : MouseEvent) = updateFixedCorner(e.getX, e.getY)
        override def mouseReleased(e : MouseEvent) = {
            updateMovingCorner(e.getX, e.getY)
            selectionDone()
        }
    })

    addMouseMotionListener(new MouseAdapter() {
        override def mouseDragged(e : MouseEvent) = updateMovingCorner(e.getX, e.getY)
    })

    private def updateMovingCorner(x : Int, y : Int) {
        val (oldW, oldH) = (squareW, squareH)
        squareW = x - squareX
        squareH = y - squareY
        repaint(squareX, squareY, oldW+2, oldH+2)
        repaint(squareX, squareY, squareW, squareH)
    }

    private def updateFixedCorner(x : Int, y : Int) {
        val (oldX, oldY, oldW, oldH) = (squareX, squareY, squareW, squareH)
        (squareX = x, squareY = y, squareW = 1, squareH = 1)
        repaint(oldX, oldY, oldW+2, oldH+2)
        repaint(squareX, squareY, squareW, squareH)
    }

    override def paintComponent(g : Graphics) {
        super.paintComponent(g)
        if(imageLoaded) g.drawImage(image, 0, 0, null)
        g.setColor(Color.RED)
        g.drawRect(squareX, squareY, squareW, squareH)
    }

    def load(imageFile : File){
        try {
            image = ImageIO.read(imageFile)
            imageLoaded = true
            this.setSize(new Dimension(image.getWidth, image.getHeight))
            this.repaint()
        } catch {
            case e : IOException => println(s"Loading ${imageFile.getName} failed")
        }
    }

    def load(img: Image){
        image = img.awt
        imageLoaded = true
        this.setSize(new Dimension(image.getWidth, image.getHeight))
        this.repaint()
    }

    def getSelectedImage : BufferedImage = image.getSubimage(
        Math.min(squareX, image.getWidth),
        Math.min(squareY, image.getWidth),
        Math.min(squareW, image.getWidth - squareX),
        Math.min(squareH, image.getHeight - squareY)
    )

    def saveSelected(filename : String, description : String) = {
        try {
            if (imageLoaded) {
                if (squareW > 0 && squareH > 0) {
                    ImageIO.write(getSelectedImage, "png", new File(filename + ".png"))
                    val descriptionOutput = new FileWriter(filename + ".txt")
                    descriptionOutput.write(description)
                    descriptionOutput.close()
                    true
                } else {
                    false
                }
            } else {
                false
            }
        } catch {
            case e : IOException =>  false
        }
    }

}
