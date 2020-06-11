/**
 *  Copyright (C) 2014 3D Repo Ltd
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "repo_node_texture.h"
#include <boost/filesystem.hpp>

//------------------------------------------------------------------------------
repo::core::RepoNodeTexture::RepoNodeTexture(
        const std::string &name,
        const char *data,
		const unsigned int byteCount,
		const unsigned int width,
        const unsigned int height)
    : RepoNodeAbstract (
			REPO_NODE_TYPE_TEXTURE, 
			REPO_NODE_API_LEVEL_1,
            boost::uuids::random_generator()(),
            name)
    , width(width)
    , height(height) /*,
		bitDepth(bitDepth),
		format(format) */
{
    // Vector is now guaranteed to be continuous block of memory, hence it is
	// used as a convenient way of keep track of the number of bytes pointed
	// by the data pointer.
	this->data = new std::vector<char>(byteCount);
    if (!this->data)
        std::cerr << "Memory allocation for texture " << name << " failed." << std::endl;
    else
        memcpy(&(this->data->at(0)), data, byteCount);
		
	this->name = boost::filesystem::path(name).stem().string();
	this->extension = boost::filesystem::extension(name);

    // remove leading dot
    this->extension = this->extension.substr(1, this->extension.size());
}

//------------------------------------------------------------------------------

repo::core::RepoNodeTexture::RepoNodeTexture(const mongo::BSONObj &obj)
    : RepoNodeAbstract(obj)
    , data(NULL)
{
	//
	// Width
	//
    if (obj.hasField(REPO_LABEL_WIDTH))
        width = obj.getField(REPO_LABEL_WIDTH).numberInt();

	//
	// Height
	//
    if (obj.hasField(REPO_LABEL_HEIGHT))
        height = obj.getField(REPO_LABEL_HEIGHT).numberInt();

	//
	// Format
	//
	if (obj.hasField(REPO_NODE_LABEL_EXTENSION)) {
		extension = obj.getField(REPO_NODE_LABEL_EXTENSION).str();
		name += "." + extension; // assimp needs full names with extension
	}

	//
	// Bit depth
	//
	//if (obj.hasField(REPO_NODE_LABEL_BIT_DEPTH))
	//	bitDepth = obj.getField(REPO_NODE_LABEL_BIT_DEPTH).numberInt();

	//
	// Data
	//
    if (obj.hasField(REPO_LABEL_DATA) &&
		obj.hasField(REPO_NODE_LABEL_DATA_BYTE_COUNT))
	{

        std::cerr << "Texture" << std::endl;
		data = new std::vector<char>();
		RepoTranscoderBSON::retrieve(
            obj.getField(REPO_LABEL_DATA),
			obj.getField(REPO_NODE_LABEL_DATA_BYTE_COUNT).numberInt(),
			data);
	}	
}

//------------------------------------------------------------------------------
//
// Destructor
//
//------------------------------------------------------------------------------
repo::core::RepoNodeTexture::~RepoNodeTexture() 
{
	if (NULL != data)
	{
		data->clear();
		delete data;
		data = NULL;
	}
}

//------------------------------------------------------------------------------
//
// Operators
//
//------------------------------------------------------------------------------

bool repo::core::RepoNodeTexture::operator==(const RepoNodeAbstract& other) const
{
    const RepoNodeTexture *otherTexture = dynamic_cast<const RepoNodeTexture*>(&other);
    return otherTexture &&
            RepoNodeAbstract::operator==(other) &&
            this->getWidth() == otherTexture->getWidth() &&
            this->getHeight() == otherTexture->getHeight() &&
            this->getExtension() == otherTexture->getExtension() &&
            std::equal(this->getData()->begin(),
                       this->getData()->end(),
                       otherTexture->getData()->begin());
}


//------------------------------------------------------------------------------
//
// Export
//
//------------------------------------------------------------------------------
mongo::BSONObj repo::core::RepoNodeTexture::toBSONObj() const
{
	mongo::BSONObjBuilder builder;

	// Compulsory fields such as _id, type, api as well as path
	// and optional name
	appendDefaultFields(builder);

	//
	// Width
	//
    builder << REPO_LABEL_WIDTH << width;

	//
	// Height
	//
    builder << REPO_LABEL_HEIGHT << height;
	
	//
	// Format
	//
	builder << REPO_NODE_LABEL_EXTENSION << extension;

	//
	// Bit depth
	//
	//builder << REPO_NODE_LABEL_BIT_DEPTH << bitDepth;
	
	//
	// Data
	//
	if (NULL != data && data->size() > 0)
		RepoTranscoderBSON::append(
            REPO_LABEL_DATA,
			data,
			builder,
			REPO_NODE_LABEL_DATA_BYTE_COUNT);

	return builder.obj();
}
