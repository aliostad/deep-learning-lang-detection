var vows = require('vows'),
    assert = require('./assert'),
    Artsy = require('../'),
    macros = require('./macros'),
    debug = require('diagnostics')('artsy:test:show');

vows.describe('artsy/show').addBatch({
  'Using node-artsy': {
    'show.get': macros.call('aca-galleries-peter-blume', {
      'should return a show': function (show) {
        assert.isObject(show);
        assert.isArray(show.artists);
        assert.isObject(show.partner);
        assert.isObject(show.location);

        debug('show.get', show);
      }
    }),
    'with partner and show': {
      'show.get': macros.call({
        partner: 'aca-galleries',
        show: 'aca-galleries-peter-blume'
      }, {
        'should return a show': function (show) {
          assert.isObject(show);
          assert.isArray(show.artists);
          assert.isObject(show.partner);
          assert.isObject(show.location);

          debug('show.get', show);
        }
      }),
      'show.artworks': macros.call({
        partner: 'aca-galleries',
        show: 'aca-galleries-peter-blume'
      }, {
        'should return artworks from the show': function (artworks) {
          assert.isArray(artworks);
          assert.ok(artworks.length);
          //
          // TODO (indexzero): More asserts.
          //
          debug('show.artworks', artworks);
        }
      }),
      'show.documents': macros.call({
        partner: 'aca-galleries',
        show: 'aca-galleries-peter-blume'
      }, {
        'should return documents from the show': function (documents) {
          assert.isArray(documents);
          assert.lengthOf(documents, 2);
          documents.forEach(function (document) {
            assert.ok(document.title.indexOf('Peter Blume') !== -1);
          });

          debug('show.documents', documents);
        }
      })
    },
    'show.images': macros.call('aca-galleries-peter-blume', {
      'should return images from the show': function (images) {
        assert.isArray(images);
        assert.ok(images.length);
        //
        // TODO (indexzero): More asserts.
        //
        debug('show.images', images);
      }
    })
  }
}).export(module);
