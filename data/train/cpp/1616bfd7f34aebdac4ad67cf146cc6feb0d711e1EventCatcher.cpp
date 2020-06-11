/*
 * MacGitver
 * Copyright (C) 2012-2013 The MacGitver-Developers <dev@macgitver.org>
 *
 * (C) Sascha Cunz <sascha@macgitver.org>
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

#include "libMacGitverCore/RepoMan/Repo.hpp"
#include "libMacGitverCore/RepoMan/Remote.hpp"
#include "libMacGitverCore/RepoMan/Ref.hpp"
#include "libMacGitverCore/RepoMan/RepoMan.hpp"
#include "libMacGitverCore/RepoMan/Tag.hpp"
#include "libMacGitverCore/RepoMan/Branch.hpp"
#include "libMacGitverCore/RepoMan/RefLog.hpp"
#include "libMacGitverCore/RepoMan/Submodule.hpp"
#include "libMacGitverCore/RepoMan/Namespace.hpp"
#include "libMacGitverCore/RepoMan/RefTreeNode.hpp"

#include "Infra/EventCatcher.hpp"

EventCatcher::EventCatcher()
{
    RM::Events::addReceiver(this);
}

EventCatcher::~EventCatcher()
{
    RM::Events::delReceiver(this);
}

void EventCatcher::clear()
{
    entries.clear();
}

EventCatcher::EventLogEntries EventCatcher::allEvents() const
{
    return entries;
}

int EventCatcher::eventCount() const
{
    return entries.count();
}

int EventCatcher::eventCount(EventTypes type)
{
    int count = 0;

    foreach (const EventLogEntry& ele, entries) {
        if (ele.type == type) {
            count++;
        }
    }

    return count;
}

int EventCatcher::eventCount(EventTypes type, RM::Base* p1) const
{
    int count = 0;

    foreach (const EventLogEntry& ele, entries) {
        if (ele.type == type && ele.params.count() == 1 && ele.params[0] == p1) {
            count++;
        }
    }

    return count;
}

int EventCatcher::eventCount(EventTypes type, RM::Base* p1, RM::Base* p2) const
{
    int count = 0;

    foreach (const EventLogEntry& ele, entries) {
        if (ele.type == type && ele.params.count() == 2 && ele.params[0] == p1 &&
                ele.params[1] == p2) {
            count++;
        }
    }

    return count;
}

void EventCatcher::recordEvent(EventTypes type, RM::Base* p1)
{
    EventLogEntry ele;
    ele.type = type;
    ele.params << p1;
    entries << ele;
}

void EventCatcher::recordEvent(EventTypes type, RM::Base* p1, RM::Base* p2)
{
    EventLogEntry ele;
    ele.type = type;
    ele.params << p1 << p2;
    entries << ele;
}

void EventCatcher::repositoryOpened(RM::Repo* repo)
{
    recordEvent(ecRepoOpened, repo);
}

void EventCatcher::repositoryAboutToClose(RM::Repo* repo)
{
    recordEvent(ecRepoAboutToClose, repo);
}

void EventCatcher::repositoryActivated(RM::Repo* repo)
{
    recordEvent(ecRepoActivated, repo);
}

void EventCatcher::repositoryDeactivated(RM::Repo* repo)
{
    recordEvent(ecRepoDeactivated, repo);
}

void EventCatcher::refTreeNodeCreated(RM::Repo* repo, RM::RefTreeNode* node)
{
    recordEvent(ecRefTreeNodeCreated, repo, node);
}

void EventCatcher::refTreeNodeAboutToBeDeleted(RM::Repo* repo, RM::RefTreeNode* node)
{
    recordEvent(ecRefTreeNodeAboutToBeRemoved, repo, node);
}

void EventCatcher::refCreated(RM::Repo* repo, RM::Ref* ref)
{
    recordEvent(ecRefCreated, repo, ref);
}

void EventCatcher::refAboutToBeDeleted(RM::Repo* repo, RM::Ref* ref)
{
    recordEvent(ecRefAboutToBeRemoved, repo, ref);
}

void EventCatcher::refMoved(RM::Repo* repo, RM::Ref* ref)
{
    recordEvent(ecRefMoved, repo, ref);
}

void EventCatcher::refHeadDetached(RM::Repo* repo, RM::Ref* ref)
{
    recordEvent(ecRefHeadDetached, repo, ref);
}

void EventCatcher::tagCreated(RM::Repo* repo, RM::Tag* tag)
{
    recordEvent(ecTagCreated, repo, tag);
}

void EventCatcher::tagAboutToBeDeleted(RM::Repo* repo, RM::Tag* tag)
{
    recordEvent(ecTagAboutToBeDeleted, repo, tag);
}

void EventCatcher::branchCreated(RM::Repo* repo, RM::Branch* branch)
{
    recordEvent(ecBranchCreated, repo, branch);
}

void EventCatcher::branchAboutToBeDeleted(RM::Repo* repo, RM::Branch* branch)
{
    recordEvent(ecBranchAboutToBeDeleted, repo, branch);
}

void EventCatcher::branchMoved(RM::Repo* repo, RM::Branch* branch)
{
    recordEvent(ecBranchMoved, repo, branch);
}

void EventCatcher::branchUpstreamChanged(RM::Repo* repo, RM::Branch* branch)
{
    recordEvent(ecBranchUpstreamChanged, repo, branch);
}

void EventCatcher::namespaceCreated(RM::Repo* repo, RM::Namespace* nameSpace)
{
    recordEvent(ecNamespaceCreated, repo, nameSpace);
}

void EventCatcher::namespaceAboutToBeDeleted(RM::Repo* repo, RM::Namespace* nameSpace)
{
    recordEvent(ecNamespaceAboutToBeRemoved, repo, nameSpace);
}

void EventCatcher::refLogChanged(RM::Repo* repo, RM::RefLog* reflog)
{
    recordEvent(ecRefLogChanged, repo, reflog);
}

void EventCatcher::refLogNewEntry(RM::Repo* repo, RM::RefLog* reflog)
{
    recordEvent(ecRefLogNewEntry, repo, reflog);
}

void EventCatcher::stageCreated(RM::Repo* repo, RM::Ref* ref)
{
    recordEvent(ecStageCreated, repo, ref);
}

void EventCatcher::stageAboutToBeDeleted(RM::Repo* repo, RM::Ref* ref)
{
    recordEvent(ecStageAboutToBeRemoved, repo, ref);
}

void EventCatcher::remoteCreated(RM::Repo* repo, RM::Remote* remote)
{
    recordEvent(ecRemoteCreated, repo, remote);
}

void EventCatcher::remoteAboutToBeDeleted(RM::Repo* repo, RM::Remote* remote)
{
    recordEvent(ecRemoteAboutToBeRemoved, repo, remote);
}

void EventCatcher::remoteModified(RM::Repo* repo, RM::Remote* remote)
{
    recordEvent(ecRemoteModified, repo, remote);
}

void EventCatcher::submoduleCreated(RM::Repo* repo, RM::Submodule* submodule)
{
    recordEvent(ecSubmoduleCreated, repo, submodule);
}

void EventCatcher::submoduleAboutToBeDeleted(RM::Repo* repo, RM::Submodule* submodule)
{
    recordEvent(ecSubmoduleAboutToBeDeleted, repo, submodule);
}

void EventCatcher::submoduleMoved(RM::Repo* repo, RM::Submodule* submodule)
{
    recordEvent(ecSubmoduleMoved, repo, submodule);
}

void EventCatcher::repositoryStateChanged(RM::Repo* repo)
{
    recordEvent(ecRepoStateChanged, repo);
}

void EventCatcher::indexUpdated(RM::Repo* repo)
{
    recordEvent(ecIndexUpdated, repo);
}

void EventCatcher::workTreeUpdated(RM::Repo* repo)
{
    recordEvent(ecWorkTreeUpdated, repo);
}

