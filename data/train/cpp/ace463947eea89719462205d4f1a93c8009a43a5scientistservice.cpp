#include "scientistservice.h"
#include "scientist.h"

ScientistService::ScientistService()
{
    scientistRepo = ScientistRepository();
}

void ScientistService::add()
{
    scientistRepo.add();
}

void ScientistService::read(){

    scientistRepo.read();
}

/*void ScientistService::print(){


   scientistRepo.print();

}*/

void ScientistService::find(){

    scientistRepo.find();

}

void ScientistService::write(){

    scientistRepo.write();
}

void ScientistService::READ(){

    scientistRepo.READ();
}

void ScientistService::Sort(){

    scientistRepo.Sort();

}
void ScientistService::stringToLower(std::string& finding){

    scientistRepo.stringToLower(finding);

}
