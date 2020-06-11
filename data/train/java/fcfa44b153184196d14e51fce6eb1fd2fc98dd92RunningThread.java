package cn.edu.hit.voidmain.asmsreplier.pd_factory.threads;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

public abstract class RunningThread extends Thread {
	protected Handler handler;
	
	public void setHandler(Handler handler)
	{
		this.handler = handler;
	}
	
	public Handler getHandler()
	{
		return this.handler;
	}
	
	public abstract void doWork();

	@Override
	public void run() {
		super.run();
		
		doWork();
		
		Message m = handler.obtainMessage();
		Bundle b = new Bundle();
		b.putBoolean("result", true);
		m.setData(b);
		handler.sendMessage(m);
	}

}
