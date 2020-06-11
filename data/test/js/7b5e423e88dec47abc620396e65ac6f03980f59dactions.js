import store from './resources'

export const campaignsCommit = (site_ob) => {
  store.dispatch('CAMPAIGNS_COMMIT', site_ob, 'campaigns')
}

export const campaignsSet = (sites) => {
  store.dispatch('CAMPAIGNS_SET', sites, 'campaigns')
}

export const campaignsDelete = (site) => {
	store.dispatch('CAMPAIGNS_DELETE', site, 'campaigns')
}

export const campaignsFetch = () => {
	store.dispatch('CAMPAIGNS_FETCH', 'campaigns')
}

export const charactersCommit = (site_ob) => {
  store.dispatch('CHARACTERS_COMMIT', site_ob, 'characters')
}

export const charactersSet = (sites) => {
  store.dispatch('CHARACTERS_SET', sites, 'characters')
}

export const charactersDelete = (site) => {
	store.dispatch('CHARACTERS_DELETE', site, 'characters')
}

export const charactersFetch = () => {
	store.dispatch('CHARACTERS_FETCH', 'characters')
}

export const groupsCommit = (site_ob) => {
  store.dispatch('GROUPS_COMMIT', site_ob, 'groups')
}

export const groupsSet = (sites) => {
  store.dispatch('GROUPS_SET', sites, 'groups')
}

export const groupsDelete = (site) => {
	store.dispatch('GROUPS_DELETE', site, 'groups')
}

export const groupsFetch = () => {
	store.dispatch('GROUPS_FETCH', 'groups')
}

export const sessionsCommit = (site_ob) => {
  store.dispatch('SESSIONS_COMMIT', site_ob, 'sessions')
}

export const sessionsSet = (sites) => {
  store.dispatch('SESSIONS_SET', sites, 'sessions')
}

export const sessionsDelete = (site) => {
	store.dispatch('SESSIONS_DELETE', site, 'sessions')
}

export const sessionsFetch = () => {
	store.dispatch('SESSIONS_FETCH', 'sessions')
}

export const usersCommit = (site_ob) => {
  store.dispatch('USERS_COMMIT', site_ob, 'users')
}

export const usersSet = (sites) => {
  store.dispatch('USERS_SET', sites, 'users')
}

export const usersDelete = (site) => {
	store.dispatch('USERS_DELETE', site, 'users')
}

export const usersFetch = () => {
	store.dispatch('USERS_FETCH', 'users')
}
