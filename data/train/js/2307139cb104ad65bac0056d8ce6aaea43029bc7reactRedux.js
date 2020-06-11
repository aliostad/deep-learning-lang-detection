import {
  fetchResource,
  addResource,
  createResource,
  patchResource,
  destroyResource,
  } from '../ducks/resource';

import {
  setSession,
  closeSession,
  } from '../ducks/session';

import {
  addDefinition,
  } from '../ducks/definition';

export function mapDispatchToProps(dispatch) {
  return {
    fetch: payload => dispatch(fetchResource(payload)),
    add: payload => dispatch(addResource(payload)),
    create: payload => dispatch(createResource(payload)),
    destroy: payload => dispatch(destroyResource(payload)),
    patch: payload => dispatch(patchResource(payload)),
    setSession: payload => dispatch(setSession(payload)),
    closeSession: payload => dispatch(closeSession(payload)),
  };
}
