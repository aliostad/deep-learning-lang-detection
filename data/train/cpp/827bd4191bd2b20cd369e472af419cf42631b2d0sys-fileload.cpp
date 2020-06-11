#include "header.hpp"
using namespace amy;
extern PlayData DATA;

FileLoad::FileLoad()
{
	FileLoad::data.clear();
}
FileLoad::~FileLoad() {}

void FileLoad::load( const std::string &folder, const std::string &file )
{
	std::string filename = folder + "/" + file;

	// load the file only if it is not there on std::map
	if ( FileLoad::data.find(filename) == FileLoad::data.end() )
	{
		printf(">> FileLoad::load( %s, %s )\n", folder.c_str(), file.c_str() );

		// use the xp3 archieve file if found

		// use the folder
		amy::FileData data;
		if ( data.loadFromFile( filename ) )
			FileLoad::data[ filename ] = data;
		else
			printf("!! FAILED: data.loadFromFile( %s )\n", filename.c_str());
	}
}

void FileLoad::unload( const std::string &folder, const std::string &file )
{
	std::string filename = folder + "/" + file;

	// delete the sfimage from std::map only if found
	if ( FileLoad::data.find(filename) != FileLoad::data.end() )
	{
		printf(">> FileLoad::unload( %s, %s )\n", folder.c_str(), file.c_str() );
		FileLoad::data.erase(filename);
	}
}
