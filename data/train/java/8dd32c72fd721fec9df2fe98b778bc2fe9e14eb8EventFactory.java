package com.zj.easyandroid.core.factories;

import android.app.Activity;

import com.zj.easyandroid.core.Enum.Event;
import com.zj.easyandroid.core.EventHandler.ClickHandler;
import com.zj.easyandroid.core.EventHandler.FocusChangeHandler;
import com.zj.easyandroid.core.EventHandler.IEventHandler;
import com.zj.easyandroid.core.EventHandler.LongClickHandler;
import com.zj.easyandroid.core.EventHandler.TextChangeHandler;
import com.zj.easyandroid.core.EventHandler.TouchHandler;

/**
 * 生产事件处理类工厂
 * @author 周健
 *
 */
public class EventFactory implements IEventFactory {

	@Override
	public IEventHandler getEventHandler(Event event, Activity activity) {
		IEventHandler handler = null;
		switch (event) {
		case CLICK:
			handler = new ClickHandler(activity);
			break;
		case LONGCLICK:
			handler = new LongClickHandler(activity);
			break;
		case TOUCH:
			handler = new TouchHandler(activity);
			break;
		case FOCUSCHANG:
			handler = new FocusChangeHandler(activity);
			break;
		case TEXTCHANGE:
			handler = new TextChangeHandler(activity);
			break;
		default:
			break;
		}
		return handler;
	}

}
