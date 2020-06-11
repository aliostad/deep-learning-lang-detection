var service = EasyServiceClient.getRemoteProxy("/easyservice/gpps.service.ILenderService");
var bservice = EasyServiceClient.getRemoteProxy("/easyservice/gpps.service.IBorrowerService");
//var letterDao = EasyServiceClient.getRemoteProxy("/easyservice/gpps.dao.ILetterDao");
var myaccountService = EasyServiceClient.getRemoteProxy("/easyservice/gpps.service.IMyAccountService");
var lettercount = 0;

var res = myaccountService.getCurrentUser();

var usertype = res.get('usertype');
var user = res.get('value');
if(usertype=='lender' || usertype=='borrower'){
	lettercount = res.get('letter');
}
