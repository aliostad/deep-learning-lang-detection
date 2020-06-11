/**
 * 项目名: java-code-tutorials-design-pattern-chain-of-responsibility
 * 包名:  net.fantesy84.handler
 * 文件名: AbstractHandler.java
 * Copy Right © 2015 Andronicus Ge
 * 时间: 2015年12月23日
 */
package net.fantesy84.handler;

/**
 * @author Andronicus
 * @since 2015年12月23日
 */
public abstract class AbstractHandler {
	private IHandler handler;

	/**
	 * @return the handler
	 */
	public IHandler getHandler() {
		return handler;
	}

	/**
	 * @param handler the handler to set
	 */
	public void setHandler(IHandler handler) {
		this.handler = handler;
	}
	
}
