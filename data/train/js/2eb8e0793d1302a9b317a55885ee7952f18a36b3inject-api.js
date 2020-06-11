import Api from 'client/utils/api';
import sequelizeTransform from 'client/utils/sequelize-data-transform';

export default {
  name: 'api',
  after: ['data-store'],

  initialize: function (container, application) {
      application.register('api:main', Api);
      application.inject('api:main', 'store', 'store:main');
      application.inject('route', 'api', 'api:main');
      application.inject('controller', 'api', 'api:main');

      var api;
      api = container.lookup('api:main');
      api.set('keyTransforms.defalt', sequelizeTransform);
  }
};
