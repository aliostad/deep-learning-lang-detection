package XMars.Applications.RTB;
import java.io.IOException;

import XMars.Learning.Common.*;
import XMars.Applications.RTB.FeatureHandler.AdSlotFormatHandler;
import XMars.Applications.RTB.FeatureHandler.AdSlotIDHandler;
import XMars.Applications.RTB.FeatureHandler.AdSlotVisibilityHandler;
import XMars.Applications.RTB.FeatureHandler.CookieHandler;
import XMars.Applications.RTB.FeatureHandler.CreativeIdHandler;
import XMars.Applications.RTB.FeatureHandler.DomainFeatureHandler;
import XMars.Applications.RTB.FeatureHandler.ExchangeHandler;
import XMars.Applications.RTB.FeatureHandler.RegionHandler;
import XMars.Applications.RTB.FeatureHandler.UserAgentHandler;
import XMars.FeatureExtractor.Framework.*;

public class RTBFeatureExtractor 
{
	private Extractor _extractor= new Extractor();
	
	public RTBFeatureExtractor(String dataDir) throws IOException
	{
		DomainFeatureHandler domainHandler = new DomainFeatureHandler(dataDir,1);
		AdSlotIDHandler adSlotIDHandler = new AdSlotIDHandler(dataDir, 2);
		AdSlotFormatHandler adSlotFormatHandler = new AdSlotFormatHandler(3);
		AdSlotVisibilityHandler adSlotVisibilityHandler = new AdSlotVisibilityHandler(4);
//		CookieHandler cookieHandler = new CookieHandler(dataDir, 5);
		CreativeIdHandler creativeIdHandler = new CreativeIdHandler(dataDir, 6);
		ExchangeHandler exchangeHandler = new ExchangeHandler(7);
		RegionHandler regionHandler = new RegionHandler(8);
		UserAgentHandler userAgentHandler = new UserAgentHandler(9);
		
		_extractor.AddFeatureHandler(domainHandler);
		_extractor.AddFeatureHandler(adSlotIDHandler);
		_extractor.AddFeatureHandler(adSlotFormatHandler);
		_extractor.AddFeatureHandler(adSlotVisibilityHandler);
//		cookie因素是后验，会导致过拟合
//		_extractor.AddFeatureHandler(cookieHandler);
		_extractor.AddFeatureHandler(creativeIdHandler);
		_extractor.AddFeatureHandler(exchangeHandler);
		_extractor.AddFeatureHandler(regionHandler);
		_extractor.AddFeatureHandler(userAgentHandler);
		
	}
	public DataItem ExtractFeature(RTBInstance rtbInst)
	{
		return _extractor.ExtractFeatures(rtbInst);
	}
}
