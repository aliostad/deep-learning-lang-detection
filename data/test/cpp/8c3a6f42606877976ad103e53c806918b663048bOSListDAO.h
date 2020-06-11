#ifndef OSLISTDAO_H_
#define OSLISTDAO_H_

#include <iostream>
#include <list>
#include "../AppDAO/DAOBase.h"
#include "../AppModel/OSListModel.h"
#include "SQLite/SQLite.h"
using namespace std;

class OSListDAO : public DAOBase
{
public:
	OSListDAO(SQLite &db);
	~OSListDAO();
	int insert(OSListModel model);
	OSListModel findByID(int id);
	list<OSListModel> findBy(OSListModel model);
	bool deleteByID(int id);
	bool deleteByModel(OSListModel model);
	bool update(OSListModel model);

private:
	SQLite &db;
};

#endif
