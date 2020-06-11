from django.conf.urls import patterns, url

from common import globals as g
from mobile.views.manage.company import get_company, edit_company
from mobile.views.manage.register import mobile_add_register, mobile_edit_register, \
    mobile_delete_register, mobile_get_register

from mobile.views import views

from mobile.views import login
from mobile.views import bill
from mobile.views.manage import category
from mobile.views.manage import product
from mobile.views.manage import discount
from mobile.views.manage import tax
from mobile.views.manage import contact
from mobile.views.manage import configuration
from mobile.views.manage import bill as bill_management
from mobile.views.manage import users

### common URL prefixes: ###
# company's site: /pos/blocklogic
# readable pattern: (?P<company>[\w-]{1,30})

r_company = r'^(?P<company_id>[\w-]+)'
# system pages (registration, login, logout, ...: /pos/app/register-company
# r_manage = g.MISC['management_url'] + '/'

urlpatterns = patterns('',

    # LOGIN
    # url(r'^mobile-login/(?P<backend>[\w-]+)$', login.obtain_auth_token),

    # categories
    url(r_company + r'/manage/json/category/add/?$', category.mobile_add_category, name='add_category'),
    url(r_company + r'/manage/json/category/edit/?$', category.mobile_edit_category, name='edit_category'), # edit
    url(r_company + r'/manage/json/category/delete/?$', category.mobile_delete_category, name='delete_category'), # delete
    url(r_company + r'/manage/json/categories/?$', category.mobile_JSON_categories_strucutred, name='JSON_categories'),
    url(r_company + r'/manage/json/categories/all/?$', category.mobile_JSON_categories, name='JSON_categories'),
    # url(r_company + r'/manage/json/category/dumps', category.mobile_JSON_dump_categories, name='dump_category'),
    # contacts
    url(r_company + r'/manage/json/contacts/?$', contact.mobile_list_contacts, name='list_contacts'),
    url(r_company + r'/manage/json/contact/add/?$', contact.mobile_add_contact, name='add_contact'),
    url(r_company + r'/manage/json/contact/get/(?P<contact_id>\d+)/?$', contact.mobile_get_contact, name='get_contact'),
    url(r_company + r'/manage/json/contact/edit/', contact.mobile_edit_contact, name='edit_contact'),
    url(r_company + r'/manage/json/contact/delete/?$', contact.mobile_delete_contact, name='delete_contact'),


    # discounts
    url(r_company + r'/manage/json/discounts/?$', discount.mobile_list_discounts, name='get_discounts'),
    url(r_company + r'/manage/json/discounts/add/?$', discount.mobile_add_discount, name='add_dicount'),
    url(r_company + r'/manage/json/discounts/delete/?$', discount.mobile_delete_discount, name='delete_discount'),
    url(r_company + r'/manage/json/discounts/edit/?$', discount.mobile_edit_discount, name='edit_discount'),

    # units
    url(r_company + r'/manage/json/units/?$', views.mobile_get_units, name='get_units'),

    # taxes
    url(r_company + r'/manage/json/taxes/?$', tax.mobile_list_taxes, name='get_taxes'), # get all taxes in a json list
    url(r_company + r'/manage/json/taxes/edit/?$', tax.mobile_edit_tax, name='edit_tax'),
    url(r_company + r'/manage/json/taxes/save-default/?$', tax.mobile_save_default_tax, name='edit_tax'),
    url(r_company + r'/manage/json/taxes/delete/?$', tax.mobile_delete_tax, name='delete_tax'),
    # products
    url(r_company + r'/manage/json/products/?$', product.mobile_get_products, name='get_products'),
    url(r_company + r'/manage/json/products/search/?$', product.mobile_search_products, name='search_products'), # product list (search) - json

    url(r_company + r'/manage/json/products/add/?$', product.mobile_create_product, name='mobile_create_product'),
    url(r_company + r'/manage/json/products/get/(?P<product_id>\d+)/?$', product.mobile_get_product, name='get_product'), # product list (search) - json
    url(r_company + r'/manage/json/products/edit/?$', product.mobile_edit_product, name='edit_product'), # edit (save) product - json
    url(r_company + r'/manage/json/products/delete/?$', product.mobile_delete_prodcut, name='delete_product'), # edit (save) product - json
    url(r_company + r'/manage/json/products/favourite/?$', product.mobile_toggle_favorite, name='delete_product'), # edit (save) product - json

    # CUT (Categories, units, taxes)
    url(r_company + r'/manage/json/cut/get', views.mobile_get_cut, name='get_cut'), # get categories, units, taxes

    url(r_company + r'/manage/json/units/?$', product.mobile_JSON_units, name='mobile_JSON_units'),

    # Mr. Bill
    url(r_company + r'/manage/json/bill/add/?$', bill.mobile_create_bill, name='mobile_add_bill'),
    url(r_company + r'/manage/json/bill/finish/?$', bill.mobile_finish_bill, name='mobile_add_bill'),
    url(r_company + r'/manage/json/bill/get_btc_price/?$', bill.get_payment_btc_info, name='mobile_add_bill'),
    url(r_company + r'/manage/json/bill/check_bill_status/?$', bill.check_bill_status, name='mobile_check_status'),
    url(r_company + r'/manage/json/bill/change_payment_type?$', bill.change_payment_type, name='mobile_change_payment_type'),
    url(r_company + r'/manage/json/bill/paypal-send-invoice/$', bill.send_invoice, name='mobile_send_invoice'),

    # bill
    url(r_company + r'/manage/json/bill/list/?$', bill_management.list_bills, name='mobile_list_bills'),
    url(r_company + r'/manage/json/bill/print/?$', bill_management.print_bill, name='mobile_print_bill'),

    # configuration
    url(r_company + r'/manage/json/config/?$', configuration.get_mobile_config, name='mobile_get_config'),
    url(r_company + r'/manage/json/config/edit?$', configuration.save_company_config, name='mobile_get_config'),

    # company
    url(r_company + r'/manage/json/company/get', get_company, name='mobile_get_company'),
    url(r_company + r'/manage/json/company/edit', edit_company, name='mobile_edit_company'),

    # register
    # url(r_company + r'/manage/json/register/get', list_registers, name='mobile_get_registers'),
    url(r_company + r'/manage/json/register/add', mobile_add_register, name='mobile_add_register'),
    url(r_company + r'/manage/json/register/edit', mobile_edit_register, name='mobile_edit_register'),
    url(r_company + r'/manage/json/register/delete', mobile_delete_register, name='mobile_delete_register'),
    url(r_company + r'/manage/json/register/get_with_id', mobile_get_register, name='mobile_get_register_with_id'),
    # available discounts list
    # url(r_company + r'/manage/json/discounts/?$', discount.JSON_discounts, name='JSON_discounts'),


    # user
    url(r_company + r'/manage/json/users/unlock/?$', users.unlock_session, name='mobile_unlock_session'),
    url(r_company + r'/manage/json/users/lock/?$', users.mobile_lock_session, name='mobile_unlock_session'),
    url(r'manage/json/users/get_credentials/?$', users.mobile_get_user_credentials, name='mobile_get_user_credentials'),

    url(r'mobile-accept-invitation', views.mobile_accept_invitation, name='mobile-accept-invitation'),
    url(r'mobile-decline-invitation', views.mobile_decline_invitation, name='mobile-decline-invitation'),
)
