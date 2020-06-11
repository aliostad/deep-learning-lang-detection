///////////////////////////////////////////////////////////
//  Load.h
//  Implementation of the Class Load
//  Created on:      04-dic-2014 04:42:19 p.m.
//  Original author: julian
///////////////////////////////////////////////////////////

#if !defined(LOAD_H_)
#define LOAD_H_


#include <fstream>
#include <dirent.h>
#include <map>
#include <iostream>

#include "../json/json/json.h"

class Load
{

public:
	Load();
	virtual ~Load();

	void setDirectoryPath(std::string path);
	std::string getDirectoryPath();

	virtual void LoadInformation() = 0;

protected:
	bool has_suffix(const std::string& s, const std::string& suffix);
	std::string directory_path;

};
#endif // !defined(LOAD_H_)
