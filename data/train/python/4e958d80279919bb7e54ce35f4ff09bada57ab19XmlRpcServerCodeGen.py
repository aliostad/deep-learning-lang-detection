from SimpleXMLRPCServer import SimpleXMLRPCServer, SimpleXMLRPCRequestHandler


def create_certificate():
    intkey = 324521
    print 'Request generate code',intkey
    return ('http://certificate.mui.com/'+str(intkey)+'.html',intkey)


def update_certificate(certnumber):
    print 'Update certificate request';
    return 0;

def save_product_name(certnumber,data):
    print 'Save Product Name, certnumber=%d,product name=%s' % (certnumber,data)
    return 0;

def save_product_type(certnumber,data):
    print 'Save Product Type, certnumber=%d,product type=%s' % (certnumber,data)
    return 0;

def save_issued_date(certnumber,data):
    print 'Save Issued date, certnumber=%d,product type=%s' % (certnumber,data)
    return 0;

def save_limit_validation_date(certnumber,data):
    print 'Save limit validation date, certnumber=%d,product type=%s' % (certnumber,data)
    return 0;

def save_company_name(certnumber,data):
    print 'Save company name, certnumber=%d,product type=%s' % (certnumber,data)
    return 0;

def save_company_address(certnumber,data):
    print 'Save company address, certnumber=%d,product type=%s' % (certnumber,data)
    return 0;



def main():
    server = SimpleXMLRPCServer(('localhost',8000),
                                requestHandler = SimpleXMLRPCRequestHandler)
    server.register_introspection_functions()
    server.register_function(create_certificate, 'create_certificate');
    server.register_function(update_certificate, 'update_certificate');
    server.register_function(save_product_name, 'save_product_name');
    server.register_function(save_product_type, 'save_product_type');
    server.register_function(save_issued_date, 'save_issued_date');
    server.register_function(save_limit_validation_date, 'save_limit_validation_date');
    server.register_function(save_company_name, 'save_company_name');
    server.register_function(save_company_address, 'save_company_address');
    print 'Xml RPC server is running..'
    server.serve_forever()

if __name__ == '__main__':
    main()
