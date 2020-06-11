import { fetchJSON } from '../utils/helper';
import { fetchArticles, fetchAllArticles, fetchArticlesByTeam, fetchArticlesByTeams } from '../utils/drupal';

function fetchingArticles() {
  return {
    type: 'FETCHING_ARTICLES',
  };
}

function postArticles(articles) {
  return {
    type: 'POST_ARTICLES',
    articles: {
      ...articles,
      status: 'posted',
    },
  };
}

export function requestAllArticles() {
  return (dispatch) => {
    dispatch(fetchingArticles());

    return fetchAllArticles()
      .then((articles) => {
        dispatch(postArticles(articles));
      });
  };
}

export function requestArticles(tid) {
  return (dispatch) => {
    dispatch(fetchingArticles());

    return fetchArticles(tid)
      .then((articles) => {
        dispatch(postArticles(articles));
      });
  };
}

export function requestArticlesByTeam(id) {
  return (dispatch) => {
    dispatch(fetchingArticles());

    return fetchArticlesByTeam(id)
      .then((articles) => {
        dispatch(postArticles(articles));
      });
  };
}

export function requestArticlesByTeams(ids) {
  return (dispatch) => {
    dispatch(fetchingArticles());

    return fetchArticlesByTeams(ids)
      .then((articles) => {
        dispatch(postArticles(articles));
      });
  };
}

export function paginateArticles(url) {
  return (dispatch) => {
    dispatch(fetchingArticles());

    return fetchJSON(url)
      .then((data) => {
        dispatch(postArticles(data));
      });
  };
}
