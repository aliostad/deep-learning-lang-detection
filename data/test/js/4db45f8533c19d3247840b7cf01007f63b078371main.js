// 网上缴费模块
require.config({
    paths : {
        onlineFeeController : 'app/modules/onlineFee/controller',
        onlineFeeModel : 'app/modules/onlineFee/model',
        onlineFeeView : 'app/modules/onlineFee/view',
        onlineFeeTemplate : 'app/modules/onlineFee/template',
		onlineFeeCommon : 'app/modules/onlineFee/common'
    }
});

// 加载并实例化
define(['onlineFeeController/OnlineFeeHomeController',
    'onlineFeeController/SelfServiceController',
	'onlineFeeController/ShenfaFeeController',
	'onlineFeeController/FuyouFeeController',
	'onlineFeeController/SZPropertyFeeController',
	'onlineFeeController/WaterPowerGasFeeController',
	'onlineFeeController/SZCareerFeeController',
	'onlineFeeController/SZWelfareFeeController',
	'onlineFeeController/CommunicationFeeController',
	'onlineFeeController/paymentController',
	'onlineFeeController/UnionPayFeeController',
	'commonClass/commonTools', 'Native', 'onlineFeeCommon/onlineFeeLang'
	], function(OnlineFeeHomeController, 
		SelfServiceController,
		ShenfaFeeController,
		FuyouFeeController,
		SZPropertyFeeController,
		WaterPowerGasFeeController,
		SZCareerFeeController,
		SZWelfareFeeController,
		CommunicationFeeController,
		paymentController,
		UnionPayFeeController,
		commonTools, Native, onlineFeeLang) {
    return function() {
        OnlineFeeHomeController.getInstance(); 
        SelfServiceController.getInstance(); 
        ShenfaFeeController.getInstance();
        FuyouFeeController.getInstance();
        SZPropertyFeeController.getInstance();
        WaterPowerGasFeeController.getInstance();
        SZCareerFeeController.getInstance();
        SZWelfareFeeController.getInstance();
        CommunicationFeeController.getInstance();
        paymentController.getInstance();
        UnionPayFeeController.getInstance();

    };
});
