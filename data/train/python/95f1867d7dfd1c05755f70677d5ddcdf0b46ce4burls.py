from django.conf.urls import patterns, include, url
from django.contrib.auth.views import login
from finance.views import(
    index,
    add_voucher,
    save_voucher,
    get_voucher,
    login,
    delete_voucher,
    save_add_change,
    save_edit_voucher,
    account_title,
    save_add_account,
    search_voucher,
    check_account_title,
    save_edit_account,
    delete_account_title,
    breakdown_of_accounts,
	)
  
urlpatterns = patterns('',

  url(r'^$', login),
  url(r'^add_voucher$', add_voucher),
  url(r'^save_voucher$', save_voucher),
  url(r'^delete_voucher?', delete_voucher),
  url(r'^get_voucher?', get_voucher),
  url(r'^save_edit_voucher?', save_edit_voucher),
  url(r'^save_add_change?', save_add_change),
  url(r'^account_title?', account_title),
  url(r'^save_add_account?', save_add_account),
  url(r'^search_voucher?', search_voucher),
  url(r'^check_account_title?', check_account_title),
  url(r'^save_edit_account?', save_edit_account),
  url(r'^delete_account_title?', delete_account_title),
  url(r'^breakdown_of_accounts?', breakdown_of_accounts),

  

)