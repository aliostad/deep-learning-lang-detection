package com.hdsx.dao.data.type;


public class ChainHandler implements IChainHandler{
	private ITypeHandler<?> typeHandler;
	private IChainHandler handler;
	@Override
	public Object handle(JavaType javaType,Object source) throws SecurityException, NoSuchMethodException,Exception
	{
		Object value = null;
		if(typeHandler.getReturnType().equals(javaType.getJavaType()))
		{
			 return value=typeHandler.convert(source);
		}
		else
		{
			if(handler!=null)
			{
			  return handler.handle(javaType, source);
			}
		}
		return value;		
	  
	}
	public ChainHandler(ITypeHandler<?> typeHandler) {
		super();
		this.typeHandler = typeHandler;
	}
	public ChainHandler(ITypeHandler<?> typeHandler, IChainHandler ich) {
		super();
		this.typeHandler = typeHandler;
		this.handler = ich;
	}
}
