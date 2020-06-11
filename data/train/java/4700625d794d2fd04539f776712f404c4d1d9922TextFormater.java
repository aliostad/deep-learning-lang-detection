package com.xiaoleilu.texmatter.service;

import com.xiaoleilu.texmatter.handler.BlankHandler;
import com.xiaoleilu.texmatter.handler.DbcHandler;
import com.xiaoleilu.texmatter.handler.Handler;
import com.xiaoleilu.texmatter.handler.HtmlHandler;
import com.xiaoleilu.texmatter.handler.MappingHandler;
import com.xiaoleilu.texmatter.handler.ParagraphHandler;
import com.xiaoleilu.texmatter.handler.SpecialHandler;

/**
 * 文本格式化业务类
 */
public class TextFormater {
	
	Handler[] handlers = {
			new DbcHandler(),	
			new MappingHandler(),
			new HtmlHandler(),
			new BlankHandler(),
			new ParagraphHandler(),
			new SpecialHandler()
	};

	/**
	 * 格式化
	 * @param text 文本
	 * @return 格式化后的文本
	 */
	public String format(String text) {
		for (Handler handler : handlers) {
			text = handler.handle(text);
		}
		return text;
	}
}
