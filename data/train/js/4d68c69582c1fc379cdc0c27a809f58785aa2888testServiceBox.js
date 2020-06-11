import ServiceBox from '../src/service-box.js';
import chai from 'chai';
const expect = chai.expect;

describe('ServiceBox', function() {
  let serviceBox;

  const service = function() {
    return Promise.resolve('Service');
  };

  const dependentService = function() {
    const serviceName = serviceBox.get('service');
    return Promise.resolve(`Dependent Service (depends on '${serviceName}')`);
  };
  dependentService.dependencies = ['service'];

  const otherService = function() {
    return Promise.resolve('Other Service');
  };
  otherService.dependencies = ['dependent-service'];

  beforeEach(function() {
    serviceBox = new ServiceBox();
  });

  it('does not allow the same service to be registered twice', function() {
    serviceBox.register('the-service', service);

    expect(() => serviceBox.register('the-service', service)).to.throw(
      'A factory with the name \'the-service\' has already been registered.'
    );
  });

  it('fails if we try to request a service that has not been registered', function() {
    expect(() => serviceBox.get('the-service')).to.throw(
      'No service called \'the-service\' has been registered.'
    );
  });

  it('fails if we try to request a service that has not been resolved', function() {
    serviceBox.register('the-service', service);

    expect(() => serviceBox.get('the-service')).to.throw(
      'The \'the-service\' service needs to be resolved before you can retrieve it.'
    );
  });

  it('can resolve a service with no dependencies', function() {
    serviceBox.register('the-service', service);

    return serviceBox.resolve(['the-service']).then(function() {
      expect(serviceBox.get('the-service')).to.equal('Service');
      expect(() => serviceBox.get('dependent-service')).to.throw(Error);
    });
  });

  it('can resolve a service with a single dependency', function() {
    serviceBox.register('service', service);
    serviceBox.register('dependent-service', dependentService);

    return serviceBox.resolve(['dependent-service']).then(function() {
      expect(serviceBox.get('service')).to.equal('Service');
      expect(serviceBox.get('dependent-service')).to.equal('Dependent Service (depends on \'Service\')');
      expect(() => serviceBox.get('other-service')).to.throw(Error);
    });
  });

  it('can resolve a service through a chain of dependencies with a partial resolve list', function() {
    serviceBox.register('service', service);
    serviceBox.register('dependent-service', dependentService);
    serviceBox.register('other-service1', otherService);
    serviceBox.register('other-service2', otherService);

    return serviceBox.resolve(['dependent-service', 'other-service1']).then(function() {
      expect(serviceBox.get('service')).to.equal('Service');
      expect(serviceBox.get('dependent-service')).to.equal('Dependent Service (depends on \'Service\')');
      expect(serviceBox.get('other-service1')).to.equal('Other Service');
      expect(() => serviceBox.get('other-service2')).to.throw(Error);
    });
  });

  it('can resolve all services', function() {
    serviceBox.register('service', service);
    serviceBox.register('dependent-service', dependentService);
    serviceBox.register('other-service1', otherService);
    serviceBox.register('other-service2', otherService);

    return serviceBox.resolveAll().then(function() {
      expect(serviceBox.get('service')).to.equal('Service');
      expect(serviceBox.get('dependent-service')).to.equal('Dependent Service (depends on \'Service\')');
      expect(serviceBox.get('other-service1')).to.equal('Other Service');
      expect(serviceBox.get('other-service2')).to.equal('Other Service');
    });
  });
});
