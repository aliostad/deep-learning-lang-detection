/**
 * 
 */
package org.einnovator.convert;

/**
 * AA ConversionServiceHolder.
 *
 * @author Jorge Simão
 */
public class ConversionServiceHolder {

	private static ConversionService defaultConversionService;
	
	private static ConversionService conversionService;
	
	public static ConversionService getConversionService() {
		return conversionService;
	}
	
	public static void setConversionService(ConversionService conversionService) {
		ConversionServiceHolder.conversionService = conversionService;
	}

	public static ConversionService getRequiredConversionService() {
		if (conversionService!=null) {
			return conversionService;
		}
		if (defaultConversionService==null) {
			defaultConversionService = new DefaultConversionService();
		}
		return defaultConversionService;
	}

}
