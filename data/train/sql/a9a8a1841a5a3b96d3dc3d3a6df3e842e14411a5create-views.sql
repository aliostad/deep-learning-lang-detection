CREATE VIEW `CompanyView` AS
SELECT id, name FROM `Company`;

CREATE VIEW `LeadView` AS
SELECT `Lead`.id as id, description, create_date
FROM `Lead` JOIN `company_gets`;

CREATE VIEW `OpportunityView` AS
SELECT `Opportunity`.id description, create_date
FROM `Opportunity` JOIN `lead_becomes`;

CREATE VIEW `QuoteView` AS
SELECT `Quote`.id as id, description, create_date FROM `Quote`
JOIN `opportunity_requests`;

CREATE VIEW `ProductView` AS
SELECT `Product`.id as id, name, price
FROM `Product`;

CREATE VIEW `OrderView` AS
SELECT `Order`.id as id, description, create_date FROM `Order`
JOIN `quote_becomes`;

CREATE VIEW `CurrencyView` AS
SELECT id, name, ISO_code FROM `Currency`;
