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

#ifndef REPO_ROLE_H
#define REPO_ROLE_H

//------------------------------------------------------------------------------
#include <mongo/client/dbclient.h> // the MongoDB driver
//------------------------------------------------------------------------------
#include "../conversion/repo_transcoder_bson.h"
#include "../conversion/repo_transcoder_string.h"
//------------------------------------------------------------------------------
#include "../repocoreglobal.h"
#include "repobson.h"

namespace repo {
namespace core {

//------------------------------------------------------------------------------
//
// Fields specific to role only
//
//------------------------------------------------------------------------------


class REPO_CORE_EXPORT RepoRole : public RepoBSON
{

public :

    //! Default empty constructor.
    RepoRole();

    //! Constructor from Mongo BSON objects.
    RepoRole(const mongo::BSONObj &obj);

    //! Default empty destructor.
    ~RepoRole();

    //! Returns a new full (and owned) copy of the object.
    inline RepoRole copy() const { return RepoRole(RepoBSON::copy()); }

    //! Returns the name of the role if any.
    std::string getName() const;

}; // end class

} // end namespace core
} // end namespace repo

#endif // end REPO_ROLE_H

