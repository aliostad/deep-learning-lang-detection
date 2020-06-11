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

#ifndef REPO_GRAPH_HISTORY_H
#define REPO_GRAPH_HISTORY_H

//------------------------------------------------------------------------------
#include "repo_graph_abstract.h"
#include "repo_node_abstract.h"
#include "repo_node_revision.h"
//------------------------------------------------------------------------------

namespace repo {
namespace core {

//! 3D Repo scene graph as directed acyclic graph with single root node.
class REPO_CORE_EXPORT RepoGraphHistory : public RepoGraphAbstract
{

public :

    //--------------------------------------------------------------------------
	//
	// Constructors
	//
    //--------------------------------------------------------------------------

	//! Empty default constructor so that it can be registered as a qmetatype.
    RepoGraphHistory() : RepoGraphAbstract() {}

	/*!
	 * Constructs a graph from a collection of BSON objects.
	 *
	 * \sa RepoGraphScene(), ~RepoGraphScene()
	 */
	RepoGraphHistory(const std::vector<mongo::BSONObj> &collection);

	//! Destructor for proper cleanup.
	/*!
	 * \sa RepoGraphScene()
	 */
	~RepoGraphHistory();

    //--------------------------------------------------------------------------
	//
	// Export
	//
    //--------------------------------------------------------------------------


    //--------------------------------------------------------------------------
	//
	// Getters
	//
    //--------------------------------------------------------------------------

	//! Returns a vector of revision nodes.
    std::vector<RepoNodeAbstract *> getRevisions() const { return revisions; }

	//! Returns the revision that is the be committed.
    RepoNodeRevision *getCommitRevision() const { return commitRevision; }

    //--------------------------------------------------------------------------
	//
	// Setters
	//
    //--------------------------------------------------------------------------

	//! Sets the revision that is to be committed.
	void setCommitRevision(RepoNodeRevision *commitRevision) 
        { this->commitRevision = commitRevision; }

protected :

	//! A vector of all revisions from all branches.
	std::vector<RepoNodeAbstract *> revisions; 

	//! Revision node that is to be committed.
    RepoNodeRevision *commitRevision;

}; // end class

} // end namespace core
} // end namespace repo

#endif // end REPO_GRAPH_HISTORY_H


