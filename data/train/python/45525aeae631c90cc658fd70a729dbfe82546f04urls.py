from django.conf.urls import patterns, include, url
from django.contrib import admin
from django.http import HttpResponse
from app.views import *
from v2.views import *
from django.views.generic import TemplateView

admin.autodiscover()


from django.conf.urls.defaults import *
from tastypie.api import Api
from v2.resources import *

api = Api(api_name="api")

from app.resources import *


api.register(AdministratorResource())
api.register(GroupResource())
api.register(AssetClassResource())
api.register(AuditorResource())
api.register(BenchComponentResource())
api.register(BrokerResource())
api.register(CounterPartyResource())
api.register(CountryResource())
api.register(CurrencyResource())
api.register(CurrencyRateResource())
api.register(CustodianResource())
api.register(FeeResource())
api.register(BenchPeerResource())
api.register(AlarmResource())
api.register(FundStyleResource())
api.register(GicsCategoryResource())
api.register(HfSectorResource())
api.register(IcbCategoryResource())
api.register(IndustryGroupResource())
api.register(IndustrySectorResource())
api.register(IndustrySubGroupResource())
api.register(IssuerIndustryResource())
api.register(ManagerResource())
api.register(RegionResource())
api.register(ClientValAuditResource())
api.register(FundFeeResource())
api.register(FundFeeAuditResource())
api.register(FundPeerResource())
api.register(InvestmentCategoryResource())
#api.register(FundPositionAuditResource())
api.register(FundResource())
#api.register(FundCharAuditResource())
api.register(FundReturnDailyResource())
api.register(FundReturnMonthlyResource())
api.register(FundReturnMonthlyResource2())
api.register(FundReturnMonthlyResource3())
api.register(HoldingResource())
api.register(HoldingDailyResource())
api.register(HoldingMonthlyResource())
api.register(HoldingDepositResource())
api.register(HoldingEtfResource())
api.register(HoldingEquityResource())
api.register(HoldingFixedIncomeResource())
api.register(HoldingForwardResource())
api.register(HoldingFutureResource())
api.register(HoldingHedgeFundsResource())
api.register(HoldingMutualFundResource())
api.register(HoldingOptionResource())
api.register(HoldingWarrantResource())
api.register(HoldingPositionDailyResource())
api.register(PositionMonthlyResource())
api.register(TradeResource())
api.register(ClientPositionResource())
api.register(ClientTransactionResource())

# fund
"""
#api.register(TestWidget())
api.register(FundReturnMonthlyResource())
api.register(FundReturnMonthlyResource2())
api.register(FundReturnDailyResource())
#api.register(FundResource())
api.register(FundsResource())
#api.register(FundHistoryResource())
#api.register(FundValuationResource())
#api.register(CurrencyPositionResource())
#api.register(FxHedgeResource())
#api.register(FxRateResource())
#api.register(FundClassificationResource())
"""

"""
# holding
api.register(HoldingResource())
api.register(HoldingHistoryResource())
api.register(HoldingValuationResource())
api.register(BreakdownResource())
api.register(CountryBreakdownResource())
api.register(CategoryResource())
api.register(TradeResource())
api.register(AlpheusSubscriptionResource())

# client
api.register(ClientResource())
api.register(ClientHistoryResource())
api.register(SubscriptionRedemptionResource())

"""
# app
#api.register(ImportResource())
#api.register(CurrencyResource())
#api.register(CustodianResource())
#api.register(AdministratorResource())
api.register(InfoResource())
api.register(UserResource())
api.register(WidgetsResource())
api.register(LoggedInResource())
api.register(MenuResource())
api.register(MenuParentItemsResource())
api.register(PageResource(),canonical=True)
api.register(PageWindowResource(),canonical=True)

"""
# comparative
api.register(BenchmarkResource())
api.register(BenchmarkHistoryResource())
api.register(PeerResource())
api.register(PeerHistoryResource())
"""
urlpatterns = patterns('',
    (r'^robots\.txt$', lambda r: HttpResponse("User-agent: *\nDisallow: /", mimetype="text/plain")),
    #(r'^asdf$', lambda r: HttpResponse("<html><script> window.close(); </script></html>", mimetype="text/html")),
    url(r'^$', index, name='index'),
    url(r'^admin/fund/returnestimate/$', fund_return_form, name='fund_return'),
    url(r'^admin/fund/performance/$', performance_by_fund, name='performance_by_fund'),
    #url(r'^admin/fundmonthly/$', TemplateView.as_view(template_name='admin/fundmonthly.html')),

    #url(r'^api/holding-performance-benchmark/$', holding.performancebenchmark),
    #url(r'^api/holding-reconciliation/$', holding.reconciliation),
    #url(r'^api/holding-returnhistogram/$', holding.returnhistogram),
    #url(r'^api/holding-correlation/$', holding.correlation),
    #url(r'^api/holding-negativemonths-table/$', holding.negativemonthstable),
    #url(r'^api/holding-negativemonths-graph/$', holding.negativemonthsgraph),
    #url(r'^api/holding-best-worst/$', holding.bestworst),
    #url(r'^api/holding-returns/$', holding.returns),

    #url(r'^api/client-reconciliation/$', client.reconciliation),
    #url(r'^api/client-performance-benchmark/$', client.performancebenchmark),
    #url(r'^api/client-returnhistogram/$', client.returnhistogram),
    #url(r'^api/client-correlation/$', client.correlation),
    #url(r'^api/client-negativemonths-table/$', client.negativemonthstable),
    #url(r'^api/client-negativemonths-graph/$', client.negativemonthsgraph),
    #url(r'^api/client-best-worst/$', client.bestworst),
    #url(r'^api/client-returns/$', client.returns),

    #url(r'^api/fund-best-worst/$', fund.bestworst),
    #url(r'^api/fund-returns/$', fund.returns),
    #url(r'^api/fund-performance-benchmark/$', fund.performancebenchmark),
    #url(r'^api/fund-reconciliation/$', fund.reconciliation),
    #url(r'^api/fund-returnhistogram/$', fund.returnhistogram),
    #url(r'^api/fund-correlation/$', fund.correlation),
    #url(r'^api/fund-negativemonths-table/$', fund.negativemonthstable),
    #url(r'^api/fund-negativemonths-graph/$', fund.negativemonthsgraph),
    #url(r'^api/fund-subredtable/$', fund.subredtable),
    #url(r'^api/fund-currencyhedge/$', fund.currencyhedge),
    #url(r'^api/fund-cashdeposit/$', fund.cashdeposit),
    #url(r'^api/fund-grossasset1/$', fund.grossasset1),
    #url(r'^api/fund-grossasset2/$', fund.grossasset2),
    #url(r'^api/fund-grossasset3/$', fund.grossasset3),
    #url(r'^api/fund-grossasset4/$', fund.grossasset4),
    #url(r'^api/fund-grossasset5/$', fund.grossasset5),
    #url(r'^api/fund-grossasset6/$', fund.grossasset6),
    
    url(r'^api/sub-red/$', sub_red),
    url(r'^api/nav-reconciliation/$', nav_reconciliation),

    url(r'admin/', include(admin.site.urls)),
    (r'^grappelli/', include('grappelli.urls')),
    url(r'api/doc/', include('tastypie_swagger.urls', namespace='tastypie_swagger')),
    (r'', include(api.urls)),
    )

