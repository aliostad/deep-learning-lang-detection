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

#ifndef TEST_MGV_CORE_EVENT_CATCHER_HPP
#define TEST_MGV_CORE_EVENT_CATCHER_HPP

#include "libMacGitverCore/RepoMan/Base.hpp"
#include "libMacGitverCore/RepoMan/Events.hpp"

namespace RM
{
    class Repo;
}

enum EventTypes {
    // These are administrative for RepoMan
    ecRepoOpened,
    ecRepoAboutToClose,
    ecRepoActivated,
    ecRepoDeactivated,

    // These are more or less virtual events. They are artificially constructed in RepoMan
    ecRefTreeNodeCreated,
    ecRefTreeNodeAboutToBeRemoved,

    // The following list represent events that actually may occur inside a git repository
    ecRefCreated,
    ecRefAboutToBeRemoved,
    ecRefMoved,
    ecRefLinkChanged,               // => SymLink target changed (i.e. in HEAD)
    ecRefOrphaned,                  // Additional to ecRefLinkChanged
    ecRefHeadDetached,              // Additional to ecRefLinkChanged

    ecTagCreated,                   // Additional to ecRefCreated
    ecTagAboutToBeDeleted,          // Additional to ecRefDeleted

    ecBranchCreated,                // Additional to ecRefCreated
    ecBranchAboutToBeDeleted,       // Additional to ecRefDeleted
    ecBranchMoved,                  // Additional to ecRefMoved

    ecBranchUpstreamChanged,

    ecNamespaceCreated,
    ecNamespaceAboutToBeRemoved,

    ecRefLogChanged,
    ecRefLogNewEntry,

    ecStageCreated,                 // Additional to ecRefLogNewEntry and ecRefLogChanged
    ecStageAboutToBeRemoved,        // Additional to ecRefLogChanged

    ecRemoteCreated,
    ecRemoteAboutToBeRemoved,
    ecRemoteModified,

    ecSubmoduleCreated,
    ecSubmoduleAboutToBeDeleted,
    ecSubmoduleMoved,


    // These will be very hard to implement:
    ecRepoStateChanged,     // Normal / Rebasing / Merging etc.

    ecIndexUpdated,         // Any modification to the index should trigger this event
    ecWorkTreeUpdated,      // This cannot be determined relyable everywhere(But I got some idea...)

    ecLast  // => to not warn for the ',' in C++98
};

class EventCatcher : public RM::EventsInterface
{
public:
    struct EventLogEntry
    {
        EventTypes      type;
        RM::Base::List  params;
    };

    typedef QVector<EventLogEntry> EventLogEntries;

public:
    EventCatcher();
    ~EventCatcher();

public:
    void clear();
    EventLogEntries allEvents() const;

    int eventCount() const;
    int eventCount(EventTypes type);
    int eventCount(EventTypes type, RM::Base* p1) const;
    int eventCount(EventTypes type, RM::Base* p1, RM::Base* p2) const;

private:
    void recordEvent(EventTypes type, RM::Base* p1);
    void recordEvent(EventTypes type, RM::Base* p1, RM::Base* p2);

protected:
    void repositoryOpened(RM::Repo* repo);
    void repositoryAboutToClose(RM::Repo* repo);
    void repositoryActivated(RM::Repo* repo);
    void repositoryDeactivated(RM::Repo* repo);
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
    EventLogEntries entries;
};

#endif
