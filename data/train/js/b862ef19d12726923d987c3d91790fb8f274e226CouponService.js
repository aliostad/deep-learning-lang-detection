FrontendModule.service('CouponService', function(RemoteService){
    var service = this;
    
    this.name = 'CouponService';
    
    this.coupon = {
        
    };

    this.loadCoupon = function(){
        return RemoteService.request(service.name, 'loadCoupon').then(function(response){
            //console.log(response);
            service.coupon = response.data.coupon;
        });
    };
    
    this.applyCoupon = function(code){
        return RemoteService.request(service.name, 'applyCoupon', { 'code': code }).then(function(response){
            service.coupon = response.data.coupon;
        });
    };
    
    this.removeCoupon = function(){
        service.coupon = {
            'code': '',
            'amount': 0,
            'validity': 'unchecked'
        };
        
        return RemoteService.request(service.name, 'removeCoupon');
    };
});
