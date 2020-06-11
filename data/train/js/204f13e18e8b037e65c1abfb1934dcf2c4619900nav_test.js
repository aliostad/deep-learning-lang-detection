/*global describe, beforeEach, it, browser, expect */
'use strict';

var buildConfigFile = require('findup-sync')('build.config.js')
  , buildConfig = require(buildConfigFile)
  , NavPagePo = require('./nav.po');

describe('Nav page', function () {
  var navPage;

  beforeEach(function () {
    navPage = new NavPagePo();
    browser.driver.get(buildConfig.host + ':' + buildConfig.port + '/#/nav');
  });

  it('should say NavCtrl', function () {
    expect(navPage.heading.getText()).toEqual('nav');
    expect(navPage.text.getText()).toEqual('NavCtrl');
  });
});
