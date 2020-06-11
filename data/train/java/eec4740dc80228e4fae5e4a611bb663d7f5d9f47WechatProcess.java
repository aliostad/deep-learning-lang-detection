package mango.condor.servlet.process;

import mango.condor.servlet.entity.ReceiveXmlEntity;


/**
 * 微信xml消息处理流程逻辑类
 *
 */
public class WechatProcess {
	public String processWechatMag(ReceiveXmlEntity xmlEntity,ProcessInter process){
		if(xmlEntity == null || process == null){
			return null;
		}
		/** 回复邀请码逻辑 */
		String result = "";
		result = process.process(xmlEntity);
		if(result != null && !result.isEmpty()){
			// 把消息做打xml包处理
			result = process.resultXml(xmlEntity, result);
		}
		return result;
	}
}
