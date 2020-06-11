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
#include "libMacGitverCore/RepoMan/Tag.hpp"
#include "libMacGitverCore/RepoMan/Branch.hpp"
#include "libMacGitverCore/RepoMan/Submodule.hpp"

#include "Listener.hpp"
#include "TemplateNames.hpp"

Listener::Listener(Log::Channel channel)
    : repoManChannel(channel)
{
    RM::Events::addReceiver(this);
}

Listener::~Listener()
{
    RM::Events::delReceiver(this);
}

void Listener::repositoryOpened(RM::Repo* repo)
{
    Log::Event e = Log::Event::create(TMPL_REPO_ACTIVITY);
    Q_ASSERT(e.isValid());

    e.setParam(QLatin1String("Action"),     tr("opened"));
    e.setParam(QLatin1String("RepoName"),   repo->displayAlias());

    repoManChannel.addEvent(e);
}

void Listener::repositoryAboutToClose(RM::Repo* repo)
{
    Log::Event e = Log::Event::create(TMPL_REPO_ACTIVITY);
    Q_ASSERT(e.isValid());

    e.setParam(QLatin1String("Action"),     tr("closed"));
    e.setParam(QLatin1String("RepoName"),   repo->displayAlias());

    repoManChannel.addEvent(e);
}

void Listener::repositoryActivated(RM::Repo* repo)
{
    Log::Event e = Log::Event::create(TMPL_REPO_ACTIVITY);
    Q_ASSERT(e.isValid());

    e.setParam(QLatin1String("Action"),     tr("activated"));
    e.setParam(QLatin1String("RepoName"),   repo->displayAlias());

    repoManChannel.addEvent(e);
}

void Listener::repositoryDeactivated(RM::Repo* repo)
{
    // We don't want to report deactivation
}

void Listener::objectCreated(RM::Repo* repo, RM::Base* object)
{
}

void Listener::objectAboutToBeDeleted(RM::Repo* repo, RM::Base* object)
{
}

void Listener::refTreeNodeCreated(RM::Repo* repo, RM::RefTreeNode* node)
{
}

void Listener::refTreeNodeAboutToBeDeleted(RM::Repo* repo, RM::RefTreeNode* node)
{
}

void Listener::refCreated(RM::Repo* repo, RM::Ref* ref)
{
}

void Listener::refAboutToBeDeleted(RM::Repo* repo, RM::Ref* ref)
{
}

void Listener::refMoved(RM::Repo* repo, RM::Ref* ref)
{
}

void Listener::refHeadDetached(RM::Repo* repo, RM::Ref* ref)
{
}

void Listener::tagCreated(RM::Repo* repo, RM::Tag* tag)
{
    Log::Event e = Log::Event::create(TMPL_FOUND_NEW_REF);
    Q_ASSERT(e.isValid());

    e.setParam(QLatin1String("Type"),       tr("tag"));
    e.setParam(QLatin1String("ObjName"),    tag->displayName());
    e.setParam(QLatin1String("SHA"),        tag->displaySha1());
    e.setParam(QLatin1String("RepoName"),   repo->displayAlias());

    repoManChannel.addEvent(e);
}

void Listener::tagAboutToBeDeleted(RM::Repo* repo, RM::Tag* tag)
{
}

void Listener::branchCreated(RM::Repo* repo, RM::Branch* branch)
{
}

void Listener::branchAboutToBeDeleted(RM::Repo* repo, RM::Branch* branch)
{
}

void Listener::branchMoved(RM::Repo* repo, RM::Branch* branch)
{
    Log::Event e = Log::Event::create(TMPL_BRANCH_MOVED);
    Q_ASSERT(e.isValid());

    e.setParam(QLatin1String("ObjName"),    branch->displayName());
    e.setParam(QLatin1String("SHA"),        branch->displaySha1());
    e.setParam(QLatin1String("RepoName"),   repo->displayAlias());

    repoManChannel.addEvent(e);
}

void Listener::branchUpstreamChanged(RM::Repo* repo, RM::Branch* branch)
{
}

void Listener::namespaceCreated(RM::Repo* repo, RM::Namespace* nameSpace)
{
}

void Listener::namespaceAboutToBeDeleted(RM::Repo* repo, RM::Namespace* nameSpace)
{
}

void Listener::refLogChanged(RM::Repo* repo, RM::RefLog* reflog)
{
}

void Listener::refLogNewEntry(RM::Repo* repo, RM::RefLog* reflog)
{
}

void Listener::stageCreated(RM::Repo* repo, RM::Ref* ref)
{
}

void Listener::stageAboutToBeDeleted(RM::Repo* repo, RM::Ref* ref)
{
}

void Listener::remoteCreated(RM::Repo* repo, RM::Remote* remote)
{
}

void Listener::remoteAboutToBeDeleted(RM::Repo* repo, RM::Remote* remote)
{
}

void Listener::remoteModified(RM::Repo* repo, RM::Remote* remote)
{
}

void Listener::submoduleCreated(RM::Repo* repo, RM::Submodule* submodule)
{
    Log::Event e = Log::Event::create(TMPL_FOUND_NEW_SM);
    Q_ASSERT(e.isValid());

    e.setParam(QLatin1String("ObjName"),    submodule->displayName());
    e.setParam(QLatin1String("RepoName"),   repo->displayAlias());

    repoManChannel.addEvent(e);
}

void Listener::submoduleAboutToBeDeleted(RM::Repo* repo, RM::Submodule* submodule)
{
}

void Listener::submoduleMoved(RM::Repo* repo, RM::Submodule* submodule)
{
}

void Listener::repositoryStateChanged(RM::Repo* repo)
{
}

void Listener::indexUpdated(RM::Repo* repo)
{
}

void Listener::workTreeUpdated(RM::Repo* repo)
{
}
