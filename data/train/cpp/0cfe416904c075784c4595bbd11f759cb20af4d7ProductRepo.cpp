/// File name: ProductRepo.cpp
/// Class name: ProductRepo
/// Description: ProductRepo is the Repository class. 
/// Author: KiDuck Kim
/// Date: Jan.28, 2016

#include <fstream>
#include "../include/ProductRepo.h"

ProductRepo::ProductRepo()
{
}

ProductRepo::~ProductRepo()
{
	if(!m_productRepo.empty())
	{
		m_productRepo.clear();
	}
}
	
bool ProductRepo::loadDataFromFile(std::string &filePath)
{
	bool bRet = false;
	std::string line;
	
	std::ifstream infile(filePath.c_str(), std::ifstream::in);
	
	while (std::getline(infile, line))
	{
		Product product(line);
		m_productRepo.push_back(product);
		bRet = true;
	}
	
	return bRet;
}

int ProductRepo::count()
{
	return (int)m_productRepo.size();
}

Product ProductRepo::getProduct(int nPos)
{
	if(nPos >= 0 && nPos < m_productRepo.size())
	{
		return m_productRepo[nPos];
	}
	else
	{
		Product nullProduct;
		return nullProduct;
	}
}

void ProductRepo::clear()
{
	if(!m_productRepo.empty())
	{
		m_productRepo.clear();
	}
}