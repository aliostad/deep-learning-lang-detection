#include "user.h"

UserModel::UserModel(){
	ID = 0;
	name = "";
	udid = "";
	totalTime = 0;
	totalDistance = 0;
	armour = new PowersModel();
	gunPowder = new PowersModel();
	gunRecoil = new PowersModel();
	forceField = new PowersModel();
	noReload = new PowersModel();
	invincible = new PowersModel();
	bribeACop = new PowersModel();
	bribeADeveloper = new PowersModel();
	pullAHoudini = new PowersModel();
	prepareModel();
}

UserModel::~UserModel(){
	if(armour) delete armour;
	if(gunPowder) delete gunPowder;
	if(gunRecoil) delete gunRecoil;
	if(forceField) delete forceField;
	if(noReload) delete noReload;
	if(invincible) delete invincible;
	if(bribeACop) delete bribeACop;
	if(bribeADeveloper) delete bribeADeveloper;
	if(pullAHoudini) delete pullAHoudini;
}

void UserModel::modelMeta(){
	bindModelAttribute("id", ID);
	bindModelAttribute("name", name);
	bindModelAttribute("udid", udid);
	bindModelAttribute("total_time", totalTime);
	bindModelAttribute("total_distance", totalDistance);
	bindModelAttribute("armour", (Model *)armour, "powers");
	bindModelAttribute("gun_powder", (Model *)gunPowder, "powers");
	bindModelAttribute("gun_recoil", (Model *)gunRecoil, "powers");
	bindModelAttribute("force_field", (Model *)forceField, "powers");
	bindModelAttribute("no_reload", (Model *)noReload, "powers");
	bindModelAttribute("invincible", (Model *)invincible, "powers");
	bindModelAttribute("bribe_a_cop", (Model *)bribeACop, "powers");
	bindModelAttribute("bribe_a_developer", (Model *)bribeADeveloper, "powers");
	bindModelAttribute("pull_a_houdini", (Model *)pullAHoudini, "powers");
	setModelMetaKey("id");
	setModelMetaTableName("user");
}