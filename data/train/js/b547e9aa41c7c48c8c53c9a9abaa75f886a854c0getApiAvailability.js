const api_reset_times = require('./api_reset_times')
const getApiLimitedAts = require('./getApiLimitedAts')

module.exports = function getApiAvailability(api) {
  return getApiLimitedAts().then((api_limited_ats) => {
    api.limited_at = api_limited_ats[api.name] ? new Date(api_limited_ats[api.name]) : null
    if (!api.opened_at || Date.now() - api.opened_at > api.window_ms) {
      api.opened_at = Date.now()
      return true
    }
    if (!api.limited_at) {
      return true
    }
    if (api.limited_at > api.opened_at) {
      return false
    }
    return true
  })
}
