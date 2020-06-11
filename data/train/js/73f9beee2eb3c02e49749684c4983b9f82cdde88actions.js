import { authChanged, googleSigninSource, signOut } from '../../api';
import { push } from 'react-router-redux';
import { ifElse, compose } from 'ramda';

export const types = {
	SIGNED_IN: 'SIGNED_IN',
	SIGNED_OUT: 'SIGNED_OUT',
};

export function signedIn(user) {
	return {
		type: types.SIGNED_IN,
		user,
	};
}

export function signedOut() {
	return {
		type: types.SIGNED_OUT,
	};
}

export function signin() {
	return dispatch => {
		const dispatchSignedIn = compose(dispatch, signedIn);
		const redirectToRoot = () => dispatch(push('/'));

		googleSigninSource.do(dispatchSignedIn).subscribe(redirectToRoot);
	};
}

export function listenForAuth() {
	return dispatch => {
		const dispatchSignedIn = compose(dispatch, signedIn);

		const dispatchSignedOut = compose(dispatch, signedOut);
		const redirectToSignin = () => dispatch(push('/signin'));
		const handleSignout = compose(redirectToSignin, dispatchSignedOut);

		return authChanged.subscribe(
			ifElse(Boolean, dispatchSignedIn, handleSignout)
		);
	};
}

export function signout() {
	return () => signOut.subscribe();
}
