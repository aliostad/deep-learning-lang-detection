/**
 *  Copyright (C) 2015 3D Repo Ltd
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


#ifndef REPO_BINARY_H
#define REPO_BINARY_H


//------------------------------------------------------------------------------
#include "../repocoreglobal.h"
#include "repobson.h"
//------------------------------------------------------------------------------

#include <iostream>
#include <fstream>

namespace repo {
namespace core {

/*!
 * See http://www.iana.org/assignments/media-types/media-types.xhtml#image
 */
class REPO_CORE_EXPORT RepoBinary : public RepoBSON
{

public:

    RepoBinary() : RepoBSON() {}

    RepoBinary(const mongo::BSONObj &obj) : RepoBSON(obj) {}

    RepoBinary(const unsigned char* bytes,
              unsigned int bytesLength,
              const string &mediaType);

    RepoBinary(const std::string &fullFilePath, const std::string &mediaType);

    ~RepoBinary() {}

    //--------------------------------------------------------------------------

    //! Returns a new full (and owned) copy of the object.
    inline RepoBinary copy() const { return RepoBinary(RepoBSON::copy()); }

    //--------------------------------------------------------------------------

    //! Returns image data as a vector of bytes.
    std::vector<char> getData() const;

    //! Returns the raw byte array pointer as well as the size of the array.
    const char* getData(int &length) const;

    //! Returns the media type of the image if set.
    std::string getMediaType() const
    { return getField(REPO_LABEL_MEDIA_TYPE).String(); }

    //! Returns a raw array pointer from a given vector.
    template <class T>
    static const T* toArray(const std::vector<T> &vector)
    {   return (const T*) &(vector.at(0)); }

protected :

    bool populate(const unsigned char* bytes,
                  unsigned int bytesLength,
                  const string &mediaType);

}; // end class

} // end namespace core
} // end namespace repo

#endif // REPO_BINARY_H
