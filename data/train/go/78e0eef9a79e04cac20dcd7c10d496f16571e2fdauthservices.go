package services

import (
	bll "mytest/bll/auth"
	"mytest/dal"
)

// AuthServices Implement
type AuthServices struct{}

// FacebookAuthManager Implement
func (a *AuthServices) FacebookAuthManager(rep dal.IFacebookAuthRepository) bll.IFacebookAuthManager {
	var b bll.IFacebookAuthManager
	f := bll.FacebookAuthManager{Rep: rep}
	b = &f
	return b
}

// LocalAuthManager Implement
func (a *AuthServices) LocalAuthManager(rep dal.ILocalAuthRepository) bll.ILocalAuthManager {
	var b bll.ILocalAuthManager
	f := bll.LocalAuthManager{Rep: rep}
	b = &f
	return b
}
