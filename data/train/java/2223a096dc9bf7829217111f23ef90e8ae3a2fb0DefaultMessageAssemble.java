package com.ziker.message.handler.workshop;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.ziker.message.handler.message.IHandler;

/** 
* @Package com.ziker.message.handler.workshop 
* @ClassName: DefaultAssemble 
* @Description: 默认组装组件，组装了keyWordHandler、textFilterHandler、textMessageHandler、imageMessageHandler
* @author 李小兵 
* @date 2015年9月29日 下午2:14:32 
*  
*/
@Component
public class DefaultMessageAssemble extends AbstractMessageAssemble {
	@Autowired
	IHandler textMessageHandler;
	@Autowired
	IHandler imageMessageHandler; 
	@Autowired
	IHandler keyWordHandler;
	@Autowired
	IHandler textFilterHandler; 
	@Override
	public void assembleMessageHandler() {
		addHandler(keyWordHandler);
		addHandler(textFilterHandler);
		addHandler(textMessageHandler);
		addHandler(imageMessageHandler);
	}
}
