describe('emp3.api.MapService', function() {
  describe('constructor', function() {
    it ('handles no params', function() {
      var service = new emp3.api.MapService();
      service.should.exist;
      service.should.have.property('geoId');
      service.should.have.property('url');
      service.should.have.property('name');
      service.should.have.property('description');
    });

    it('handles valid params', function() {
      var args = {
        name: 'NASA Worldwind service',
        url: 'http://worldwind25.arc.nasa.gov/wms'
      };

      var service = new emp3.api.MapService(args);

      service.url.should.equal(args.url);
      service.name.should.equal(args.name);
    });
  });
});
