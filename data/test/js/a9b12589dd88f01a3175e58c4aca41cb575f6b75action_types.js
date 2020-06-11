var keyMirror = require('utils/key_mirror')

module.exports = keyMirror({
  API_INJECT_ENTITY: null,

  API_ENTITY_FETCH_START: null,
  API_ENTITY_FETCH_SUCCESS: null,
  API_ENTITY_FETCH_FAIL: null,

  API_ENTITY_PERSIST_START: null,
  API_ENTITY_PERSIST_SUCCESS: null,
  API_ENTITY_PERSIST_FAIL: null,

  API_ENTITY_DELETE_START: null,
  API_ENTITY_DELETE_SUCCESS: null,
  API_ENTITY_DELETE_FAIL: null,

  FLUSH_ENTITY_STORE: null,

  // actions for stubbing api
  API_STUB_ENTITY: null,
  SET_API_STUB_TIMEOUT: null,
  API_RESTORE_ENTITY_STUB: null,
});
