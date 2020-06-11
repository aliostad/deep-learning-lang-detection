'use strict';

describe('Service: storyService', function () {

  // load the service's module
  beforeEach(module('storyboardApp'));

  // instantiate service
  var storyService;
  beforeEach(inject(function (_storyService_) {
    storyService = _storyService_;
  }));

  it('should add a story to the service', function () {
    storyService.addStory({title: "New story", description: "description", points: "4"});
    expect(storyService.stories().length).toBe(1);
    expect(storyService.stories()[0].points).toBe(4);
  });

});
