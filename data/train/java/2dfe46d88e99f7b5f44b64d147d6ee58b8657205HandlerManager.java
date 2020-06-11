package nio.manager;

import mpcs.handler.BaseInfoHandler;
import mpcs.handler.BindMobileHandler;
import mpcs.handler.ContactInfoHandler;
import mpcs.handler.EmailHandler;
import mpcs.handler.HelpHandler;
import mpcs.handler.LoginHandler;
import mpcs.handler.MobileTipsHandler;
import mpcs.handler.ModifyPwdHandler;
import mpcs.handler.PositionListHandler;
import mpcs.handler.RegisterHandler;
import mpcs.handler.SetPositionHandler;
import mpcs.handler.SuggestionHandler;
import mpcs.utils.MoreUtils;
import nio.config.Debug;
import nio.core.Notifier;
import nio.handler.LogHandler;
import nio.handler.ServerHandler;
import nio.handler.TimeHandler;
import nio.util.LangUtil;

/**
 * <p>Title: Handler工具类</p>
 * <p>Description: 所有的Handler都要通过此类注册</p>
 * @author zhangzuoqiang
 * <br/>Date: 2011-3-6
 */
public final class HandlerManager{
	
	
	public static void AddHandlerListener(){
		
		Notifier notifier = Notifier.getNotifier();
		
		//=============== 所有Handler写在我下面，否则跪板凳 ===============
		
		LogHandler loger = new LogHandler();
		ServerHandler server = new ServerHandler();
		TimeHandler timer = new TimeHandler();
		RegisterHandler register = new RegisterHandler();
		LoginHandler login = new LoginHandler();
		BaseInfoHandler basicInfo = new BaseInfoHandler();
		ContactInfoHandler contactInfo = new ContactInfoHandler();
		ModifyPwdHandler modify = new ModifyPwdHandler();
		BindMobileHandler bindMobile = new BindMobileHandler();
		SetPositionHandler setPosition = new SetPositionHandler();
		MobileTipsHandler tips = new MobileTipsHandler();
		PositionListHandler positionList = new PositionListHandler();
		EmailHandler email = new EmailHandler();
		HelpHandler help = new HelpHandler();
		SuggestionHandler suggestion = new SuggestionHandler();
        
        notifier.addListener(loger);
        notifier.addListener(timer);
        notifier.addListener(server);
        notifier.addListener(register);
        notifier.addListener(login);
        notifier.addListener(basicInfo);
        notifier.addListener(contactInfo);
        notifier.addListener(modify);
        notifier.addListener(bindMobile);
        notifier.addListener(setPosition);
        notifier.addListener(tips);
        notifier.addListener(positionList);
        notifier.addListener(email);
        notifier.addListener(help);
        notifier.addListener(suggestion);
        
        //=============== 所有Handler写在我上面，否则跪板凳 ===============
        
        MoreUtils.trace(LangUtil.get("10001"), Debug.printSystem);
	}
}
