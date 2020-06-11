(function(){ 
  function RemotingServiceFactory() {    
  }
  RemotingServiceFactory.prototype.__proto__ = Object.prototype;
  __cache["java.lang.RemotingServiceFactory"] = RemotingServiceFactory;
  RemotingServiceFactory.getInstance = function(){
    return RemotingServiceFactory.INSTANCE;
  };
  RemotingServiceFactory.prototype.getService = function(clazz){
    return clazz.prototype;
  };
  RemotingServiceFactory.INSTANCE = new (__lc('java.lang.RemotingServiceFactory'))();
  RemotingServiceFactory.prototype.__class = new (__lc('java.lang.Class'))("java.lang.RemotingServiceFactory", RemotingServiceFactory, Object.prototype.__class, [], 1);
  return  RemotingServiceFactory;
})();