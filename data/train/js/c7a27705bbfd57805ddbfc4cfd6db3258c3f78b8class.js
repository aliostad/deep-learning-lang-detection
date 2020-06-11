import { showError } from './util';

import api from '../api';
import F from '../util/f';

export const getClass = (classId) => (dispatch) => api.getClass(classId)
  .then(res => dispatch({ type: 'class:set', clazz: res.data }))
  .catch(res => {
    if (res.status === 404) {
      return showError(F.map(res.data, d => d.code), 'クラスが見つかりませんでした。')(dispatch);
    } else {
      return showError(F.map(res.data, d => d.code))(dispatch);
    }
  });

export const clearClass = (dispatch) => {
  dispatch({ type: 'class:clear' });
  return Promise.resolve(true);
};

export const getReviews = (classId) => (dispatch) => api.getReviews(classId)
  .then(res => {
    dispatch({ type: 'class:reviews:set', items: res.data, of: classId });
    return true;
  })
  .catch(res => {
    return showError(F.map(res.data, d => d.code))(dispatch);
  });

export const clearReviews = (dispatch) => {
  dispatch({ type: 'class:reviews:clear' });
  return Promise.resolve(true);
};

export const getClassArticles = (classId) => (dispatch) => api.getClassArticles(classId)
  .then(res => {
    dispatch({ type: 'class:articles:set', items: res.data, of: classId });
    return true;
  })
  .catch(res => {
    return showError(F.map(res.data, d => d.code))(dispatch);
  });

export const clearClassArticles = (dispatch) => {
  dispatch({ type: 'class:articles:clear' });
  return Promise.resolve(true);
};

export const getClassArticle = (id) => (dispatch) => api.getClassArticle(id)
  .then(res => {
    dispatch({ type: 'class:article:set', article: res.data });
    return true;
  })
  .catch(res => {
    return showError(F.map(res.data, d => d.code))(dispatch);
  });

export const clearClassArticle = (dispatch) => {
  dispatch({ type: 'class:article:clear' });
  return Promise.resolve(true);
};

export const getClassResources = (classId) => (dispatch) => api.getClassResources(classId)
  .then(res => {
    dispatch({ type: 'class:resources:set', items: res.data, of: classId });
    return true;
  })
  .catch(res => {
    return showError(F.map(res.data, d => d.code))(dispatch);
  });

export const clearClassResources = (dispatch) => {
  dispatch({ type: 'class:resources:clear' });
  return Promise.resolve(true);
};

export const getClassResource = (id) => (dispatch) => api.getClassResource(id)
  .then(res => {
    dispatch({ type: 'class:resource:set', resource: res.data });
    return true;
  })
  .catch(res => {
    return showError(F.map(res.data, d => d.code))(dispatch);
  });

export const clearClassResource = (dispatch) => {
  dispatch({ type: 'class:resource:clear' });
  return Promise.resolve(true);
};

export const getImages = (classId, offset = 0) => (dispatch) => api.getImages(classId, offset)
  .then(res => dispatch({ type: 'class:images:append', items: res.data, of: classId }))
  .catch(res => {
    return showError(F.map(res.data, d => d.code), '画像情報を取得できませんでした。')(dispatch);
  });

export const clearImages = (dispatch) => {
  dispatch({ type: 'class:images:clear' });
  return Promise.resolve(true);
};
