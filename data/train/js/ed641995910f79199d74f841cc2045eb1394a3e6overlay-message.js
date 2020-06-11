import Ember from 'ember';

/**
 * components/overlay-message.js
 * @module components
 * 
 * Display an overview message.
 * Parameter is "show" (boolean).
 * Styled using styles/components/overlay-message.styl.
 */

export default Ember.Component.extend({

  classNames: ['overlay-message'],
  classNameBindings: ['overlayMessageShow'],

  overlayMessageShow: function(){
    return !!this.get('show');
  }.property(),

  isShowChanged: function(){
    this.set('overlayMessageShow', this.get('show'));
  }.observes('show')

});
