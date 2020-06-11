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


#include "repo_user.h"

repo::core::RepoUser::RepoUser(const std::string &username,
                               const std::string &cleartextPassword,
                               const string &firstName,
                               const string &lastName,
                               const string &email,
                               const std::list<std::pair<std::string, std::string> > &projects,
                               const std::list<std::pair<std::string, std::string> > &roles,
                               const std::list<std::pair<string, string> > &groups,
                               const std::list<std::pair<string, string> > &apiKeys,
                               const RepoImage &avatar)
    : RepoBSON()
{
    mongo::BSONObjBuilder builder;
    //--------------------------------------------------------------------------
    // Username
    RepoTranscoderBSON::append(
                REPO_LABEL_ID,
                boost::uuids::random_generator()(),
                builder);
    builder << REPO_LABEL_USER << username;

    //--------------------------------------------------------------------------
    // Password
    mongo::BSONObjBuilder credentialsBuilder;
    credentialsBuilder << REPO_LABEL_CLEARTEXT << cleartextPassword;
    builder << REPO_LABEL_CREDENTIALS << credentialsBuilder.obj();

    //--------------------------------------------------------------------------
    //
    // Custom Data
    //
    //--------------------------------------------------------------------------
    mongo::BSONObjBuilder customDataBuilder;

    //--------------------------------------------------------------------------
    // First name
    if (!firstName.empty())
        customDataBuilder << REPO_LABEL_FIRST_NAME << firstName;

    //--------------------------------------------------------------------------
    // Last name
    if (!lastName.empty())
        customDataBuilder << REPO_LABEL_LAST_NAME << lastName;

    //--------------------------------------------------------------------------
    // Email
    if (!email.empty())
        customDataBuilder << REPO_LABEL_EMAIL << email;

    //--------------------------------------------------------------------------
    // Custom Data.Projects : []
    if (!projects.empty())
        customDataBuilder.appendArray(REPO_LABEL_PROJECTS, toArray(projects, REPO_LABEL_OWNER, REPO_LABEL_PROJECT));

    if (!groups.empty())
        customDataBuilder << REPO_LABEL_GROUPS << toArray(groups, REPO_LABEL_OWNER, REPO_LABEL_GROUP);

    if (!apiKeys.empty())
        customDataBuilder << REPO_LABEL_API_KEYS << toArray(apiKeys, REPO_LABEL, REPO_LABEL_KEY);

    //--------------------------------------------------------------------------
    // Avatar
    if (avatar.isOk())
        customDataBuilder << REPO_LABEL_AVATAR << avatar;

    builder << REPO_LABEL_CUSTOM_DATA << customDataBuilder.obj();


    //--------------------------------------------------------------------------
    // Roles
    if (!roles.empty())
        builder.appendArray(REPO_LABEL_ROLES, toArray(roles, REPO_LABEL_DB, REPO_LABEL_ROLE));

    //--------------------------------------------------------------------------
    // Populate superclass RepoBSON
	mongo::BSONObj builtObj = builder.obj();
	RepoBSON::addFields(builtObj);

}

std::list<std::pair<std::string, std::string> > repo::core::RepoUser::getAPIKeysList() const
{
    mongo::BSONElement arrayElement = getEmbeddedElement(REPO_LABEL_CUSTOM_DATA,
                                                         REPO_LABEL_API_KEYS);
    return RepoBSON::getArrayStringPairs(arrayElement, REPO_LABEL, REPO_LABEL_KEY);
}

repo::core::RepoImage repo::core::RepoUser::getAvatar() const
{
    RepoImage image;
    mongo::BSONElement bse = this->getCustomDataField(REPO_LABEL_AVATAR);
    if (!bse.eoo())
        image = RepoImage(bse.embeddedObject());
    return image;
}


std::list<std::pair<std::string, std::string> > repo::core::RepoUser::getProjectsList() const
{
    mongo::BSONElement arrayElement = getEmbeddedElement(REPO_LABEL_CUSTOM_DATA,
                                                         REPO_LABEL_PROJECTS);
    return RepoBSON::getArrayStringPairs(arrayElement, REPO_LABEL_OWNER, REPO_LABEL_PROJECT);
}

std::list<std::pair<std::string, std::string> > repo::core::RepoUser::getGroupsList() const
{
    mongo::BSONElement arrayElement = getEmbeddedElement(REPO_LABEL_CUSTOM_DATA,
                                                         REPO_LABEL_GROUPS);
    return RepoBSON::getArrayStringPairs(arrayElement, REPO_LABEL_OWNER, REPO_LABEL_GROUP);
}

std::list<std::pair<std::string, std::string> > repo::core::RepoUser::getRolesList() const
{
    return RepoBSON::getArrayStringPairs(getField(REPO_LABEL_ROLES), REPO_LABEL_DB, REPO_LABEL_ROLE);
}

//------------------------------------------------------------------------------
//
// Protected
//
//------------------------------------------------------------------------------

repo::core::RepoBSON repo::core::RepoUser::command(const RepoBSONCommands &command) const
{
    mongo::BSONObjBuilder builder;

    //--------------------------------------------------------------------------
    // Command : Username
    // See http://docs.mongodb.org/manual/reference/command/
    switch(command)
    {
    case CREATE:
        builder << REPO_COMMAND_CREATE_USER << getUsername();
        break;
    case UPDATE:
        builder << REPO_COMMAND_UPDATE_USER << getUsername();
        break;
    case DROP :
        builder << REPO_COMMAND_DROP_USER << getUsername();
        break;
    }

    if (DROP != command)
    {
        //----------------------------------------------------------------------
        // Password
        std::string cleartextPassword = getCleartextPassword();
        if (!cleartextPassword.empty())
            builder << REPO_LABEL_PWD << getCleartextPassword();

        //----------------------------------------------------------------------
        // Custom data
        builder << REPO_LABEL_CUSTOM_DATA << getCustomDataBSON();

        //----------------------------------------------------------------------
        // Roles
        builder.appendArray(REPO_LABEL_ROLES, getRolesBSON());
    }
    return RepoBSON(builder.obj());
}


