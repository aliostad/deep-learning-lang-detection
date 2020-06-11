from django.conf.urls import patterns, url
import views

urlpatterns = patterns('',
                       url(r'^$', views.day_journal, name='new_day_journal'),
                       url(r'^journals/$', views.all_day_journals, name='all_day_journals'),
                       url(r'^approve/$', views.approve, name='approve_day_journal'),
                       url(r'^(?P<journal_date>\d{4}-\d{2}-\d{2})/$', views.day_journal, name='view_day_journal'),
                       url(r'^save/cash_sales/$', views.save_cash_sales, name='save_cash_sales'),
                       url(r'^save/summary_cash/$', views.save_summary_cash, name='save_summary_cash'),
                       url(r'^save/summary_sales_tax/$', views.save_summary_sales_tax, name='save_summary_sales_tax'),
                       url(r'^save/summary_transfer/$', views.save_summary_transfer, name='save_summary_transfer'),
                       url(r'^save/summary_inventory/$', views.save_summary_inventory, name='save_summary_inventory'),
                       url(r'^save/inventory_fuel/$', views.save_inventory_fuel, name='save_inventory_fuel'),
                       url(r'^save/card_sales/$', views.save_card_sales, name='save_card_sales'),
                       url(r'^save/cash_equivalent_sales/$', views.save_cash_equivalent_sales,
                           name='save_cash_equivalent_sales'),
                       url(r'^save/lotto_detail/$', views.save_lotto_detail, name='save_lotto_detail'),
                       url(r'^delete_attachment/$', views.delete_attachment, name='delete_attachment'),
                       url(r'^save_attachments/$', views.save_attachments, name='save_attachments'),
                       url(r'^save_lotto_sales_as_per_dispenser/$', views.save_lotto_sales_as_per_dispenser,
                           name='save_lotto_sales_as_per_dispenser'),
                       url(r'^save/vendor_payout/$', views.save_vendor_payout, name='save_vendor_payout'),
                       url(r'^save/other_payout/$', views.save_other_payout, name='save_other_payout'),
                       url(r'^last_lotto_detail/(?P<journal_date>\d{4}-\d{2}-\d{2}).json$', views.last_lotto_detail,
                           name='last_lotto_detail'),
                       url(r'^save_sales_register/$', views.save_sales_register, name='save_sales_register'),
)

