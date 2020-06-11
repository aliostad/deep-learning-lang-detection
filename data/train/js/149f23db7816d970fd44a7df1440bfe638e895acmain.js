// 转账模块
require.config({
	paths : {
		transferComm : 'app/modules/transfer/comm',
		transferController : 'app/modules/transfer/controller',
		transferModel : 'app/modules/transfer/model',
		transferView : 'app/modules/transfer/view',
		transferTemplate : 'app/modules/transfer/template',
		noticeDespositTool : 'app/modules/noticeDeposit/model/common',
	}
});

// 加载并实例化转账模块下的controller

define(['transferController/CrossBankGatherController',
        'transferController/CreditCardRepayController',
		'transferController/banktransfer/BankTransferController',
		'transferController/CFEbanktransfer/CFEBankTransferController',  //财富e控制器
		'transferController/gathringManage/GathringManageController',
		'transferController/transferQuery/TransferQueryController',
		'transferController/gathringManage/editGathring/EditGathringController',
		'transferController/gathringManage/mergerSame/MergerGathringController',
		'transferController/BankTransferMainController',
		'transferController/gathringManage/classifyManage/ClassifyManageController',
		'transferController/reserveTransferC',
		'transferComm/commControll/commController',
		'transferComm/transferTools',
		'transferComm/transferLang'
],

function(CrossBankGatherController, CreditCardRepayController, BankTransferController,CFEBankTransferController, GathringManageController,TransferQueryController,EditGathringController,MergerGathringController,
    BankTransferMainController,ClassifyManageController,reserveTransferC,commController,transferLang) {

	return function() {
		CFEBankTransferController.getInstance();
		
		BankTransferMainController.getInstance();
		CrossBankGatherController.getInstance();
		CreditCardRepayController.getInstance();
		BankTransferController.getInstance();
		GathringManageController.getInstance();
        EditGathringController.getInstance();
        MergerGathringController.getInstance();
		reserveTransferC.getInstance();

		ClassifyManageController.getInstance();
        TransferQueryController.getInstance();
		commController.getInstance();

	}
});

