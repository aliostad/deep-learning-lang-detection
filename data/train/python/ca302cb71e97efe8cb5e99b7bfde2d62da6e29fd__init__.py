#!/usr/bin/env python2
# coding=utf8

from __future__ import absolute_import, division, print_function
from walis.api.banner import BannerApi
from walis.api.cs import (
    CSEventApi,
    CSEventCategoryApi,
    CSUser,
)
from walis.api.file import FileApi
from walis.api.notice import (
    SmsApi,
    HermesReceiverApi,
)
from walis.api.ping import PingApi
from walis.api.voicecall import VoiceCallApi
from walis.api.user import (
    UserApi,
)
from walis.service.login.api import LoginApi
from walis.api.poi import AmendedPoiApi
from walis.api.region import (
    CityApi,
    DistrictApi,
    ZoneApi,
    EntryApi,
    RegionApi,
    CityManageApi,
    RegionBrandApi,
    WhiteCollarBuildingApi,
)
from walis.api.analytics import (
    TransactionQueryConfigApi,
    RegionTransactionApi,
)
from walis.api.pay import RefundApi, PaymentApi
from walis.api.rst import (
    RestaurantApi,
    RestaurantMenuApi,
    FoodApi,
    FoodCategoryApi,
    FoodImageApi,
    RecruitApi,
    RstInfoNotificationApi,
    RstBankCardApi,
    RstGroupApi)
from walis.api.activity import (
    ActPayNoticeApi,
    RstActivityApi,
    FoodActivityApi,
    ActivityContractApi,
    ActivityPaymentApi,
)
from walis.api.order import (
    CustomerServiceUserApi,
    OrderAuditApi,
    # OrderQueryApi,
    # OrderQueryExportApi,
)

from walis.api.cert import CertificationApi
from walis.api.coupon import CouponApi, CouponBatchApi

from walis.api.misc import ChaosApi, ElemeOrder, SimpleURLApi, BankApi

__all__ = [
    PingApi,
    LoginApi,
    FileApi,

    AmendedPoiApi,
    UserApi,

    # Region
    RegionApi,
    CityApi,
    DistrictApi,
    ZoneApi,
    EntryApi,
    CityManageApi,
    RegionBrandApi,
    WhiteCollarBuildingApi,

    # Analytics
    TransactionQueryConfigApi,
    RegionTransactionApi,


    CertificationApi,
    CouponApi,

    # Coupon Batch
    CouponBatchApi,

    # Pay
    RefundApi,
    PaymentApi,

    #Rst
    RestaurantApi,
    RestaurantMenuApi,
    RecruitApi,
    FoodApi,
    FoodCategoryApi,
    FoodImageApi,
    RstBankCardApi,
    RstGroupApi,

    # Activity
    RstActivityApi,
    FoodActivityApi,
    ActivityContractApi,
    ActivityPaymentApi,
    ActPayNoticeApi,

    # Order
    CustomerServiceUserApi,
    OrderAuditApi,
    # OrderQueryApi,
    # OrderQueryExportApi,

    BannerApi,
    RstInfoNotificationApi,

    # notice
    SmsApi,
    HermesReceiverApi,

    # Misc
    ChaosApi,
    ElemeOrder,
    SimpleURLApi,
    BankApi,

    VoiceCallApi,

    # Customer Service
    CSEventApi,
    CSEventCategoryApi,
    CSUser,

]


def api_init(app):
    for api in __all__:
        api.register(app, route_prefix='api', trailing_slash=False)
