package necromunda;

import java.io.Serializable;

public abstract class ShotHandler implements Serializable {
	transient private Necromunda3dProvider provider;
	private ShotHandler nextHandler;
	
	public ShotHandler(ShotHandler nextHandler) {
		this.nextHandler = nextHandler;
	}
	
	public void handle(ShotInfo shotInfo) {
		if (nextHandler != null) {
			nextHandler.handle(shotInfo);
		}
	}
	
	public abstract void reset();

	public ShotHandler getNextHandler() {
		return nextHandler;
	}

	public void setNextHandler(ShotHandler nextHandler) {
		this.nextHandler = nextHandler;
	}

	public Necromunda3dProvider getProvider() {
		return provider;
	}

	public void setProvider(Necromunda3dProvider provider) {
		this.provider = provider;
		
		if (nextHandler != null) {
			nextHandler.setProvider(provider);
		}
	}
}
