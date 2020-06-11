import webapp2
from handlers import *

def main():
    return webapp2.WSGIApplication([
        ('/api/user/',                      api.UserHandler),
        ('/api/user/[0-9]+',                api.UserIDHandler),
        ('/api/user/[0-9]+/coupons/',       api.UserIDCouponHandler),
        ('/api/user/[0-9]+/coupons/[0-9]+', api.UserIDCouponIDHandler),
        ('/api/coupon/',                    api.CouponHandler),
        ('/api/coupon/[0-9]+',              api.CouponIDHandler),
        ('/api/business/',                  api.BusinessHandler),
        ('/api/business/[0-9]+',            api.BusinessIDHandler),
        ('/api/init/',                      api.InitHandler),
        ('/api/consistency/',               api.ConsistencyCheckHandler),
        ('/api/consistency/repair',         api.ConsistencyFixHandler),

        ('.*[^/]$',     SlashHandler),
        ('/',           MainHandler),
        ('/admin/',     AdminHandler),
        ('/admin/old/', OldAdminHandler),

        ('/login/',                     LoginHandler),
        ('/logout/',                    LogoutHandler),
        ('/register/',                  RegisterHandler),
        ('/legal/',                     LegalHandler),
        ('/partner/',                   PartnerHandler),
        ('/coupon/',                    CouponHandler),
        ('/coupon/[0-9]+/',             CouponIDHandler),
        ('/coupon/[0-9]+/edit/',        CouponIDEditHandler),
        ('/business/',                  BusinessHandler),
        ('/business/[0-9]+/',           BusinessIDHandler),
        ('/business/[0-9]+/admin/',     BusinessIDAdminHandler),
        ('/business/[0-9]+/manage/',    BusinessIDManageHandler),
        ('/business/[0-9]+/upload/',    BusinessIDUploadHandler),
        ('/user/',                      UserHandler),
        ('/user/[0-9]+/',               UserIDHandler),
        ('/user/[0-9]+/edit/',          UserIDAdminHandler)
    ], debug=True)


app = main()
