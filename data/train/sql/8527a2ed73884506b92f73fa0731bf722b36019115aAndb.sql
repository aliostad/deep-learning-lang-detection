CREATE VIEW salesView as
	SELECT salesOrder.orderId as 'Order Id', customer.customerId as 'Customer Id', 
companyContactName as 'Customer Contact Name', 
customerType.typeDescription as 'Customer Type Description',
salesperson.salespersonName as 'SalesPerson Name', salesCompany.companyName as 'Salesperson Company Name'
FROM salesOrder,customer,customerType, salesperson,salesCompany
	WHERE customer.customerId=salesOrder.customerId and
		  customer.customerTypeId = customerType.customerTypeId and
		  salesOrder.salespersonNo = salesperson.salespersonNo and
		  salesperson.companyId = salesCompany.companyId;

CREATE VIEW salesView as
	SELECT salesOrder.orderId, customer.customerId, 
companyContactName, 
customerType.typeDescription,
salesperson.salespersonName, salesCompany.companyName
FROM salesOrder,customer,customerType, salesperson,salesCompany
	WHERE customer.customerId=salesOrder.customerId and
		  customer.customerTypeId = customerType.customerTypeId and
		  salesOrder.salespersonNo = salesperson.salespersonNo and
		  salesperson.companyId = salesCompany.companyId;
