namespace Customers


module HttpAdapter =
    let index = """<!DOCTYPE html>
<html>
<head>
    <title>Customer service</title>
    <meta charset="utf-8" />
</head>
<body>
Copy of 
<a href="http://www.galasoft.ch/labs/Customers/CustomerService.svc">galasoft CustomerService</a>
used in order to demonstrate mvvm.
You can mock implementation of the api here:
  <a href="/CustomerService.svc">Customer service</a>.
</body>
</html>"""
    
    let GetAllCustomers (c: ICustomerService) = 
        Serializer.serialize(c.GetAllCustomers())
        
    let SaveCustomer (c: ICustomerService) rawForm =
        Serializer.serialize(c.SaveCustomers(Serializer.deserialize(rawForm)))
    
    

