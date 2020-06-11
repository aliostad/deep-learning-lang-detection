var CronService=require("../../services/cronservice.js");
var assert=require("assert");

describe("Cron Service",function(){
    it("should create a new cron service",function(){
        var cronService=new CronService("name","*/5 * * * * *");
        assert(cronService.serviceName=="name");
        assert(cronService.cronTab=="*/5 * * * * *");
        assert(cronService.cronJob);
        assert(cronService.cronJob.cronTime.source==cronService.cronTab);
    });
    it ("should emit run event when it runs",function(done){
         var cronService=new CronService("name","* * * * * *");
         cronService.on("run",function(){
            assert(true);
            cronService.stopService();
            assert(cronService.running==false);
            done();
         });
         cronService.startService();
         assert(cronService.running==true);
    });

});