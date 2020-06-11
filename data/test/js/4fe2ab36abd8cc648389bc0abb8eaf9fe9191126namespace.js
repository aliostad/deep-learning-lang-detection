"use strict";

var assert = require("assert"),
  Pregister = require('../index.js');

describe('Namespace', function() {

  it('should mix namespace with file', function () {
    assert.equal(Pregister.file2namespace('service/db/index.js', 'service'), 'service.db');
    assert.equal(Pregister.file2namespace('service/db/index.js', 'service.db'), 'service.db');
    assert.equal(Pregister.file2namespace('root/service/db/index.js', 'service.db'), 'service.db');
    assert.equal(Pregister.file2namespace('root/service/db.js', 'service.db'), 'service.db');
    assert.equal(Pregister.file2namespace('/root/service/db.js', 'service.db'), 'service.db');
    assert.equal(Pregister.file2namespace('/root/service/db.js', 'service'), 'service.db');

    assert.equal(Pregister.file2namespace('service/dbservice/index.js', 'service'), 'service.dbservice');
    assert.equal(Pregister.file2namespace('root/dbservice/index.js', 'service'), 'service.root.dbservice');
    assert.equal(Pregister.file2namespace('/root/dbservice/db.js', 'service'), 'service.root.dbservice.db');
  });
});