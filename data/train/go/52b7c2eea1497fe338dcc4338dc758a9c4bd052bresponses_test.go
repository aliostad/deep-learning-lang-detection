package api

// These are the stubbed responses used in tests
var (
	systemStatusJSON = `{
		"timestamp":123,
		"valid_version":true,
		"system_running":true,
		"message":"test"
	}`

	accountsJSON = `[{
		"accno": 123,
		"type": "test",
		"default": true,
		"alias": "test",
		"blocked": true,
		"blocked_reason": "test"
	}]`

	accountJSON = `{
		"account_currency": "test",
		"account_credit": {
			"value": 1.1,
			"currency": "test"
		},
		"account_sum": {
			"value": 1.1,
			"currency": "test"
		},
		"collateral": {
			"value": 1.1,
			"currency": "test"
		},
		"credit_account_sum": {
			"value": 1.1,
			"currency": "test"
		},
		"forward_sum": {
			"value": 1.1,
			"currency": "test"
		},
		"future_sum": {
			"value": 1.1,
			"currency": "test"
		},
		"unrealized_future_profit_loss": {
			"value": 1.1,
			"currency": "test"
		},
		"full_marketvalue": {
			"value": 1.1,
			"currency": "test"
		},
		"interest": {
			"value": 1.1,
			"currency": "test"
		},
		"intraday_credit": {
			"value": 1.1,
			"currency": "test"
		},
		"loan_limit": {
			"value": 1.1,
			"currency": "test"
		},
		"own_capital": {
			"value": 1.1,
			"currency": "test"
		},
		"own_capital_morning": {
			"value": 1.1,
			"currency": "test"
		},
		"pawn_value": {
			"value": 1.1,
			"currency": "test"
		},
		"trading_power": {
			"value": 1.1,
			"currency": "test"
		}
	}`

	accountLedgersJSON = `[{
		"total_acc_int_deb": {
			"value": 1.1,
			"currency": "test"
		},
		"total_acc_int_cred": {
			"value": 1.1,
			"currency": "test"
		},
		"total": {
			"value": 1.1,
			"currency": "test"
		},
		"ledgers": [{
			"currency": "test",
			"account_sum": {
				"value": 1.1,
				"currency": "test"
			},
			"account_sum_acc": {
				"value": 1.1,
				"currency": "test"
			},
			"acc_int_deb": {
				"value": 1.1,
				"currency": "test"
			},
			"acc_int_cred": {
				"value": 1.1,
				"currency": "test"
			},
			"exchange_rate": {
				"value": 1.1,
				"currency": "test"
			}
		}]
	}]`

	accountOrdersJSON = `[{
		"accno": 123,
		"order_id": 123,
		"price": {
			"value": 1.1,
			"currency": "test"
		},
		"volume": 1.1,
		"tradable": {
			"identifier": "test",
			"market_id": 123
		},
		"open_volume": 1.1,
		"traded_volume": 1.1,
		"side": "test",
		"modified": 123,
		"reference": "test",
		"activation_condition": {
			"type": "test",
			"trailing_value": 1.1,
			"trigger_value": 1.1,
			"trigger_condition": "test"
		},
		"price_condition": "test",
		"volume_condition": "test",
		"validity": {
			"type": "test",
			"valid_until": 123
		},
		"action_state": "test",
		"order_state": "test"
  }]`

	orderJSON = `{
		"order_id": 123,
		"result_code": "test",
		"order_state": "test",
		"action_state": "test",
		"message": "test"
	}`

	accountPositionsJSON = `[{
		"accno": 123,
		"instrument": {
			"instrument_id": 123,
			"tradables": [{
				"market_id": 123,
				"identifier": "test",
				"tick_size_id": 123,
				"lot_size": 1.1,
				"display_order": 123
			}],
			"currency": "test",
			"instrument_group_type": "test",
			"instrument_type": "test",
			"multiplier": 1.1,
			"symbol": "test",
			"isin_code": "test",
			"market_view": "test",
			"strike_price": 1.1,
			"number_of_securities": 1.1,
			"prospectus_url": "test",
			"expiration_date": "test",
			"name": "test",
			"sector": "test",
			"sector_group": "test",
			"underlyings": [{
				"instrument_id": 123,
				"symbol": "test",
				"isin_code": "test"
			}]
		},
		"qty": 1.1,
		"pawn_percent": 1.1,
		"market_value_acc": {
			"value": 1.1,
			"currency": "test"
		},
		"market_value": {
			"value": 1.1,
			"currency": "test"
		},
		"acq_price": {
			"value": 1.1,
			"currency": "test"
		},
		"acq_price_acc": {
			"value": 1.1,
			"currency": "test"
		},
		"morning_price": {
			"value": 1.1,
			"currency": "test"
		}
  }]`

	accountTradesJSON = `[{
		"accno": 123,
		"order_id": 123,
		"trade_id": "test",
		"tradable": {
			"identifier": "test",
			"market_id": 123
		},
		"price": {
			"value": 1.1,
			"currency": "test"
		},
		"volume": 1.1,
		"side": "test",
		"counterparty": "test",
		"tradetime": 123
  }]`

	countriesJSON = `[{
		"country": "test",
		"name": "test"
	}]`

	indicatorsJSON = `[{
		"name": "test",
		"src": "test",
		"identifier": "test",
		"delayed": 123,
		"only_eod": true,
		"open": "test",
		"close": "test",
		"country": "test",
		"type": "test",
		"region": "test",
		"instrument_id": 123
	}]`

	instrumentsJSON = `[{
		"instrument_id": 123,
		"tradables": [{
			"market_id": 123,
			"identifier": "test",
			"tick_size_id": 123,
			"lot_size": 1.1,
			"display_order": 123
		}],
		"currency": "test",
		"instrument_group_type": "test",
		"instrument_type": "test",
		"multiplier": 1.1,
		"symbol": "test",
		"isin_code": "test",
		"market_view": "test",
		"strike_price": 1.1,
		"number_of_securities": 1.1,
		"prospectus_url": "test",
		"expiration_date": "test",
		"name": "test",
		"sector": "test",
		"sector_group": "test",
		"underlyings": [{
			"instrument_id": 123,
			"symbol": "test",
			"isin_code": "test"
		}]
	}]`

	instrumentLeverageFiltersJSON = `{
		"issuers": [{
			"name": "test",
			"issuer_id": 123
		}],
		"market_view": ["test"],
		"expiration_dates": ["test"],
		"instrument_types": ["test"],
		"instrument_group_types": ["test"],
		"currencies": ["test"],
		"no_of_instruments": 123
	}`

	instrumentOptionPairsJSON = `[{
		"strike_price": 1.1,
		"expiration_date": "test",
		"call": {
			"instrument_id": 123,
			"tradables": [{
				"market_id": 123,
				"identifier": "test",
				"tick_size_id": 123,
				"lot_size": 1.1,
				"display_order": 123
			}],
			"currency": "test",
			"instrument_group_type": "test",
			"instrument_type": "test",
			"multiplier": 1.1,
			"symbol": "test",
			"isin_code": "test",
			"market_view": "test",
			"strike_price": 1.1,
			"number_of_securities": 1.1,
			"prospectus_url": "test",
			"expiration_date": "test",
			"name": "test",
			"sector": "test",
			"sector_group": "test",
			"underlyings": [{
				"instrument_id": 123,
				"symbol": "test",
				"isin_code": "test"
			}]
		},
		"put": {
			"instrument_id": 123,
			"tradables": [{
				"market_id": 123,
				"identifier": "test",
				"tick_size_id": 123,
				"lot_size": 1.1,
				"display_order": 123
			}],
			"currency": "test",
			"instrument_group_type": "test",
			"instrument_type": "test",
			"multiplier": 1.1,
			"symbol": "test",
			"isin_code": "test",
			"market_view": "test",
			"strike_price": 1.1,
			"number_of_securities": 1.1,
			"prospectus_url": "test",
			"expiration_date": "test",
			"name": "test",
			"sector": "test",
			"sector_group": "test",
			"underlyings": [{
				"instrument_id": 123,
				"symbol": "test",
				"isin_code": "test"
			}]
		}
	}]`

	instrumentOptionPairFiltersJSON = `{
		"expiration_dates": ["test"]
	}`

	instrumentSectorsJSON = `[{
		"sector": "test",
		"group": "test",
		"name": "test"
  }]`

	instrumentTypeJSON = `[{
		"instrument_type": "test",
		"name": "test"
  }]`

	listsJSON = `[{
		"symbol": "test",
		"display_order": 123,
		"list_id": 123,
		"name": "test",
		"country": "test",
		"region": "test"
	}]`

	loginJSON = `{
		"environment": "test",
		"session_key": "test",
		"expires_in": 123,
		"private_feed": {
			"hostname": "test",
			"port": 123,
			"encrypted": true
		},
		"public_feed": {
			"hostname": "test",
			"port": 123,
			"encrypted": true
		}
	}`

	logoutJSON = `{
		"logged_in": true
	}`

	touchJSON = logoutJSON

	marketsJSON = `[{
    "market_id": 123,
    "country": "test",
    "name": "test"
  }]`

	newsJSON = `[{
		"news_id": 123,
		"source_id": 123,
		"headline": "test",
		"instruments": [
		  123
		],
		"lang": "test",
		"type": "test",
		"timestamp": 123
  }]`

	newsItemJSON = `[{
		"news_id": 123,
		"source_id": 123,
		"headline": "test",
		"body": "test",
		"instruments": [123],
		"lang": "test",
		"type": "test",
		"timestamp": 123
	}]`

	newsSourcesJSON = `[{
		"name": "test",
		"source_id": 123,
		"level": "test",
		"countries": ["test"]
	}]`

	realtimeAccessJSON = `[{
  	"market_id": 123,
  	"level": 123
	}]`

	tickSizesJSON = `[{
		"tick_size_id": 123,
		"ticks": [{
			"decimals": 123,
			"from_price": 1.1,
			"to_price": 1.1,
			"tick": 1.1
		}]
  }]`

	tradableInfoJSON = `[{
		"market_id": 123,
		"iceberg": true,
		"calendar": [{
			"date": "test",
			"open": 123,
			"close": 123
		}],
		"order_types": [{
			"type": "test",
			"name": "test"
		}]
	}]`

	tradableIntradayJSON = `[{
		"market_id": 123,
		"identifier": "test",
		"ticks": [{
			"timestamp": 123,
			"last": 1.1,
			"low": 1.1,
			"high": 1.1,
			"volume": 1.1,
			"no_of_trades": 123
		}]
  }]`

	tradableTradesJSON = `[{
		"market_id": 123,
		"identifier": "test",
		"trades": [{
			"broker_buying": "test",
			"broker_selling": "test",
			"volume": 123,
			"price": 1.1,
			"trade_id": "test",
			"trade_type": "test",
			"trade_timestamp": 123
		}]
	}]`
)
