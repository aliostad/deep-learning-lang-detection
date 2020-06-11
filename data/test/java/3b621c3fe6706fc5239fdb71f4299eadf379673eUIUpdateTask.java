/**
 * 
 */
package wifilocator.thread;

import java.util.TimerTask;

import android.os.Handler;
/**
 * Scheduled task of UI updates
 * @author Eric Wang
 * @version 0
 */
public class UIUpdateTask extends TimerTask {

    private Handler handler;
    
    public UIUpdateTask(Handler handler)
    {
    	this.setHandler(handler);
    }
	@Override
	public void run() {
		// TODO Auto-generated method stub
		handler.obtainMessage(1).sendToTarget();
	}
	/**
	 * @return the m_handler
	 */
	public Handler getHandler() {
		return handler;
	}
	/**
	 * @param m_handler the m_handler to set
	 */
	public void setHandler(Handler handler) {
		this.handler = handler;
	}

}
