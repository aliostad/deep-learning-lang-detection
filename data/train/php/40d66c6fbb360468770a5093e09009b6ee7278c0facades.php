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

namespace App\Models\Front\Facades {

	use Dais\Support\Facade;

	class AccountAddress extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_address';
	    }
	}

	class AccountAffiliate extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_affiliate';
	    }
	}

	class AccountCredit extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_credit';
	    }
	}

	class AccountCustomer extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_customer';
	    }
	}

	class AccountCustomerGroup extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_customer_group';
	    }
	}

	class AccountDownload extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_download';
	    }
	}

	class AccountNotification extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_notification';
	    }
	}

	class AccountOrder extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_order';
	    }
	}

	class AccountProduct extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_product';
	    }
	}

	class AccountRecurring extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_recurring';
	    }
	}

	class AccountReturns extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_returns';
	    }
	}

	class AccountReward extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_reward';
	    }
	}

	class AccountWaitlist extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_account_waitlist';
	    }
	}

	class CatalogCategory extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_category';
	    }
	}

	class CatalogManufacturer extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_manufacturer';
	    }
	}

	class CatalogProduct extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_product';
	    }
	}

	class CatalogReview extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_catalog_review';
	    }
	}

	class CheckoutCoupon extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_checkout_coupon';
	    }
	}

	class CheckoutFraud extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_checkout_fraud';
	    }
	}

	class CheckoutGiftCard extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_checkout_gift_card';
	    }
	}

	class CheckoutGiftCardTheme extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_checkout_gift_card_theme';
	    }
	}

	class CheckoutOrder extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_checkout_order';
	    }
	}

	class CheckoutRecurring extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_checkout_recurring';
	    }
	}

	class ContentAuthor extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_content_author';
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

	class LocaleLanguage extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_language';
	    }
	}

	class LocaleReturnReason extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_return_reason';
	    }
	}

	class LocaleZone extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_locale_zone';
	    }
	}

	class PaymentExpressIpn extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_payment_express_ipn';
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

	class SettingMenu extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_setting_menu';
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

	class ToolImage extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_tool_image';
	    }
	}

	class ToolOnline extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_tool_online';
	    }
	}

	class ToolUtility extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_tool_utility';
	    }
	}

	class WidgetEvent extends Facade {
		protected static function getFacadeAccessor() {
	        return 'model_widget_event';
	    }
	}
}
