IF OBJECT_ID('PricingModelScenarios') IS NULL
BEGIN
	CREATE TABLE PricingModelScenarios
	(
		ScenarioId INT
	   ,ScenarioName VARCHAR(50)
	   ,ConfigName VARCHAR(50)
	   ,ConfigValue DECIMAL(18,6)
	)
END  
GO

IF NOT EXISTS (SELECT 1 FROM PricingModelScenarios WHERE ScenarioName = 'Basic')
BEGIN
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'TenurePercents', '0.5')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'SetupFee', '0.015')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'ProfitMarkupPercentsOfRevenue', '0.25')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'OpexAndCapex', '150')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'InterestOnlyPeriod', '0')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'EuCollectionRate', '0.75')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'DefaultRateCompanyShare', '0.7')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'DebtPercentOfCapital', '0.6')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'CostOfDebtPA', '0.16')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'CollectionRate', '0.19')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'Cogs', '1000')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (1, 'Basic', 'BrokerSetupFee', '0')
END
GO

IF NOT EXISTS (SELECT 1 FROM PricingModelScenarios WHERE ScenarioName = 'Broker')
BEGIN
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'TenurePercents', '0.5')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'SetupFee', '0.015')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'ProfitMarkupPercentsOfRevenue', '0.25')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'OpexAndCapex', '150')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'InterestOnlyPeriod', '0')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'EuCollectionRate', '0.75')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'DefaultRateCompanyShare', '0.7')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'DebtPercentOfCapital', '0.6')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'CostOfDebtPA', '0.16')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'CollectionRate', '0.19')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'Cogs', '1000')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (2, 'Broker', 'BrokerSetupFee', '0')
END
GO

IF NOT EXISTS (SELECT 1 FROM PricingModelScenarios WHERE ScenarioName = 'Small Loan')
BEGIN
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'TenurePercents', '0.5')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'SetupFee', '0.015')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'ProfitMarkupPercentsOfRevenue', '0.25')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'OpexAndCapex', '150')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'InterestOnlyPeriod', '0')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'EuCollectionRate', '0.75')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'DefaultRateCompanyShare', '0.7')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'DebtPercentOfCapital', '0.6')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'CostOfDebtPA', '0.16')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'CollectionRate', '0.19')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'Cogs', '1000')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (3, 'Small Loan', 'BrokerSetupFee', '0')
END
GO


IF NOT EXISTS (SELECT 1 FROM PricingModelScenarios WHERE ScenarioName = 'Non-ltd')
BEGIN
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'TenurePercents', '0.5')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'SetupFee', '0.015')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'ProfitMarkupPercentsOfRevenue', '0.25')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'OpexAndCapex', '150')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'InterestOnlyPeriod', '0')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'EuCollectionRate', '0.75')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'DefaultRateCompanyShare', '0.7')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'DebtPercentOfCapital', '0.6')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'CostOfDebtPA', '0.16')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'CollectionRate', '0.19')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'Cogs', '1000')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (4, 'Non-ltd', 'BrokerSetupFee', '0')
END
GO

IF NOT EXISTS (SELECT 1 FROM PricingModelScenarios WHERE ScenarioName = 'Sole Traders')
BEGIN
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'TenurePercents', '0.5')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'SetupFee', '0.015')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'ProfitMarkupPercentsOfRevenue', '0.25')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'OpexAndCapex', '150')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'InterestOnlyPeriod', '0')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'EuCollectionRate', '0.75')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'DefaultRateCompanyShare', '0.7')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'DebtPercentOfCapital', '0.6')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'CostOfDebtPA', '0.16')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'CollectionRate', '0.19')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'Cogs', '1000')
	INSERT INTO PricingModelScenarios (ScenarioId, ScenarioName, ConfigName, ConfigValue) 
		VALUES (5, 'Sole Traders', 'BrokerSetupFee', '0')
END
GO

DELETE FROM ConfigurationVariables WHERE Name IN (
	'PricingModelTenurePercents',
	'PricingModelSetupFee',
	'PricingModelProfitMarkupPercentsOfRevenue',
	'PricingModelOpexAndCapex',
	'PricingModelInterestOnlyPeriod',
	'PricingModelEuCollectionRate',
	'PricingModelDefaultRateCompanyShare',
	'PricingModelDebtOutOfTotalCapital',
	'PricingModelCostOfDebtPA',
	'PricingModelCollectionRate',
	'PricingModelCogs',
	'PricingModelBrokerSetupFee')
GO

