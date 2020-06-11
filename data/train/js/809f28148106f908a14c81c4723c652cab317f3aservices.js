describe('Service: streamService', function () {
  var streamService;
  beforeEach(module('realtime'));
  beforeEach(inject(function (_streamService_) {
    streamService = _streamService_;
  }));

  it('listens for events only once', function () {
    streamService.listen('twitter');
    var isSaved = streamService.listen('twitter');
    expect(isSaved).toBe(false);
  });
});

describe('Service: dataService', function () {
  var dataService;

  beforeEach(function () {
    module('realtime');
    module('ngMap');
  });

  beforeEach(inject(function (_dataService_) {
    dataService = _dataService_;
  }));

  it('clears all arrays', function () {
    dataService.clearAll();
    expect(dataService.data.length).toEqual(0);
    expect(dataService.latLngs.length).toEqual(0);
  });
});
