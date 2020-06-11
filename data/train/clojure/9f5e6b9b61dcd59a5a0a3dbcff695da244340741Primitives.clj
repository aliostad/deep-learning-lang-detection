(ns metapp.specs.Primitives
  (:require
    [clojure.spec :as s]
    [clojure.spec.test :as st]))
(s/def ::OrderID (s/and pos? int?))
(s/def ::volume nat-int?)
(s/def ::complete boolean?)
(s/def ::ClientID (s/and pos? int?))


(s/def ::Instrument
  (s/keys :req
          [::name
           ::type
           ::displayName
           ::pipLocation
           ::displayPrecision
           ::tradeUnitsPrecision
           ::minimumTradeSize
           ::maximumTrailingStopDistance
           ::minimumTrailingStopDistance
           ::maximumPositionSize
           ::maximumOrderUnits
           ::marginRate]))
(s/def ::InstrumentName #{"CHF_HKD" "XAG_AUD" "XAU_NZD" "USD_CAD" "EUR_HUF" "SGD_HKD" "XAU_CHF"
                          "CAD_SGD" "XAU_GBP" "SPX500_USD" "AUD_CHF" "EUR_SGD" "AU200_AUD" "USD_THB"
                          "GBP_CHF" "UK100_GBP" "DE10YB_EUR" "UK10YB_GBP" "USD_INR" "HK33_HKD" "USB02Y_USD"
                          "WTICO_USD" "GBP_SGD" "USD_SEK" "USD_CHF" "TWIX_USD" "XAG_EUR" "XAG_SGD" "XAU_CAD"
                          "AUD_HKD" "GBP_HKD" "EUR_PLN" "EUR_DKK" "FR40_EUR" "XAG_CHF" "EUR_AUD" "US30_USD"
                          "AUD_USD" "AUD_NZD" "XAG_NZD" "EUR_CAD" "NZD_JPY" "XPT_USD" "EUR_NZD" "GBP_PLN"
                          "AUD_CAD" "US2000_USD" "XAG_CAD" "XPD_USD" "CHF_JPY" "HKD_JPY" "SOYBN_USD" "XAG_JPY"
                          "XAU_USD" "NATGAS_USD" "NZD_USD" "CHF_ZAR" "XAG_USD" "USD_JPY" "EUR_TRY" "NAS100_USD"
                          "XCU_USD" "IN50_USD" "XAG_GBP" "CAD_JPY" "NZD_SGD" "CAD_HKD" "XAU_AUD" "GBP_ZAR" "EUR_CHF"
                          "USD_TRY" "GBP_JPY" "XAG_HKD" "EUR_USD" "USD_ZAR" "CN50_USD" "SGD_CHF" "EU50_EUR" "XAU_HKD"
                          "EUR_NOK" "USD_HUF" "USD_SAR" "GBP_CAD" "XAU_JPY" "EUR_CZK" "CORN_USD" "AUD_JPY" "EUR_ZAR"
                          "GBP_USD" "USD_MXN" "USD_CNH" "AUD_SGD" "DE30_EUR" "XAU_SGD" "WHEAT_USD" "SUGAR_USD" "USD_SGD"
                          "EUR_SEK" "USB05Y_USD" "XAU_EUR" "SG30_SGD" "BCO_USD" "NZD_CAD" "USD_PLN" "GBP_AUD" "USB30Y_USD"
                          "JP225_USD" "XAU_XAG" "NL25_EUR" "TRY_JPY" "CH20_CHF" "USD_NOK" "NZD_HKD" "GBP_NZD" "USD_CZK"
                          "EUR_JPY" "EUR_GBP" "NZD_CHF" "CAD_CHF" "SGD_JPY" "ZAR_JPY" "EUR_HKD" "USB10Y_USD"
                          "USD_HKD" "USD_DKK"})

(s/def ::InstrumentType #{"CFD" "METAL" "CURRENCY"})
(s/def ::AccountsUnits float?)
(s/def ::DecimalNumber float?)
(s/def ::Currency string?)
(s/def ::DateTime string?)