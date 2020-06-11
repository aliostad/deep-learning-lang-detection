import {
  moduleFor,
  test
} from 'ember-qunit';

moduleFor('controller:edit', {
    needs: [ 'controller:notes', 'controller:categories' ]
});

test('setDefaults will reset all properties to their default values', function (assert) {
    assert.expect(4);

    var controller = this.subject();

    controller.set('selectedCategory', {id: 1});
    controller.set('title', 'some title');
    controller.set('text', 'some text');
    controller.set('selectedColor', 'green');

    controller.setDefaults();

    assert.equal(controller.get('selectedCategory'), null);
    assert.equal(controller.get('title'), '');
    assert.equal(controller.get('text'), '');
    assert.equal(controller.get('selectedColor'), 'gray');
});
