<?php

/*
|--------------------------------------------------------------------------
|   Dais
|--------------------------------------------------------------------------
|
|   This file is part of the Dais Framework package.
|	
|	(c) Vince Kronlein <vince@dais.io>
|	
|	For the full copyright and license information, please view the LICENSE
|	file that was distributed with this source code.
|	
*/

namespace App\Models\Admin\Facades {

	use Dais\Support\Facade;

	class CalendarEvent extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_calendar_event';
	    }
	}

	class CatalogAttribute extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_attribute';
	    }
	}

	class CatalogAttributeGroup extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_attribute_group';
	    }
	}

	class CatalogCategory extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_category';
	    }
	}

	class CatalogDownload extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_download';
	    }
	}

	class CatalogFilter extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_filter';
	    }
	}

	class CatalogManufacturer extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_manufacturer';
	    }
	}

	class CatalogOption extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_option';
	    }
	}

	class CatalogProduct extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_product';
	    }
	}

	class CatalogRecurring extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_recurring';
	    }
	}

	class CatalogReview extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_review';
	    }
	}

	class ContentCategory extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_content_category';
	    }
	}

	class ContentComment extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_content_comment';
	    }
	}

	class ContentPage extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_content_page';
	    }
	}

	class ContentPost extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_content_post';
	    }
	}

	class DesignBanner extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_design_banner';
	    }
	}
	
	class DesignLayout extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_design_layout';
	    }
	}

	class DesignRoute extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_design_route';
	    }
	}

	class LocaleCountry extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_country';
	    }
	}

	class LocaleCurrency extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_currency';
	    }
	}

	class LocaleGeoZone extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_geo_zone';
	    }
	}

	class LocaleLanguage extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_language';
	    }
	}

	class LocaleLengthClass extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_length_class';
	    }
	}

	class LocaleOrderStatus extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_order_status';
	    }
	}

	class LocaleReturnAction extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_return_action';
	    }
	}

	class LocaleReturnReason extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_return_reason';
	    }
	}

	class LocaleReturnStatus extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_return_status';
	    }
	}

	class LocaleStockStatus extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_stock_status';
	    }
	}

	class LocaleTaxClass extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_tax_class';
	    }
	}

	class LocaleTaxRate extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_tax_rate';
	    }
	}

	class LocaleWeightClass extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_weight_class';
	    }
	}

	class LocaleZone extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_zone';
	    }
	}

	class ModuleMenu extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_module_menu';
	    }
	}

	class ModuleNotification extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_module_notification';
	    }
	}

	class PaymentPayflowIframe extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_payment_payflow_iframe';
	    }
	}

	class PaymentPaypalExpress extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_payment_paypal_express';
	    }
	}

	class PaymentPaypalProIframe extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_payment_paypal_pro_iframe';
	    }
	}

	class PeopleCustomer extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_people_customer';
	    }
	}

	class PeopleCustomerBanIp extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_people_customer_ban_ip';
	    }
	}

	class PeopleCustomerGroup extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_people_customer_group';
	    }
	}

	class PeopleUser extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_people_user';
	    }
	}

	class PeopleUserGroup extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_people_user_group';
	    }
	}

	class ReportAffiliate extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_report_affiliate';
	    }
	}

	class ReportCoupon extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_report_coupon';
	    }
	}

	class ReportCustomer extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_report_customer';
	    }
	}

	class ReportDashboard extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_report_dashboard';
	    }
	}

	class ReportOnline extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_report_online';
	    }
	}

	class ReportProduct extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_report_product';
	    }
	}

	class ReportReturns extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_report_returns';
	    }
	}

	class ReportSale extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_report_sale';
	    }
	}

	class SaleCoupon extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_sale_coupon';
	    }
	}

	class SaleFraud extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_sale_fraud';
	    }
	}

	class SaleGiftCard extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_sale_gift_card';
	    }
	}

	class SaleGiftCardTheme extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_sale_gift_card_theme';
	    }
	}

	class SaleOrder extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_sale_order';
	    }
	}

	class SaleRecurring extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_sale_recurring';
	    }
	}

	class SaleReturns extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_sale_returns';
	    }
	}

	class SettingModule extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_setting_module';
	    }
	}

	class SettingSetting extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_setting_setting';
	    }
	}

	class SettingStore extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_setting_store';
	    }
	}

	class ToolBackup extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_tool_backup';
	    }
	}

	class ToolImage extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_tool_image';
	    }
	}

	class ToolUtility extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_tool_utility';
	    }
	}
}
