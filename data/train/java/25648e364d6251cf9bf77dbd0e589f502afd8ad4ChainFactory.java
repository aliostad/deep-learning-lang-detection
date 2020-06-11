/**
 * 
 */
package code;

import java.util.ArrayList;

/**
 * @author oded
 *
 */
public class ChainFactory {

	private ArrayList<Handler> handlers = new ArrayList<Handler>();



	public void registerHandler(Handler handler){
		handlers.add(handler);
	}
	
	public void removeHandler(Handler handler) {
		handlers.remove(handler);
	}	

	public Handler getChain() {
		Handler obP = null;
		for (Handler ob : handlers) {
			if(obP != null){
				obP.setHandler(ob);
			}
			obP = ob;
		}	
		return handlers.get(0);
	}

}
