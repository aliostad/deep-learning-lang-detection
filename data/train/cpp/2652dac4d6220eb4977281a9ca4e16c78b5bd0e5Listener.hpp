/*
 * MacGitver
 * Copyright (C) 2012-2015 The MacGitver-Developers <dev@macgitver.org>
 *
 * (C) Sascha Cunz <sascha@cunz-rad.com>
 * (C) Cunz RaD Ltd.
 *
 * This program is free software; you can redistribute it and/or modify it under the terms of the
 * GNU General Public License (Version 2) as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 * even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with this program; if
 * not, see <http://www.gnu.org/licenses/>.
 *
 */

#pragma once

#include <QCoreApplication>

#include "libMacGitverCore/RepoMan/Events.hpp"

#include "libLogger/Channel.hpp"
#include "libLogger/Event.hpp"

class Listener : public RM::EventsInterface
{
    Q_DECLARE_TR_FUNCTIONS(RepoManLogger)

public:
    Listener(Log::Channel channel);
    ~Listener();

public:
    void repositoryOpened(RM::Repo* repo);
    void repositoryAboutToClose(RM::Repo* repo);
    void repositoryActivated(RM::Repo* repo);
    void repositoryDeactivated(RM::Repo* repo);
    void objectCreated(RM::Repo* repo, RM::Base* object);
    void objectAboutToBeDeleted(RM::Repo* repo, RM::Base* object);
    void refTreeNodeCreated(RM::Repo* repo, RM::RefTreeNode* node);
    void refTreeNodeAboutToBeDeleted(RM::Repo* repo, RM::RefTreeNode* node);
    void refCreated(RM::Repo* repo, RM::Ref* ref);
    void refAboutToBeDeleted(RM::Repo* repo, RM::Ref* ref);
    void refMoved(RM::Repo* repo, RM::Ref* ref);
    void refHeadDetached(RM::Repo* repo, RM::Ref* ref);
    void tagCreated(RM::Repo* repo, RM::Tag* tag);
    void tagAboutToBeDeleted(RM::Repo* repo, RM::Tag* tag);
    void branchCreated(RM::Repo* repo, RM::Branch* branch);
    void branchAboutToBeDeleted(RM::Repo* repo, RM::Branch* branch);
    void branchMoved(RM::Repo* repo, RM::Branch* branch);
    void branchUpstreamChanged(RM::Repo* repo, RM::Branch* branch);
    void namespaceCreated(RM::Repo* repo, RM::Namespace* nameSpace);
    void namespaceAboutToBeDeleted(RM::Repo* repo, RM::Namespace* nameSpace);
    void refLogChanged(RM::Repo* repo, RM::RefLog* reflog);
    void refLogNewEntry(RM::Repo* repo, RM::RefLog* reflog);
    void stageCreated(RM::Repo* repo, RM::Ref* ref);
    void stageAboutToBeDeleted(RM::Repo* repo, RM::Ref* ref);
    void remoteCreated(RM::Repo* repo, RM::Remote* remote);
    void remoteAboutToBeDeleted(RM::Repo* repo, RM::Remote* remote);
    void remoteModified(RM::Repo* repo, RM::Remote* remote);
    void submoduleCreated(RM::Repo* repo, RM::Submodule* submodule);
    void submoduleAboutToBeDeleted(RM::Repo* repo, RM::Submodule* submodule);
    void submoduleMoved(RM::Repo* repo, RM::Submodule* submodule);
    void repositoryStateChanged(RM::Repo* repo);
    void indexUpdated(RM::Repo* repo);
    void workTreeUpdated(RM::Repo* repo);

private:
    Log::Channel repoManChannel;
};
