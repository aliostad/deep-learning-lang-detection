package com.hdsx.dao.data.type;

import java.util.ArrayList;
import java.util.List;

import com.hdsx.dao.data.type.handler.BooleanHandler;
import com.hdsx.dao.data.type.handler.BytesHandler;
import com.hdsx.dao.data.type.handler.DateHandler;
import com.hdsx.dao.data.type.handler.DoubleHandler;
import com.hdsx.dao.data.type.handler.GeometryHandler;
import com.hdsx.dao.data.type.handler.IntegerHandler;
import com.hdsx.dao.data.type.handler.LongHandler;
import com.hdsx.dao.data.type.handler.StringHandler;



public class TypeHandlerRegistry {

	private List<String> typeHandlerList=new ArrayList<String>();
	
	private IChainHandler ich;
	
	private static TypeHandlerRegistry handlerRegistry;
	
	private TypeHandlerRegistry(){
		try 
		{
			registerChainHandler();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	public static TypeHandlerRegistry getInstance()
	{
		if(handlerRegistry==null)
		{
			handlerRegistry=new TypeHandlerRegistry();
		}
		return handlerRegistry;
	}
	public IChainHandler getTypeHandlerChainHandler() {
		return ich;
	}
	public void addTypeHandler(String typeHandler)
	{
		typeHandlerList.add(typeHandler);
	}
	private void registerChainHandler() throws Exception
	{
	   ich=new ChainHandler(new BooleanHandler());
	   ich=new ChainHandler(new BytesHandler(),ich);
	   ich=new ChainHandler(new DoubleHandler(),ich);
	   ich=new ChainHandler(new IntegerHandler(),ich);
	   ich=new ChainHandler(new LongHandler(),ich);
	   ich=new ChainHandler(new StringHandler(),ich);
	   ich=new ChainHandler(new DateHandler(),ich);
	   ich=new ChainHandler(new GeometryHandler(),ich);
	   for (String typeHandler: typeHandlerList) {
		  ich=new ChainHandler((ITypeHandler<?>) Class.forName(typeHandler).newInstance(),ich);
	   }	
	}
}
