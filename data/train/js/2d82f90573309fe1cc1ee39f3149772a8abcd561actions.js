import { usersApi, transactionsApi } from '../utils/resources';
import * as A from './actionTypes';

export const login = ({ dispatch }, email, password) => {
	usersApi.getByEmail(email)
		.then(result => result.body)
		.then(user => {
			if (user.Password === password) {
				dispatch(A.LOGIN_SUCCESS, user);
				dispatch(A.ALERT, 'info', 'Logged in');
			}
			else {
				dispatch(A.LOGIN_FAILURE);//delete?
				dispatch(A.ALERT, 'danger', 'Login failure');
			}
		})
		.catch(error => {
			console.error(error);
			dispatch(A.ALERT, 'danger', 'Login failure');
			dispatch(A.LOGIN_FAILURE);
		})
};

export const logout = ({ dispatch }) => {
	dispatch(A.LOGOUT);
	dispatch(A.ALERT, 'info', 'Logged out');
};

export const alert = ({ dispatch }, type, message) => {
	dispatch(A.ALERT, type, message);
};

export const alertDismiss = ({ dispatch }, index) => {
	dispatch(A.ALERT_DISMISS, index);
};


export const userUpdate = ({ dispatch }, user) => {
	dispatch(A.USER_UPDATE, user);
};

export const achievementListUpdate = ({ dispatch }, achievements) => {
	dispatch(A.ACHIEVEMENT_LIST_UPDATE, achievements);
};

export const achievementAward = ({ dispatch }, achievement, user) => {
	if (user.Achievements.some(e => e.ID == achievement.ID))
		return;
	user.Achievements.push(achievement);
	user.VAction += achievement.Award;
	usersApi.update(user)
		.then(() => {
			transactionsApi.save({
				FromId: 1,
				ToId: user.ID,
				Type: 'VACTION',
				Amount: achievement.Award,
				Reason: 'Achievement get: ' + achievement.Name,
				Source: '/achievements'
			});
		})
		.then(() => {
			usersApi.get({ id: localStorage.userID })//todo use state
				.then(result => { user = result.body });
		})
		.then(() => {
			dispatch(A.ALERT, 'info', 'Achievement get: ' + achievement.Name);
			dispatch(A.USER_UPDATE, user);
		});
};

export const notificationsUpdate = ({ dispatch}, notifications) => {
	dispatch(A.NOTIFICATION_UPDATE, notifications);
};