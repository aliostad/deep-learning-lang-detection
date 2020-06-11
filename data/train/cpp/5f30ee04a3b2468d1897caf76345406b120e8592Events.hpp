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

#include <QSet>

#include "libMacGitverCore/MacGitverApi.hpp"

namespace RM
{

    class Base;
    class Namespace;
    class Repo;
    class Ref;
    class Remote;
    class Submodule;
    class RefTreeNode;
    class RefLog;
    class Branch;
    class Tag;

    class MGV_CORE_API EventsInterface
    {
    public:
        virtual ~EventsInterface() {}

    public:
        virtual void repositoryOpened(Repo* repo) = 0;
        virtual void repositoryAboutToClose(Repo* repo) = 0;
        virtual void repositoryActivated(Repo* repo) = 0;
        virtual void repositoryDeactivated(Repo* repo) = 0;

        virtual void objectCreated(Repo* repo, Base* object) = 0;
        virtual void objectAboutToBeDeleted(Repo* repo, Base* object) = 0;

        virtual void refTreeNodeCreated(Repo* repo, RefTreeNode* node) = 0;
        virtual void refTreeNodeAboutToBeDeleted(Repo* repo, RefTreeNode* node) = 0;

        virtual void refCreated(Repo* repo, Ref* ref) = 0;
        virtual void refAboutToBeDeleted(Repo* repo, Ref* ref) = 0;
        virtual void refMoved(Repo* repo, Ref* ref) = 0;
        virtual void refHeadDetached(Repo* repo, Ref* ref) = 0;

        virtual void tagCreated(Repo* repo, Tag* tag) = 0;
        virtual void tagAboutToBeDeleted(Repo* repo, Tag* tag) = 0;

        virtual void branchCreated(Repo* repo, Branch* branch) = 0;
        virtual void branchAboutToBeDeleted(Repo* repo, Branch* branch) = 0;
        virtual void branchMoved(Repo* repo, Branch* branch) = 0;
        virtual void branchUpstreamChanged(Repo* repo, Branch* branch) = 0;

        virtual void namespaceCreated(Repo* repo, Namespace* nameSpace) = 0;
        virtual void namespaceAboutToBeDeleted(Repo* repo, Namespace* nameSpace) = 0;

        virtual void refLogChanged(Repo* repo, RefLog* reflog) = 0;
        virtual void refLogNewEntry(Repo* repo, RefLog* reflog) = 0;

        virtual void stageCreated(Repo* repo, Ref* ref) = 0;
        virtual void stageAboutToBeDeleted(Repo* repo, Ref* ref) = 0;

        virtual void remoteCreated(Repo* repo, Remote* remote) = 0;
        virtual void remoteAboutToBeDeleted(Repo* repo, Remote* remote) = 0;
        virtual void remoteModified(Repo* repo, Remote* remote) = 0;

        virtual void submoduleCreated(Repo* repo, Submodule* submodule) = 0;
        virtual void submoduleAboutToBeDeleted(Repo* repo, Submodule* submodule) = 0;
        virtual void submoduleMoved(Repo* repo, Submodule* submodule) = 0;

        virtual void repositoryStateChanged(Repo* repo) = 0;
        virtual void indexUpdated(Repo* repo) = 0;
        virtual void workTreeUpdated(Repo* repo) = 0;
    };

    class MGV_CORE_API Events // : public EventsInterface
    {
    private:
        Events();

    public:
        static Events* self();
        static void addReceiver(EventsInterface* ev);
        static void delReceiver(EventsInterface* ev);

    private:
        QSet< EventsInterface* > mEvents;
        static Events* sSelf;

    public:
        void repositoryOpened(Repo* repo);
        void repositoryAboutToClose(Repo* repo);
        void repositoryActivated(Repo* repo);
        void repositoryDeactivated(Repo* repo);
        void objectCreated(Repo* repo, Base* object);
        void objectAboutToBeDeleted(Repo* repo, Base* object);
        void refTreeNodeCreated(Repo* repo, RefTreeNode* node);
        void refTreeNodeAboutToBeDeleted(Repo* repo, RefTreeNode* node);
        void refCreated(Repo* repo, Ref* ref);
        void refAboutToBeDeleted(Repo* repo, Ref* ref);
        void refMoved(Repo* repo, Ref* ref);
        void refHeadDetached(Repo* repo, Ref* ref);
        void tagCreated(Repo* repo, Tag* tag);
        void tagAboutToBeDeleted(Repo* repo, Tag* tag);
        void branchCreated(Repo* repo, Branch* branch);
        void branchAboutToBeDeleted(Repo* repo, Branch* branch);
        void branchMoved(Repo* repo, Branch* branch);
        void branchUpstreamChanged(Repo* repo, Branch* branch);
        void namespaceCreated(Repo* repo, Namespace* nameSpace);
        void namespaceAboutToBeDeleted(Repo* repo, Namespace* nameSpace);
        void refLogChanged(Repo* repo, RefLog* reflog);
        void refLogNewEntry(Repo* repo, RefLog* reflog);
        void stageCreated(Repo* repo, Ref* ref);
        void stageAboutToBeDeleted(Repo* repo, Ref* ref);
        void remoteCreated(Repo* repo, Remote* remote);
        void remoteAboutToBeDeleted(Repo* repo, Remote* remote);
        void remoteModified(Repo* repo, Remote* remote);
        void submoduleCreated(Repo* repo, Submodule* submodule);
        void submoduleAboutToBeDeleted(Repo* repo, Submodule* submodule);
        void submoduleMoved(Repo* repo, Submodule* submodule);
        void repositoryStateChanged(Repo* repo);
        void indexUpdated(Repo* repo);
        void workTreeUpdated(Repo* repo);
    };

}
