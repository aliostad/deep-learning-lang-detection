<?php


class Action_RemoveCoupon extends Action {

	public function __construct(Controller $controller)
	{
		parent::__construct($controller);

		// suppression des info sauvegard�s
		//SaveRegisterOrderInfo::removeInfo();

		$panier = Panier::getInstance();
		$panier->removeCoupon();
		unset($this->_params->inputOrderCoupon);

		// sauvegarde des parametres
		SaveRegisterOrderInfo::saveInfoRegistration();
		SaveRegisterOrderInfo::saveInfoRegistrationLivraison();
		SaveRegisterOrderInfo::saveInfoOrder();
	}
}
