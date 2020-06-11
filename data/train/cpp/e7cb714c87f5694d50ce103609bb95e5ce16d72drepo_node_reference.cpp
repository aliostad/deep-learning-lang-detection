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

#include "repo_node_reference.h"

//------------------------------------------------------------------------------
//
// Constructors
//
//------------------------------------------------------------------------------
repo::core::RepoNodeReference::RepoNodeReference(
        const std::string &database,
        const std::string &project)
    : RepoNodeAbstract (
            REPO_NODE_TYPE_REFERENCE,
            REPO_NODE_API_LEVEL_1,
            boost::uuids::random_generator()(),
            database + "." + project)
    , database(database)
    , project(project)
    , revisionID(boost::uuids::uuid())
    , isUniqueID(false)
{}

repo::core::RepoNodeReference::RepoNodeReference(
        const std::string &database,
        const std::string &project,
        const boost::uuids::uuid &revisionID,
        bool isUniqueID,
        const std::string &name)
    : RepoNodeAbstract (
            REPO_NODE_TYPE_REFERENCE,
            REPO_NODE_API_LEVEL_1,
            boost::uuids::random_generator()(),
            name)
    , project(project)
    , database(database)
    , revisionID(revisionID)
    , isUniqueID(isUniqueID)
{}

repo::core::RepoNodeReference::RepoNodeReference(
        const mongo::BSONObj &obj)
    : RepoNodeAbstract(obj)
    , revisionID(boost::uuids::uuid())
    , isUniqueID(false)
{
    //--------------------------------------------------------------------------
    // Owner
    if (obj.hasField(REPO_NODE_LABEL_OWNER))
        database = obj.getField(REPO_NODE_LABEL_OWNER).String();

    //--------------------------------------------------------------------------
    // Project
    if (obj.hasField(REPO_NODE_LABEL_PROJECT))
        project = obj.getField(REPO_NODE_LABEL_PROJECT).String();

    //--------------------------------------------------------------------------
    // Revision ID (specific revision if UID, branch if SID)
    if (obj.hasField(REPO_NODE_LABEL_REFERENCE_ID))
    {
        revisionID = RepoTranscoderBSON::retrieve(
                    obj.getField(REPO_NODE_LABEL_REFERENCE_ID));
    }

    //--------------------------------------------------------------------------
    // Unique
    if (obj.hasField(REPO_NODE_LABEL_UNIQUE))
    {
        isUniqueID = obj.getField(REPO_NODE_LABEL_UNIQUE).Bool();
    }
}

//------------------------------------------------------------------------------
//
// Operators
//
//------------------------------------------------------------------------------

bool repo::core::RepoNodeReference::operator==(const RepoNodeAbstract& other) const
{
    const RepoNodeReference *otherReference = dynamic_cast<const RepoNodeReference*>(&other);
    return otherReference &&
            RepoNodeAbstract::operator==(other) &&
            this->getProject() == otherReference->getProject() &&
            this->getOwner() == otherReference->getOwner() &&
            this->getRevisionID() == otherReference->getRevisionID() &&
            this->getIsUniqueID() == otherReference->getIsUniqueID();
}

mongo::BSONObj repo::core::RepoNodeReference::toBSONObj() const
{
    mongo::BSONObjBuilder builder;

    //--------------------------------------------------------------------------
    // Compulsory fields such as _id, type, api as well as path
    // and optional name
    appendDefaultFields(builder);

    //--------------------------------------------------------------------------
    // Project owner (company or individual)
    if (!database.empty())
        builder << REPO_NODE_LABEL_OWNER << database;

    //--------------------------------------------------------------------------
    // Project name
    if (!project.empty())
        builder << REPO_NODE_LABEL_PROJECT << project;

    //--------------------------------------------------------------------------
    // Revision ID (specific revision if UID, branch if SID)
    RepoTranscoderBSON::append(
                REPO_NODE_LABEL_REFERENCE_ID,
                revisionID,
                builder);

    //--------------------------------------------------------------------------
    // Unique set if the revisionID is UID, not set if SID (branch)
    if (isUniqueID)
        builder << REPO_NODE_LABEL_UNIQUE << isUniqueID;

    return builder.obj();
}
