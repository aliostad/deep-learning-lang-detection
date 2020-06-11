require.config({
    paths : {
        fundMarketView : 'app/modules/fundMarket/view',
        fundMarketModel : 'app/modules/fundMarket/model',
        fundMarketTemplate : 'app/modules/fundMarket/template',
        fundMarketController : 'app/modules/fundMarket/controller',
        fundMarketCommon : 'app/modules/fundMarket/common'
    }
});

define([
"commonClass/commonTools",
"fundMarketCommon/accessible",
"commonView/componentEventBoot",
    
"fundMarketController/IndexController",
"fundMarketController/FundsController", 
"fundMarketController/FundPositionsController",
"fundMarketController/AttentionController",
"fundMarketController/MyFundPlanController",
"fundMarketController/EntrustRepealController",
'fundMarketController/QueryController',
'fundMarketController/TAAccountManagerController',
"fundMarketController/PurchaseController",
"fundMarketController/InvestController",
"fundMarketController/AccessErrorController"],
function(commonTools, accessible){
    var dependencies = arguments;
    
	window.App = window.App || {};
	App.checkFundMarketAccessible = _.bind(accessible.check, accessible);
	
	return function(){
		// ensure each Controller has an instance
		_.each(dependencies, function(controller){
			_.result(controller, "getInstance");
		});	
	};
});
