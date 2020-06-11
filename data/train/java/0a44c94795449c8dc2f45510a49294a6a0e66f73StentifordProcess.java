package visnode.pdi.process;

import org.paim.commons.Image;
import org.paim.commons.ImageFactory;
import visnode.commons.Input;
import visnode.commons.Output;
import visnode.pdi.Process;

/**
 * Stentiford process
 */
public class StentifordProcess implements Process {

    /** Stentiford process */
    private final org.paim.pdi.StentifordProcess process;
    
    /**
     * Creates a new Stentiford process
     * 
     * @param image 
     */
    public StentifordProcess(@Input("image") Image image) {
        Image resultImage = image;
        if (image == null) {
            resultImage = ImageFactory.buildEmptyImage();
        }
        this.process = new org.paim.pdi.StentifordProcess(new Image(resultImage));
        
    }

    @Override
    public void process() {
        process.process();
    }
    
    /**
     * Returns the output image
     *
     * @return Image
     */
    @Output("image")
    public Image getImage() {
        return process.getOutput();
    }

}