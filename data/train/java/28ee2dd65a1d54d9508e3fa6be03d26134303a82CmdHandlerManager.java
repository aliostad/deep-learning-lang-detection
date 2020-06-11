package cn.liuyb.app.sync.handler;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;

import cn.liuyb.app.common.utils.Slf4jLogUtils;

@Component
public class CmdHandlerManager {
	private static Logger logger = Slf4jLogUtils
			.getLogger(CmdHandlerManager.class);
	private Map<String, CmdHandler> cmdHandlers = new ConcurrentHashMap<String, CmdHandler>();

	public CmdHandler getCmdHandler(String cmd) {
		return cmdHandlers.get(cmd);
	}

	private void registerCmdHandler(CmdHandler handler) {
		logger.debug("register CmdHandler {} = {}", handler.getCmd(), handler);
		cmdHandlers.put(handler.getCmd(), handler);
	}

	@Autowired
	@Qualifier("userLoginHandler")
	public void setUserLoginHandler(CmdHandler handler) {
		registerCmdHandler(handler);
	}
	
	@Autowired
	@Qualifier("appUploadHandler")
	public void setAppUploadHandler(CmdHandler handler) {
		registerCmdHandler(handler);
	}
	
	@Autowired
	@Qualifier("queryFolderHandler")
	public void setQueryFolderHandler(CmdHandler handler) {
		registerCmdHandler(handler);
	}
	@Autowired
	@Qualifier("checkFileHandler")
	public void setCheckFileHandler(CmdHandler handler) {
		registerCmdHandler(handler);
	}
	@Autowired
	@Qualifier("fileUploadHandler")
	public void setFileUploadHandler(CmdHandler handler) {
		registerCmdHandler(handler);
	}
}
