#include "modeltype.h"


EModelType	ModelType::m_enuModelType[MT_NUM]={
		MT_GMM,
		MT_QDA,
		MT_SVM,
        MT_MBRM
};
string names[] = {"GMM","QDA","SVM","MBRM"};
vector<string> ModelType::m_vecModelType(names,names+4);

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
ModelType::ModelType()
{
}
ModelType::~ModelType()
{
}
bool	ModelType::getAllModelType(vector<string> sModelType)
{
	if(MT_NUM<=0)
		return false;
	for(int i=0;i<MT_NUM;i++){
        sModelType.push_back(m_vecModelType[i]);
	}
	return true;
}
bool	ModelType::getAllModelType(EModelType*	eModelType)
{	
	if(MT_NUM<=0)
		return false;
	if(eModelType==NULL)
		return false;
	for(int i=0;i<MT_NUM;i++){
		eModelType[i]=m_enuModelType[i];
	}
	return true;
}
string	ModelType::getModelType(const EModelType& eModelType)
{
    string	sModelType="";

	for(int i=0;i<MT_NUM;i++){
		if(eModelType==m_enuModelType[i]){
            sModelType=m_vecModelType[i];
			break;
		}
	}
	return	sModelType;
}
EModelType	ModelType::getModelType(const string& sModelType)
{
	EModelType	eModelType=MT_UNKNOWN;

	for(int i=0;i<MT_NUM;i++){
        if(sModelType.compare(m_vecModelType[i])==0){
			eModelType=m_enuModelType[i];
			break;
		}
	}
	return eModelType;
}
bool	ModelType::isValid(const string& sModelType)
{
	for(int i=0;i<MT_NUM;i++){
        if(sModelType.compare(m_vecModelType[i])==0)
			return true;
	}
	return false;
}
bool	ModelType::isValid(const EModelType& eModelType)
{
	for(int i=0;i<MT_NUM;i++){
		if(eModelType==m_enuModelType[i])
			return true;
	}
	return false;
}
