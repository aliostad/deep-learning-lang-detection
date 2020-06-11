/**
 * 接口
 */

define(function(require, exports, module){
    var version = "/x5/";

    var API = {
        
        jsonp: false,

        domain: !!(MOGU.isProduction)?version:"/Data"+version,

        interface: {
            //Welcome Api
            WELCOME_API: 'index/index',


            //Book Api
            BOOK_API: 'book/',        //图墙

            BOOKCATEGORY_API: 'book/categories',    //图墙类别

            CLASSIFY_API: 'book/classify',         //搭配、晒货、团购类别


            //Dapei Api
            DAPEI_API: 'photo/dapei',
            //Shaihuo Api
            SHAIHUO_API: 'photo/look',
            //Search Api
            SEARCH_AIP: 'search/',

            //Tuan Api
            TUANTAOBAO_API: 'tuan/list',

            TUANDETAIL_API: 'tuan/detail',

            TUANCOUPON_API: 'tuan/getcoupon',



            //SIMILAR_API: 'twitter/similar'
            //Note 页面
            COMMENTARY_API_LIST:"twitter/commentaryList",

            COMMENTARY_API: 'twitter/commentary',

            ADDFAV_API: 'twitter/addfav',

            DELFAV_API: 'twitter/delfav',

            SINGLE_API: 'twitter/single',


            //User Api
            GETPROFILE_API: 'user/getprofile',

            LOGIN_API: 'user/login',           //登陆

            REGISTER_API: 'user/register',           //注册

            LOGOUT_API: 'user/logout',           //退出登陆

            CAPTCHA_API: 'util/getcaptcha',       //验证码

            CAPTCHAIMG_API: 'util/captchaimg',         //图片翻转验证码

            ADDFOLLOW_API: 'user/addfollow',      //加关注

            UNFOLLOW_API: 'user/unfollow',      //取消关注


            //Home Api
            FANS_API: 'home/fans',

            FOLLOW_API: 'home/follow',

            COVER_API: 'home/talk',

            FAV_API: 'home/fav',

            TIMELINE_API: 'home/timeline',

            FRIEND_API: 'search/friend',


            //Album Api
            GETALBUM_API: 'home/album',      //获取个人专辑

            ADDALBUM_API: 'album/add',       //添加专辑

            SHOWALBUM_API: 'album/show',      //所有专辑

            ALBUMLIST_API: 'album/list',

            ALBUMCATEGORY_API: 'album/categories',


            //Msg Api
            ATME_API: 'message/atme',

            SYSAT_API: 'message/sysat',

            IMLIST_API: 'message/imlist',
            
            IMHISTORY_API: 'message/imhistory',

            IMREPLY_API: 'message/imreply',



            //Trade Address Api
            ADDRLIST_API: 'address/getaddresslist',                //地址列表

            GETDEFAULTADDR_API: 'address/getdefaultaddress',        //获取默认地址

            SETDEFAULTADDR_API: 'address/setdefaultaddress',        //设置默认地址

            DELADDR_API: 'address/deladdress',                      //删除地址

            EDITADDR_API: 'address/saveaddress',                    //编辑、增加地址

            LOCATION_API: 'address/getlocationlist',                //获取地址选择列表


            //Trade Order Api
            SKU_API: 'pay/sku',                             //获取SKU

            GETCOST_API: 'pay/getcost',                        //获取总价

            ORDER_API: 'pay/createorder',                //下订单

            BILL_API: 'pay/initbill',                          //结算信息

            PAY_API: 'pay/pay',                                //购买

            ORDERSTATUS_API: 'pay/getorderstatus',             //订单状态

            ORDERLIST_API: 'pay/getorderlist',                 //订单列表

            ORDERDETAIL_API: 'pay/getorderdetail',

            //ORDERADDRATE_API: 'pay/getorderdetail',
            ORDERADDRATE_API: 'pay/detail4appendRate',       //   订单追加评价信息

            COUPONLIST_API: 'pay/getcouponlist',                //优惠券列表

            CHECKORDER_API: 'pay/checkorder',                   //确认收货

            CANCLEORDER_API: 'pay/cancleorder',                   //取消订单

            //新增API
            ADDR_API: 'address/getaddressdetail',                //单个地址

            ORDERInfo_API: 'pay/getorderdetail',                 //单个订单

            PAYMENT_API: 'pay/getpayment',                       //支付方式


	        //商品详情页
	        DETAIL_API        : 'detail/',                     //商品详情
	        COMMENT_API       : 'goods/comment',                     //评论信息

	        NOTE_API: 'note/'                               //Note Api
        },

        getApi : function(apiName, domain ,jsonp) {
            var domain = domain || this.domain;
            return  domain + this.interface[apiName];
        }
    };


    module.exports = API;

});

