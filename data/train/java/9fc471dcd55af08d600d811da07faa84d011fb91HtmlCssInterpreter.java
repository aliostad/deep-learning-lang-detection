package de.enough.skylight.renderer.css;

import java.io.Reader;

import de.enough.polish.browser.css.CssInterpreter;
import de.enough.polish.ui.Style;
import de.enough.polish.util.ArrayList;
import de.enough.skylight.renderer.css.handler.ClearHandler;
import de.enough.skylight.renderer.css.handler.CssAttributeHandler;
import de.enough.skylight.renderer.css.handler.DisplayHandler;
import de.enough.skylight.renderer.css.handler.FloatHandler;
import de.enough.skylight.renderer.css.handler.HeightHandler;
import de.enough.skylight.renderer.css.handler.MarginHandler;
import de.enough.skylight.renderer.css.handler.MarginLeftHandler;
import de.enough.skylight.renderer.css.handler.MarginRightHandler;
import de.enough.skylight.renderer.css.handler.MaxHeightHandler;
import de.enough.skylight.renderer.css.handler.MaxWidthHandler;
import de.enough.skylight.renderer.css.handler.MinHeightHandler;
import de.enough.skylight.renderer.css.handler.MinWidthHandler;
import de.enough.skylight.renderer.css.handler.PaddingHandler;
import de.enough.skylight.renderer.css.handler.PaddingLeftHandler;
import de.enough.skylight.renderer.css.handler.PaddingRightHandler;
import de.enough.skylight.renderer.css.handler.PositionHandler;
import de.enough.skylight.renderer.css.handler.TextAlignHandler;
import de.enough.skylight.renderer.css.handler.VerticalAlignHandler;
import de.enough.skylight.renderer.css.handler.VisibleHandler;
import de.enough.skylight.renderer.css.handler.WidthHandler;

public class HtmlCssInterpreter extends CssInterpreter{

	ArrayList attributeHandler;
	
	public HtmlCssInterpreter(Reader reader) {
		super(reader);

		this.attributeHandler = new ArrayList();
		
		load();
	}
	
	void load() {
		addAttributeHandler(new DisplayHandler());
		addAttributeHandler(new FloatHandler());
                addAttributeHandler(new ClearHandler());
		addAttributeHandler(new PositionHandler());
		
		addAttributeHandler(new MinHeightHandler());
		addAttributeHandler(new MaxHeightHandler());
		addAttributeHandler(new MinWidthHandler());
		addAttributeHandler(new MaxWidthHandler());
		addAttributeHandler(new WidthHandler());
		addAttributeHandler(new HeightHandler());
		
		addAttributeHandler(new VisibleHandler());
		
		addAttributeHandler(new VerticalAlignHandler());
		addAttributeHandler(new TextAlignHandler());
		
		addAttributeHandler(new MarginHandler());
		addAttributeHandler(new MarginLeftHandler());
		addAttributeHandler(new MarginRightHandler());
		addAttributeHandler(new PaddingHandler());
		addAttributeHandler(new PaddingLeftHandler());
		addAttributeHandler(new PaddingRightHandler());
	}
	
	void addAttributeHandler(CssAttributeHandler handler) {
		this.attributeHandler.add(handler);
	}
	
	CssAttributeHandler getAttributeHandler(String name) {
		int hashCode = name.hashCode();
		for (int i = 0; i < this.attributeHandler.size(); i++) {
			CssAttributeHandler handler = (CssAttributeHandler)this.attributeHandler.get(i);
			if(hashCode == handler.getHash()) {
				return handler;
			}
		}
		
		return null;
	}
	
	protected void addAttribute(String name, String value, Style style) {
		super.addAttribute(name, value, style);
	
		CssAttributeHandler handler = getAttributeHandler(name);
		
		if(handler != null) {
			handler.addToStyle(style, value);
		} else {
			//#debug warn
			System.out.println("unable to find css handler for " + name);
		}
	}	
}
