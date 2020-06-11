import {
  fetchTournament,
  fetchTournaments,
  fetchAllTournaments,
  fetchPastTournaments,
  fetchPaginatedTournaments,
} from '../utils/drupal';

function fetchingSelectedTournament() {
  return {
    type: 'FETCHING_SELECTED_TOURNAMENT',
  };
}

function fetchingTournaments() {
  return {
    type: 'FETCHING_TOURNAMENTS',
  };
}

function postSelectedTournament(tournament) {
  return {
    type: 'POST_SELECTED_TOURNAMENT',
    tournament,
  };
}

function postTournaments(tournaments) {
  return {
    type: 'POST_TOURNAMENTS',
    tournaments,
  };
}

export function requestSelectedTournament(id) {
  return (dispatch) => {
    dispatch(fetchingSelectedTournament());

    return fetchTournament(id)
      .then(tournament => dispatch(postSelectedTournament(tournament)));
  };
}

export function requestAllTournaments(limit) {
  return (dispatch) => {
    dispatch(fetchingTournaments());

    return fetchAllTournaments(limit)
      .then((feed) => {
        dispatch(postTournaments(feed));
      });
  };
}

export function requestPastTournaments(limit) {
  return (dispatch) => {
    dispatch(fetchingTournaments());

    return fetchPastTournaments(limit)
      .then((feed) => {
        dispatch(postTournaments(feed));
      });
  };
}

export function requestTournaments(tid) {
  return (dispatch) => {
    dispatch(fetchingTournaments());

    return fetchTournaments(tid)
      .then((feed) => {
        dispatch(postTournaments(feed));
      });
  };
}

export function paginateTournaments(url) {
  return (dispatch) => {
    dispatch(fetchingTournaments());

    return fetchPaginatedTournaments(url)
      .then((feed) => {
        dispatch(postTournaments(feed));
      });
  };
}
