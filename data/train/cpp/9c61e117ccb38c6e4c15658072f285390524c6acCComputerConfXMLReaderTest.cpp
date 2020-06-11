#include "CRefreshProgressModelTest.h" 
#include <Main/Data/RefreshProgressModel.h>
#include <string>

void CRefreshProgressModelTest::init()
{
	m_ptrModel = new RefreshProgressModel;
}
void CRefreshProgressModelTest::cleanup()
{
	delete m_ptrModel;
}
void CRefreshProgressModelTest::testRowCount()
{
	QModelIndex stIndex;
	QCOMPARE(m_ptrModel->rowCount(stIndex),0);
	m_ptrModel->addShopEntry("Proline");
	QCOMPARE(m_ptrModel->rowCount(stIndex),1);
	m_ptrModel->addShopEntry("Komputronik");
	QCOMPARE(m_ptrModel->rowCount(stIndex),2);
}
void CRefreshProgressModelTest::testRowRemoval()
{
	return;
	QCOMPARE(m_ptrModel->rowCount(),0);
	m_ptrModel->insertRow(m_ptrModel->rowCount());
	m_ptrModel->insertRow(m_ptrModel->rowCount());
	m_ptrModel->insertRow(m_ptrModel->rowCount());
	m_ptrModel->insertRow(m_ptrModel->rowCount());
	QCOMPARE(m_ptrModel->rowCount(),5);
	m_ptrModel->removeRows(0,1);
	QCOMPARE(m_ptrModel->rowCount(),4);
	m_ptrModel->removeRows(2,1);
	QCOMPARE(m_ptrModel->rowCount(),3);
	m_ptrModel->removeRows(0,m_ptrModel->rowCount()+5);
	QCOMPARE(m_ptrModel->rowCount(),0);
}

void CRefreshProgressModelTest::testColumnCount()
{
	return;
	QCOMPARE(m_ptrModel->columnCount(),0);
	//m_ptrModel->addShopComponent("Proline");
	QCOMPARE(m_ptrModel->columnCount(),2);
	m_ptrModel->insertColumn(m_ptrModel->columnCount());
	QCOMPARE(m_ptrModel->columnCount(),3);
}
void CRefreshProgressModelTest::testColumnRemoval()
{
	return;
	QCOMPARE(m_ptrModel->columnCount(),0);
	m_ptrModel->insertColumn(m_ptrModel->columnCount());
	m_ptrModel->insertColumn(m_ptrModel->columnCount());
	m_ptrModel->insertColumn(m_ptrModel->columnCount());
	m_ptrModel->insertColumn(m_ptrModel->columnCount());
	QCOMPARE(m_ptrModel->columnCount(),5);
	m_ptrModel->removeColumns(0,1);
	QCOMPARE(m_ptrModel->columnCount(),4);
	m_ptrModel->removeColumns(2,1);
	QCOMPARE(m_ptrModel->columnCount(),3);
	m_ptrModel->removeColumns(0,m_ptrModel->columnCount()+5);
	QCOMPARE(m_ptrModel->columnCount(),0);
}
