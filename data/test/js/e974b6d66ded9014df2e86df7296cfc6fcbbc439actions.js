import { createAction } from 'redux-actions';

import {
  readEndpoint,
  createResource,
  updateResource,
  deleteResource } from 'redux-json-api';

import {
  PROJECT_LIST_REQUEST,
  PROJECT_LIST_SUCCESS } from './constants';

const requestProjectList = createAction(PROJECT_LIST_REQUEST);
const receiveProjectList = createAction(PROJECT_LIST_SUCCESS);

export const fetchProjects = () => {
  return dispatch => {
    dispatch(requestProjectList());
    dispatch(readEndpoint('projects')).then(() => {
      dispatch(receiveProjectList());
    });
  }
}

export const createProject = (entity) => {
  return dispatch => dispatch(createResource(entity));
}

export const updateProject = (entity) => {
  return dispatch => dispatch(updateResource(entity));
}

export const deleteProject = (entity) => {
  return dispatch => dispatch(deleteResource(entity));
}
