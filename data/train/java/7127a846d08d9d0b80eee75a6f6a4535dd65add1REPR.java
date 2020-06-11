package com.thrblock.util;

public class REPR 
{
	public static float Rep_POW0_5(float process)
	{
		if(process>1||process<0)
		{
			return 0;
		}
		return (float)Math.pow(process,0.5);
	}
	public static float Rep_POW2_0(float process)
	{
		if(process>1||process<0)
		{
			return 0;
		}
		return (float)Math.pow(process, 2);
	}
	public static float Rep_POW_F(float process,float F)
	{
		if(process>1||process<0)
		{
			return 0;
		}
		return (float)Math.pow(process,F);
	}
	public static float Rep_POW_1_F(float process,float F)
	{
		if(process>1||process<0)
		{
			return 0;
		}
		return (float)Math.pow(process,1/F);
	}
}
