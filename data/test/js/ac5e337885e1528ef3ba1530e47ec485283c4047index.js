/**
 * Shortcut for the services package
 */

module.exports = {
	// STANDARD
	coupons       : require('./standard/coupons').service,
	linkgenerator : require('./standard/linkgenerator').service,
	merchant      : require('./standard/merchantquery').service,
	targeted      : require('./standard/targeted').service,
	// SECURE
	advertiserpayment : require('./secure/advertiserpayment').service,
	paymentdetail     : require('./secure/paymentdetail').service,
	paymenthistory    : require('./secure/paymenthistory').service,
	// LINKLOCATOR
	advertiserinfo     : require('./linklocator/advertiserinfo').service,
	bannerlinks        : require('./linklocator/bannerlinks').service,
	creativecategories : require('./linklocator/creativecategories').service,
	drmlinks           : require('./linklocator/drmlinks').service,
	productlinks       : require('./linklocator/productlinks').service,
	textlinks          : require('./linklocator/textlinks').service,
	// SIGNATURE ORDER
	signatureorderreport : require('./signatureorderreport/signatureorderreport').service
}