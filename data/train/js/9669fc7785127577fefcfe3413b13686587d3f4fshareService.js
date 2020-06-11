/**
 * Created by king on 1/4/15.
 */



appService.factory('shareService',['$rootScope',function($rootscope){

    var pService={};
    pService.logindata={};
    pService.setlogin=function(data){

        pService.logindata=data;
        if(window.localStorage) {
            window.localStorage.setItem('loginfiremages',JSON.stringify(data));

        }
        $rootscope.$broadcast("loginEvent");
    };

    pService.getlogin=function(){
        if(window.localStorage) {
            return JSON.parse(window.localStorage.getItem('loginfiremages'));
        } else {

            return pService.logindata;
        }
        };
    pService.userdata=[];
    pService.setusers=function(data){
        pService.userdata=data;

    };

    pService.getusers=function(){
        return pService.userdata;
    };

    pService.enhanceblog=function(blog,users){
        var temp=[];
        var i=0;
        for(var j=0; j < blog.length; j++){
            for(var k=0; k < users.length; k++){
                if(blog[j].username==users[k].username){
                    temp[i]=blog[j];
                    temp[i].myphoto=users[k].photo;
                    temp[i].status=users[k].status;
                    i++;
                }
            }
        }
        return temp;
    };

    pService.validateEmail=function(email) {
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    };

    pService.validateUsername=function(username){
        var regexp=/[\{\(\)\}\$\%\^\!\~\`\#\&\=\+\,\?\<\>\[\]]/;
        return regexp.test(username);
    };
    // get image type by passing image type
    pService.getImageType=function(imagetype){
        switch (imagetype){
            case 'image/png':
                return'.png';
            break;
            case 'image/jpg':
                return'.jpg';
            break;
            case 'image/jpeg':
                return'.jpeg';
            break;
            case 'image/gif':
                return'.gif';
            break;
            case 'image/pdf':
                return'.pdf';
            break;

        }
    };

    pService.forum={};
    pService.setForum=function(data){
        pService.forum=data;
    };

    pService.getForum=function(){
        return pService.forum;
    };


    pService.topic={};
    pService.setTopic=function(data){
        pService.topic=data;
        $rootscope.$broadcast('topicEvent');
    };

    pService.getTopic=function(){
        return pService.topic;
    };

    pService.alert="";
    pService.setAlert=function(msg){
        pService.alert=msg;
        $rootscope.$broadcast('alertEvent')
    };

    pService.getAlert=function(){
        return pService.alert;
    };

    pService.mystatus="";
    pService.setStatus=function(status){
        pService.mystatus=status;

    };

    pService.getStatus=function(){
        return pService.mystatus;
    };

    pService.mstatus="";
    pService.setmstatus=function(msg){
        pService.mstatus=msg;
        $rootscope.$broadcast('mstatusEvent')
    };

    pService.mstatus=function(){
        return pService.mstatus;
    };

    pService.pin="";
    pService.setpin=function(msg){
        pService.pin=msg;
        $rootscope.$broadcast('pinEvent')
    };

    pService.getpin=function(){
        return pService.pin;
    };

    pService.item={};
    pService.setItem=function(data){
        pService.item=data;
    };

    pService.getItem=function(){
        return pService.item;
    };

    pService.font="";
    pService.setfont=function(msg){
        pService.font=msg;
        $rootscope.$broadcast('fontEvent')
    };

    pService.getfont=function(){
        return pService.font;
    };

    pService.tag="";
    pService.settag=function(msg){
        pService.tag=msg;
        $rootscope.$broadcast('tagEvent')
    };

    pService.gettag=function(){
        return pService.tag;
    };

    pService.statefrom="";
    pService.setStatefrom=function(msg){
        pService.statefrom=msg;
        $rootscope.$broadcast('statefromEvent')
    };

    pService.getStatefrom=function(){
        return pService.statefrom;
    };

    return pService;
}]);