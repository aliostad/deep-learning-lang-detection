package org.seasar.framework.container.factory;

import org.seasar.framework.xml.TagHandlerRule;

/**
 * @author higa
 *
 */
public class S2ContainerTagHandlerRule extends TagHandlerRule {

	public S2ContainerTagHandlerRule() {
		addTagHandler("/components", new ComponentsTagHandler());
		addTagHandler("component", new ComponentTagHandler());
		addTagHandler("arg", new ArgTagHandler());
		addTagHandler("property", new PropertyTagHandler());
		addTagHandler("meta", new MetaTagHandler());
		addTagHandler("initMethod", new InitMethodTagHandler());
		addTagHandler("destroyMethod", new DestroyMethodTagHandler());
		addTagHandler("aspect", new AspectTagHandler());
		addTagHandler("/components/include", new IncludeTagHandler());
	}
}
