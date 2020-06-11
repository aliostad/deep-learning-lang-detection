/**
 * Copyright (C) 2017 TopCoder Inc., All Rights Reserved.
 */

/**
 * the Post Routes
 *
 * @author      TCSCODER
 * @version     1.0
 */

const Auth = require('../common/Auth');

module.exports = {
  '/posts': {
    get: {
      controller: 'PostController',
      method: 'search',
    },
    post: {
      controller: 'PostController',
      method: 'create',
      middleware: [Auth()],
    },
  },
  '/posts/:id': {
    put: {
      controller: 'PostController',
      method: 'update',
      middleware: [Auth()],
    },
    get: {
      controller: 'PostController',
      method: 'get',
    },
    delete: {
      controller: 'PostController',
      method: 'remove',
      middleware: [Auth()],
    },
  },
  '/posts/:id/email': {
    get: {
      controller: 'PostController',
      method: 'email',
      middleware: [Auth()],
    },
  },
  '/posts/:id/upload': {
    post: {
      controller: 'PostController',
      method: 'upload',
      middleware: [Auth()],
    },
  },
  '/posts/:techUserId/recommended': {
    get: {
      controller: 'PostController',
      method: 'recommended',
      middleware: [Auth()],
    },
  },
  '/count/posts': {
    get: {
      controller: 'PostController',
      method: 'getCountByFilter',
      middleware: [Auth()],
    },
  },
};
