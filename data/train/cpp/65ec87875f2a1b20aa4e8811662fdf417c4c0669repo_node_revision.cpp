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

#include "repo_node_revision.h"

//------------------------------------------------------------------------------
//
// Static variables
//
//------------------------------------------------------------------------------
// NULL uuid
boost::uuids::uuid repo::core::RepoNodeRevision::REPO_NODE_UUID_BRANCH_MASTER =
	{ 0x00 ,0x00, 0x00, 0x00
    , 0x00, 0x00
    , 0x00, 0x00
    , 0x00, 0x00
    , 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

//------------------------------------------------------------------------------
//
// Constructors
//
//------------------------------------------------------------------------------
repo::core::RepoNodeRevision::RepoNodeRevision(const mongo::BSONObj & obj)
	: RepoNodeAbstract(obj) 
{
    //--------------------------------------------------------------------------
	// Author
	if (obj.hasField(REPO_NODE_LABEL_AUTHOR))
		author = obj.getField(REPO_NODE_LABEL_AUTHOR).str();

    //--------------------------------------------------------------------------
	// Message
	if (obj.hasField(REPO_NODE_LABEL_MESSAGE))
		message = obj.getField(REPO_NODE_LABEL_MESSAGE).str();

    //--------------------------------------------------------------------------
	// Tag
	if (obj.hasField(REPO_NODE_LABEL_TAG))
		tag = obj.getField(REPO_NODE_LABEL_TAG).str();

    //--------------------------------------------------------------------------
	// Timestamp
	if (obj.hasField(REPO_NODE_LABEL_TIMESTAMP))
		timestamp = obj.getField(REPO_NODE_LABEL_TIMESTAMP).Date();
	
    //--------------------------------------------------------------------------
	// Current Unique IDs
	if (obj.hasField(REPO_NODE_LABEL_CURRENT_UNIQUE_IDS))
		currentUniqueIDs = RepoTranscoderBSON::retrieveUUIDsSet(
			obj.getField(REPO_NODE_LABEL_CURRENT_UNIQUE_IDS));

    //--------------------------------------------------------------------------
	// Added Shared IDs
	if (obj.hasField(REPO_NODE_LABEL_ADDED_SHARED_IDS))
		addedSharedIDs = RepoTranscoderBSON::retrieveUUIDsSet(
			obj.getField(REPO_NODE_LABEL_ADDED_SHARED_IDS));

    //--------------------------------------------------------------------------
	// Deleted Shared IDs
	if (obj.hasField(REPO_NODE_LABEL_DELETED_SHARED_IDS))
		deletedSharedIDs = RepoTranscoderBSON::retrieveUUIDsSet(
			obj.getField(REPO_NODE_LABEL_DELETED_SHARED_IDS));

    //--------------------------------------------------------------------------
	// Modified Shared IDs
	if (obj.hasField(REPO_NODE_LABEL_MODIFIED_SHARED_IDS))
		modifiedSharedIDs = RepoTranscoderBSON::retrieveUUIDsSet(
			obj.getField(REPO_NODE_LABEL_MODIFIED_SHARED_IDS));

    //--------------------------------------------------------------------------
	// Unmodified Shared IDs
	if (obj.hasField(REPO_NODE_LABEL_UNMODIFIED_SHARED_IDS))
		unmodifiedSharedIDs = RepoTranscoderBSON::retrieveUUIDsSet(
			obj.getField(REPO_NODE_LABEL_UNMODIFIED_SHARED_IDS));
}

//------------------------------------------------------------------------------
//
// Destructor
//
//------------------------------------------------------------------------------

repo::core::RepoNodeRevision::~RepoNodeRevision() {}


//------------------------------------------------------------------------------
//
// Operators
//
//------------------------------------------------------------------------------

bool repo::core::RepoNodeRevision::operator==(const RepoNodeAbstract& other) const
{
    const RepoNodeRevision *otherRevision = dynamic_cast<const RepoNodeRevision*>(&other);
    return otherRevision &&
            RepoNodeAbstract::operator==(other) &&
            this->getAuthor() == otherRevision->getAuthor() &&
            this->getMessage() == otherRevision->getMessage() &&
            this->getTag() == otherRevision->getTag() &&
            this->getTimestamp() == otherRevision->getTimestamp() &&
            (std::equal(this->getCurrentUniqueIDs().begin(),
                        this->getCurrentUniqueIDs().end(),
                        otherRevision->getCurrentUniqueIDs().end())) &&
            (std::equal(this->getAddedSharedIDs().begin(),
                        this->getAddedSharedIDs().end(),
                        otherRevision->getAddedSharedIDs().end())) &&
            (std::equal(this->getDeletedSharedIDs().begin(),
                        this->getDeletedSharedIDs().end(),
                        otherRevision->getDeletedSharedIDs().end())) &&
            (std::equal(this->getModifiedSharedIDs().begin(),
                        this->getModifiedSharedIDs().end(),
                        otherRevision->getModifiedSharedIDs().end())) &&
            (std::equal(this->getUnmodifiedSharedIDs().begin(),
                        this->getUnmodifiedSharedIDs().end(),
                        otherRevision->getUnmodifiedSharedIDs().end()));
}

//------------------------------------------------------------------------------
//
// Export
//
//------------------------------------------------------------------------------

mongo::BSONObj repo::core::RepoNodeRevision::toBSONObj() const
{
	mongo::BSONObjBuilder builder;

    //--------------------------------------------------------------------------
	// Compulsory fields such as _id, type, api as well as path
	// and optional name
	appendDefaultFields(builder);

    //--------------------------------------------------------------------------
	// Author
	if (!author.empty()) 
		builder << REPO_NODE_LABEL_AUTHOR << author;

    //--------------------------------------------------------------------------
	// Message
	if (!message.empty()) 
		builder << REPO_NODE_LABEL_MESSAGE << message;

    //--------------------------------------------------------------------------
	// Tag
	if (!tag.empty()) 
		builder << REPO_NODE_LABEL_TAG << tag;

    //--------------------------------------------------------------------------
	// Timestamp
	builder << REPO_NODE_LABEL_TIMESTAMP << timestamp;

    //--------------------------------------------------------------------------
	// Current Unique IDs
	if (currentUniqueIDs.size() > 0)
        RepoTranscoderBSON::append(REPO_NODE_LABEL_CURRENT_UNIQUE_IDS,
                                   currentUniqueIDs, builder);

    //--------------------------------------------------------------------------
	// Added Shared IDs
	if (addedSharedIDs.size() > 0)
        RepoTranscoderBSON::append(REPO_NODE_LABEL_ADDED_SHARED_IDS,
                                   addedSharedIDs, builder);

    //--------------------------------------------------------------------------
	// Deleted Shared IDs
	if (deletedSharedIDs.size() > 0)
        RepoTranscoderBSON::append(REPO_NODE_LABEL_DELETED_SHARED_IDS,
                                   deletedSharedIDs, builder);

    //--------------------------------------------------------------------------
	// Modified Shared IDs
	if (modifiedSharedIDs.size() > 0)
        RepoTranscoderBSON::append(REPO_NODE_LABEL_MODIFIED_SHARED_IDS,
                                   modifiedSharedIDs, builder);

    //--------------------------------------------------------------------------
	// Unmodified Shared IDs
	if (unmodifiedSharedIDs.size() > 0)
        RepoTranscoderBSON::append(REPO_NODE_LABEL_UNMODIFIED_SHARED_IDS,
                                   unmodifiedSharedIDs, builder);

    //--------------------------------------------------------------------------
	return builder.obj();
}

void repo::core::RepoNodeRevision::setCurrentUniqueIDs(const RepoNodeAbstractSet &nodes)
{
    currentUniqueIDs.clear();
    for (RepoNodeAbstract *node : nodes)
        currentUniqueIDs.insert(node->getUniqueID());
}
