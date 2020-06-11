import {
  readEndpoint,
  createResource,
  updateResource,
  deleteResource } from 'redux-json-api';

export const fetchTasks = (project) => {
  return dispatch => (dispatch(readEndpoint(`projects/${project.id}/tasks`)));
}

export const createTask = (task) => {
  return dispatch => dispatch(createResource(task));
}

export const updateTask = (task) => {
  return dispatch => dispatch(updateResource(task));
}

export const deleteTask = (task) => {
  return dispatch => dispatch(deleteResource(task));
}

export const toggleTaskStatus = (task) => {
  return dispatch => dispatch(updateResource(task));
}
