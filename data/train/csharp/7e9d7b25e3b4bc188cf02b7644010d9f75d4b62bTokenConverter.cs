//using Thermo.Ironclad.Model.Core;
//using Thermo.Ironclad.Model.Ironclad.ServiceModels;
//using Thermo.Swift.Uploader.Model;
//using Thermo.ThermoCloudExternalSDK.CcuApi;

//namespace Thermo.CloudAgent.TrayService.Util
//{
//    public class TokenConverter
//    {
//        public static UserNameInstrumentToken InstrumentTokenToUnt() //note, this is a function so that we make sure that the token is refreshed if the user unregisteres and registers their instrument
//        {
//            if (!CloudSettingsInstance.HasToken())
//                return null;

//            CloudAgentInstrumentToken token = CloudSettingsInstance.Token;
//            return new UserNameInstrumentToken
//            {
//                instrumentToken = token.instrumentToken,
//                username = token.userName,
//                deviceId = token.deviceId
//            };
//        }

//        //public static CloudAgentInstrumentToken CcuRegisterResultToInstrumentToken(RegisterInstrumentResult token)
//        //{
//        //    if (token == null)
//        //        return null;

//        //    return new CloudAgentInstrumentToken
//        //    {
//        //        deviceId = int.Parse(token.instrumentId),
//        //        instrumentToken = token.instrumentToken,
//        //        userName = token.userName
//        //    };
//        //}

//        public static CloudAgentInstrumentToken IconRegisterResultToInstrumentToken(RegisterInstrumentInfoResult token)
//        {
//            if (token == null)
//                return null;

//            return new CloudAgentInstrumentToken
//            {
//                deviceId = token.deviceId,
//                instrumentToken = token.instrumentToken,
//                userName = token.userName
//            };
//        }
//    }
//}