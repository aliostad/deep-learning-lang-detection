#ifndef OSTEMPLATEDAO_H_
#define OSTEMPLATEDAO_H_

#include <iostream>
#include <list>
#include "../AppDAO/DAOBase.h"
#include "../AppModel/OSTemplateModel.h"
#include "SQLite/SQLite.h"
using namespace std;

class OSTemplateDAO : public DAOBase
{
public:
	OSTemplateDAO(SQLite &db);
	~OSTemplateDAO();
	int insert(OSTemplateModel model);
	OSTemplateModel findByID(int id);
	list<OSTemplateModel> findBy(OSTemplateModel model);
	bool deleteByID(int id);
	bool deleteByModel(OSTemplateModel model);
	bool update(OSTemplateModel model);

private:
	SQLite &db;
};

#endif
