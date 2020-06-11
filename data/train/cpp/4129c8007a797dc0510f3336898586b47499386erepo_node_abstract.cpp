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

#include "repo_node_abstract.h"

//------------------------------------------------------------------------------
//
// Constructor
//
//------------------------------------------------------------------------------

repo::core::RepoNodeAbstract::RepoNodeAbstract(const mongo::BSONObj &obj)
{
    //--------------------------------------------------------------------------
	// ID
	uniqueID = RepoTranscoderBSON::retrieve(obj.getField(REPO_NODE_LABEL_ID));

    //--------------------------------------------------------------------------
	// Shared ID
	if (obj.hasField(REPO_NODE_LABEL_SHARED_ID))
		sharedID = RepoTranscoderBSON::retrieve(
			obj.getField(REPO_NODE_LABEL_SHARED_ID));

    //--------------------------------------------------------------------------
	// Type
	if (obj.hasField(REPO_NODE_LABEL_TYPE))
		type = obj.getField(REPO_NODE_LABEL_TYPE).String();
	else
		type = REPO_NODE_TYPE_UNKNOWN; // failsafe

    //--------------------------------------------------------------------------
	// API level
	if (obj.hasField(REPO_NODE_LABEL_API))
		api = obj.getField(REPO_NODE_LABEL_API).numberInt();
	else
		api = REPO_NODE_API_LEVEL_0; // failsafe

    //--------------------------------------------------------------------------
	// Name (optional)
	if (obj.hasField(REPO_NODE_LABEL_NAME))
		name = obj.getField(REPO_NODE_LABEL_NAME).String();

    //--------------------------------------------------------------------------
	// Parents
	if (obj.hasField(REPO_NODE_LABEL_PARENTS))
	{
		std::vector<boost::uuids::uuid> parentIDs =
			RepoTranscoderBSON::retrieveUUIDs(
				obj.getField(REPO_NODE_LABEL_PARENTS));

        std::vector<boost::uuids::uuid>::iterator it;
        for (it = parentIDs.begin(); it != parentIDs.end(); ++it)
        {
            boost::uuids::uuid id = *it;
			parentSharedIDs.insert(id);
        }
	}
}


//------------------------------------------------------------------------------
//
// Operators
//
//------------------------------------------------------------------------------


bool repo::core::RepoNodeAbstract::operator==(const RepoNodeAbstract &other) const
{
    return (this->getType() == other.getType()) &&
           (this->getName() == other.getName()) &&
           (this->getApi() == other.getApi()) &&
           (this->getSharedID() == other.getSharedID());
}

bool repo::core::RepoNodeAbstract::operator<(const RepoNodeAbstract& other) const
{
    // Two nodes are considered the same as long as they are equal in all
    // but unique IDs (as those are of course globally unique)
    return this->getType() != other.getType()
            ? this->getType() < other.getType()
            : this->getName() != other.getName()
            ? this->getName() < other.getName()
            : this->getApi() != other.getApi()
            ? this->getApi() < other.getApi()
            : this->getSharedID() < other.getSharedID();
}

//------------------------------------------------------------------------------
//
// Family matters
//
//------------------------------------------------------------------------------

std::vector<std::vector<boost::uuids::uuid>>
	repo::core::RepoNodeAbstract::getPaths(const RepoNodeAbstract * node)
{
	std::vector<std::vector<boost::uuids::uuid>> ret;

	if (node->isRoot())
	{	
        //----------------------------------------------------------------------
		// Base case
		std::vector<boost::uuids::uuid> vec;
		vec.push_back(node->sharedID);
		ret.push_back(vec);
	}
	else 
	{	
        //----------------------------------------------------------------------
		// Recursion
        std::set<const RepoNodeAbstract *>::iterator it;
        for (it = node->parents.begin(); it != node->parents.end(); ++it)
        {
            const RepoNodeAbstract *parent = *it;
            std::vector<std::vector<boost::uuids::uuid> > paths =
				getPaths(parent);			
			
            //------------------------------------------------------------------
			// Store the current node in all the so far accumulated paths
            std::vector<std::vector<boost::uuids::uuid> >::iterator itt;
            for (itt = paths.begin(); itt != paths.end(); ++itt)
            {
                std::vector<boost::uuids::uuid> vec = *itt;
                vec.push_back(node->sharedID);
				ret.push_back(vec);
			}
		}		
	}
	return ret;
}

void repo::core::RepoNodeAbstract::getSubNodes(
        std::set<const RepoNodeAbstract *> &components) const
{
	components.insert(this);

    std::set<const RepoNodeAbstract *>::iterator it;
    for (it = children.begin(); it != children.end(); ++it)
    {
        const RepoNodeAbstract *child = *it;
		child->getSubNodes(components);
    }
}

std::set<boost::uuids::uuid> repo::core::RepoNodeAbstract::
	getParentSharedIDs() 
{
	if (parents.size() > parentSharedIDs.size())
	{
		parentSharedIDs.clear();
        std::set<const RepoNodeAbstract *>::iterator it;
        for (it = parents.begin(); it != parents.end(); ++it)
        {
//		for each (const RepoNodeAbstract * parent in parents)
			parentSharedIDs.insert((*it)->sharedID);
        }
	}
	return parentSharedIDs;
}

//------------------------------------------------------------------------------
//
// Export
//
//------------------------------------------------------------------------------

void repo::core::RepoNodeAbstract::appendDefaultFields(
	mongo::BSONObjBuilder &builder) const
{	
    //--------------------------------------------------------------------------
	// ID field (UUID)
	RepoTranscoderBSON::append(REPO_NODE_LABEL_ID, uniqueID, builder);

    //--------------------------------------------------------------------------
	// Shared ID (UUID)
	RepoTranscoderBSON::append(REPO_NODE_LABEL_SHARED_ID, sharedID, builder);
		
    //--------------------------------------------------------------------------
	// Paths
	// 
	// Paths are stored as array of arrays of shared_id (uuids)
	const std::vector<std::vector<boost::uuids::uuid>> paths = 
		getPaths(this);
	if (paths.size() > 0)
		RepoTranscoderBSON::append(REPO_NODE_LABEL_PATHS, paths, builder);
			
    //--------------------------------------------------------------------------
	// Type
	if (!type.empty())
		builder << REPO_NODE_LABEL_TYPE << type;

    //--------------------------------------------------------------------------
	// API level
	builder << REPO_NODE_LABEL_API << api;

    //--------------------------------------------------------------------------
	// Parents
	if (!isRoot()) 
	{
		std::vector<boost::uuids::uuid> parentalUUIDs;
        std::set<const RepoNodeAbstract *>::iterator it;
        for (it = parents.begin(); it != parents.end(); ++it)
        {
//		for each (const RepoNodeAbstract * node in parents)
//			parentalUUIDs.push_back(node->sharedID);
            parentalUUIDs.push_back((*it)->sharedID);
        }

		RepoTranscoderBSON::append(REPO_NODE_LABEL_PARENTS,
			parentalUUIDs, builder);
	}

    //--------------------------------------------------------------------------
	// Name
	if (!name.empty())
		builder <<  REPO_NODE_LABEL_NAME << name;
}

//------------------------------------------------------------------------------
//
// Static helpers
//
//------------------------------------------------------------------------------
mongo::Date_t repo::core::RepoNodeAbstract::currentTimestamp()
{
	return mongo::Date_t(time(NULL) * 1000); // milliseconds
}
