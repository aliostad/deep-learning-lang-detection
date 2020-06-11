package cn.xharvard.scrum2.responsibility;

/**
 * 抽象处理者角色
 */
public abstract class Handler {

	// 持有后继的责任对象
	protected Handler handler;

	/**
     * 示意处理请求的方法，虽然这个示意方法是没有传入参数的
     * 但实际是可以传入参数的，根据具体需要来选择是否传递参数
     */
	public abstract void handlerRequest();

	public Handler getHandler() {
		return handler;
	}

	// 设置后继的责任对象
	public void setHandler(Handler handler) {
		this.handler = handler;
	}
}
