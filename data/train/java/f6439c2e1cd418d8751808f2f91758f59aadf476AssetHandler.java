package getmore.com.getmore.util.assetHandler;

import android.support.v4.app.FragmentActivity;

/**
 * Created by zhongqinng on 1/1/15.
 */
public class AssetHandler {
    private String TAG = "AssetHandler";
    public FrameLayoutHandler frameLayoutHandler;
    public ImageButtonHandler imageButtonHandler;
    public LinearLayoutHandler linearLayoutHandler;
    public TextViewHandler textViewHandler;
    public EditTextHandler editTextHandler;
    public KeyBoardHandler keyBoardHandler;
    public ImageViewHandler imageViewHandler;
    public ButtonHandler buttonHandler;
    public SmartImageViewHandler smartImageViewHandler;

    public AssetHandler(FragmentActivity fragmentActivity){
        frameLayoutHandler =new FrameLayoutHandler();
        imageButtonHandler =new ImageButtonHandler();
        linearLayoutHandler =new LinearLayoutHandler();
        textViewHandler =new TextViewHandler();
        editTextHandler=new EditTextHandler();
        keyBoardHandler=new KeyBoardHandler(fragmentActivity);
        imageViewHandler=new ImageViewHandler();
        buttonHandler=new ButtonHandler();
        smartImageViewHandler=new SmartImageViewHandler();
    }
}
