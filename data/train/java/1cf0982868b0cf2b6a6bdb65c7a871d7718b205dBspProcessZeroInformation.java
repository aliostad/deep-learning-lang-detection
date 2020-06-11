package dataTypes;

/**
 *	Generated from IDL definition of struct "BspProcessZeroInformation"
 *	@author JacORB IDL compiler 
 */

public final class BspProcessZeroInformation
	implements org.omg.CORBA.portable.IDLEntity
{
	public BspProcessZeroInformation(){}
	public boolean isProcessZero;
	public java.lang.String processZeroIor = "";
	public BspProcessZeroInformation(boolean isProcessZero, java.lang.String processZeroIor)
	{
		this.isProcessZero = isProcessZero;
		this.processZeroIor = processZeroIor;
	}
}
