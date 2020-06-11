import '../../../polyfills/fetch'

export const fetchCampaign = (dispatch) => (uid) => {
  dispatch({
    type: 'FETCH_CAMPAIGN',
    payload: { uid }
  })

  return global.fetch(`${process.env.SUPPORTER_URL}/api/v2/campaigns/${uid}.json`)
    .then((response) => response.json())
    .then((json) => {
      receiveCampaignSuccess(dispatch)(uid, json)
    })
    .catch((err) => {
      receiveCampaignFailure(dispatch)(uid, err)
      return Promise.reject(err)
    })
}

export const receiveCampaignFailure = (dispatch) => (uid, error) => {
  dispatch({
    type: 'RECEIVE_CAMPAIGN_FAILURE',
    payload: {
      uid,
      error
    }
  })
}

export const receiveCampaignSuccess = (dispatch) => (uid, data) => {
  dispatch({
    type: 'RECEIVE_CAMPAIGN_SUCCESS',
    payload: {
      uid,
      data
    }
  })
}
