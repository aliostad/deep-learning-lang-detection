import Ember from 'ember';
import '../libs/i18n/ember-overrides';

import {t} from '../helpers/t';

Ember.Handlebars.registerHelper('t', t);

export function initialize(container, application) {
  application.inject('route', 'i18nService', 'service:i18n');
  application.inject('model', 'i18nService', 'service:i18n');
  application.inject('controller', 'i18nService', 'service:i18n');
  application.inject('view', 'i18nService', 'service:i18n');
  application.inject('component', 'i18nService', 'service:i18n');
}

export default {
  name:       'i18n-service',
  initialize: initialize
};
