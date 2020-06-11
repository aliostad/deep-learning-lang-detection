#ifndef IPLISTDAO_H_
#define IPLISTDAO_H_

#include <iostream>
#include <list>
#include "../AppDAO/DAOBase.h"
#include "../AppModel/IPListModel.h"
#include "SQLite/SQLite.h"
using namespace std;

class IPListDAO : public DAOBase
{
public:
	IPListDAO(SQLite &db);
	~IPListDAO();
	int insert(IPListModel model);
	IPListModel findByID(int id);
	list<IPListModel> findBy(IPListModel model);
	bool deleteByID(int id);
	bool deleteByModel(IPListModel model);
	bool update(IPListModel model);

private:
	SQLite &db;
};

#endif
