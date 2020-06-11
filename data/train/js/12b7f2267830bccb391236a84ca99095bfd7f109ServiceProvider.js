define([
  'automan/helpers/patterns/Factory',
  'automan/service/ServiceProviderErrors',
  'automan/service/ServiceProvider',
  '/test/fixtures/automan/helpers/patterns/abstract/FactoryItemInterface.js',
  '/test/fixtures/automan/service/abstract/ServiceInterface.js',
], function(Factory, ServiceProviderErrors, ServiceProvider, FactoryItem, Service) {
  describe('automan/service/ServiceProvider', function() {
    var serviceProvider, factory;

    beforeEach(function() {
      serviceProvider = new ServiceProvider();

      factory = new Factory();
    });

    describe('#registerFactory', function() {
      it('Should return self.', function() {
        serviceProvider.registerFactory('factory', factory).should.equal(serviceProvider);
      });

      it('Should register a factory.', function() {
        serviceProvider.registerFactory('factory', factory).has('factory').should.be.true;
      });

      it('Should thrown ServiceProviderErrors.InvalidFactory if a service is registered with implementing FactoryInterface.', function() {
        var throwMe = function() {
          serviceProvider.registerFactory('factory', {});
        };

        throwMe.should.throw(ServiceProviderErrors.InvalidFactory);
      });
    });

    describe('#registerService', function() {
      it('Should return self.', function() {
        serviceProvider.registerService(Service).should.equal(serviceProvider);
      });

      it('Should register a service.', function() {
        serviceProvider.registerService(Service).has('service').should.be.true;
      });

      it('Should thrown ServiceProviderErrors.InvalidService if a service is registered with implementing ServiceInterface.', function() {
        var throwMe = function() {
          serviceProvider.registerService({});
        };

        throwMe.should.throw(ServiceProviderErrors.InvalidService);
      });
    });

    describe('#register', function() {
      it('Should return self.', function() {
        serviceProvider.register('item', {}).should.equal(serviceProvider);
      });

      it('Should register an instanse.', function() {
        serviceProvider.register('item', {}).has('item').should.be.true;
      });
    });

    describe('#has', function() {
      it('Should determine if an object has been registered.', function() {
        serviceProvider.has('item').should.be.false;
        serviceProvider.register('item', {}).has('item').should.be.true;
      });

      it('Should determine if a factory has been registered.', function() {
        serviceProvider.has('factory').should.be.false;
        serviceProvider.registerFactory('factory', factory).has('factory').should.be.true;
      });

      it('Should determine if a factory provides required item.', function() {
        serviceProvider.registerFactory('factory', factory).has('item').should.be.false;

        factory.register(FactoryItem);

        serviceProvider.has('item').should.be.true;
      });

      it('Should determine if a service is registered.', function() {
        serviceProvider.has('service').should.be.false;
        serviceProvider.registerService(Service).has('service').should.be.true;
      });
    });

    describe('#get', function() {
      it('Should return a registered object.', function() {
        should.not.exist(serviceProvider.get('item'));

        serviceProvider.register('item', {}).get('item').should.deep.equal({});
      });
    });

    describe('#create', function() {
      it('Should create a registered service with arguments.', function() {
        should.not.exist(serviceProvider.create('service'));

        var service = serviceProvider.registerService(Service).create('service', 'key', 'value');

        service.getKey().should.equal('key');
        service.getValue().should.equal('value');
      });

      it('Should create a registered factory item with arguments.', function() {
        should.not.exist(serviceProvider.create('item'));

        factory.register(FactoryItem);

        var item = serviceProvider.registerFactory('factory', factory).create('item', 'key', 'value');

        item.getKey().should.equal('key');
        item.getValue().should.equal('value');
      });
    });
  });
});