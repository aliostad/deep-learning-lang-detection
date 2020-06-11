/******************************************************************************/
/*!
\file	Model.cpp
\author Tang Wen Sheng
\par	email: tang_wen_sheng\@nyp.edu.sg
\brief
Define the model and it's method
*/
/******************************************************************************/

#include "Model.h"

/***********************************************************/
/*!
\brief
	CModel default constructor
*/
/***********************************************************/
CModel::CModel(void)
{
}

/***********************************************************/
/*!
\brief
	CModel deconstructor
*/
/***********************************************************/
CModel::~CModel(void)
{
}

/***********************************************************/
/*!
\brief
	Sets a model

\param Model
	Sets the Model
*/
/***********************************************************/
void CModel::SetModel(GEOMETRY_TYPE Model)
{
	model = Model;
}

/***********************************************************/
/*!
\brief
	Gets the model

\return 
	Returns the Model
*/
/***********************************************************/
CModel::GEOMETRY_TYPE CModel::getModel(){
	return model;
}