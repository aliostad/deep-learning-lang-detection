
#include "Data/AbonentsModel.h"
#include "Data/BillingModel.h"
#include "logic/InputController.h"

#define _CRT_SECURE_NO_DEPRECATE // disable annoying warning in utils::getJson for fopen func

int main (int argc, char* argv[])
{
	//init model singleton
	AbonentsModel* ab_model = AbonentsModel::getInstance();
	BillingModel* billing_model = BillingModel::getInstance();
	//all data was loaded successfully
	if (ab_model->init() && billing_model->init())
	{
		InputController controller;
		controller.init();
	}

	delete ab_model;
	delete billing_model;

	return 0;
}
