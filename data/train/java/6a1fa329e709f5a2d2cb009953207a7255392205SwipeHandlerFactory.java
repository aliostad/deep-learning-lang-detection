package com.kaedea.widget.swipeloadingview;

import com.kaedea.widget.swipeloadingview.core.ISwipeDetector;
import com.kaedea.widget.swipeloadingview.core.ISwipeHandler;
import com.kaedea.widget.swipeloadingview.core.ITouEventHandler;

/**
 * Created by kaede on 2016/3/24.
 */
public class SwipeHandlerFactory {

	public static final String TAG = "SwipeHandlerFactory";

	public static ISwipeHandler createDefaultSwipeHandler(ISwipeDetector iSwipeDetector){
		ISwipeHandler iSwipeHandler = new DefaultSwipeHandler();
		ITouEventHandler iTouEventHandler = new DefaultTouchEventHandler();
		iTouEventHandler.attach(iSwipeHandler);
		iSwipeHandler.attach(iSwipeDetector);
		iSwipeDetector.attach(iTouEventHandler,iSwipeHandler);
		return iSwipeHandler;
	}
}
