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

#include "libMacGitverCore/App/MacGitver.hpp"

#include "RepoMan/RepoMan.hpp"
#include "RepoMan/CollectionNode.hpp"
#include "RepoMan/Events.hpp"

#include "RepoMan/Private/Dumper.hpp"
#include "RepoMan/Private/RepoManPrivate.hpp"
#include "RepoMan/Private/RepoPrivate.hpp"

#include "libBlueSky/Application.hpp"

namespace RM
{

    using namespace Internal;

    /**
     * @class       RepoMan
     * @brief       Manages the open / active repositories
     */

    /**
     * @brief       Constructor
     *
     * Initializes the repository subsystem. Invoked from MacGitver boot up code.
     *
     */
    RepoMan::RepoMan()
        : Base(*new RepoManPrivate(this))
    {
        Events::addReceiver(this);

        connect(BlueSky::Application::instance(),
                SIGNAL(activeModeChanged(BlueSky::Mode*)),
                this,
                SLOT(reactivateWorkaround()));
    }

    /**
     * @brief       Destructor
     *
     * Close all repositories.
     *
     */
    RepoMan::~RepoMan()
    {
        closeAll();
        Events::delReceiver(this);
    }

    /**
     * @brief       Open a repository (By it's path)
     *
     * Opens a Git::Repository at the @a path and if this is valid, call open() to setup a RepoMan
     * repository for it.
     *
     * @param[in]   path    The path where to look for the repository to open.
     *
     * @return      A pointer to a Repo object that represents the repositorty. An existing one will
     *              be returned if such a Repo object can be found.
     *              `NULL` will be returned, if the repository cannot be opened.
     *
     */
    Repo* RepoMan::open(const QString& path)
    {
        Git::Result result;
        Git::Repository repo = Git::Repository::open( result, path );
        if( !result || !repo.isValid() )
        {
            return NULL;
        }

        return open( repo );
    }

    /**
     * @brief       Setup a Repo object for a Git::Repository
     *
     * If there is no Repo object for the git repository at that place in the file system, a new one
     * will be created and registered with the repo-manager and the core.
     *
     * @param[in]   gitRepo The Git::Repository object
     *
     * @return      Returns either an existing Repo object or a newly created one.
     *
     */
    Repo* RepoMan::open(const Git::Repository& gitRepo)
    {
        RM_D(RepoMan);

        Repo* repo = repoByPath(gitRepo.workTreePath(), false);

        if(!repo) {
            repo = new Repo(gitRepo, this);
            d->repos.append(repo);

            Events::self()->repositoryOpened(repo);

            if (d->repos.count() == 1) {
                emit firstRepositoryOpened();
            }
        }

        activate( repo );
        return repo;
    }

    Repo* RepoMan::repoByPath( const QString& basePath, bool searchSubmodules )
    {
        RM_D(RepoMan);

        foreach (Repo* repo, d->repos) {
            if (repo->path() == basePath) {
                return repo;
            }

            if (searchSubmodules) {
                if (RepoPrivate* subPriv = Private::dataOf<Repo>(repo)) {
                    if (Repo* subSubRepo = subPriv->repoByPath(basePath, true)) {
                        return subSubRepo;
                    }
                }
            }
        }

        return NULL;
    }

    /**
     * @brief       Close all currently open repositories
     *
     */
    void RepoMan::closeAll()
    {
        RM_D(RepoMan);

        foreach(Repo* repo, d->repos) {
            repo->close();
        }
    }

    void RepoMan::reactivateWorkaround()
    {
        RM_D(RepoMan);
        if (d->activeRepo) {
            Events::self()->repositoryDeactivated(d->activeRepo);
            Events::self()->repositoryActivated(d->activeRepo);
        }
    }

    void RepoMan::activate(Repo* repository)
    {
        RM_D(RepoMan);

        if(repository != d->activeRepo) {
            Repo* old = d->activeRepo;

            if (d->activeRepo) {
                d->activeRepo->deactivated();
                Events::self()->repositoryDeactivated(d->activeRepo);
            }

            d->activeRepo = repository;

            if (repository) {
                repository->activated();
                Events::self()->repositoryActivated(d->activeRepo);
            }

            // Finally emit a signal that just tells about the change
            if ((d->activeRepo != NULL) != (old != NULL)) {
                emit hasActiveRepositoryChanged(d->activeRepo != NULL);
            }
        }
    }

    void RepoMan::internalClosedRepo(Repo* repository)
    {
        RM_D(RepoMan);

        // ### We can implement this by far better, now...

        // This pointer is actually useless. THIS IS THE LAST call issued by the destructor of the
        // RepositoryInfo itself. We should probably NOT give this pointer away.

        // However, we need it to find the closed repository in our list. Calling here should have
        // probably happened before the repository is actually destructing itself.

        int i = d->repos.indexOf(repository);
        if (i != -1) {
            d->repos.remove(i);
            emit repositoryClosed();

            if (d->repos.count() == 0) {
                emit lastRepositoryClosed();
            }
        }
    }

    Repo* RepoMan::activeRepository()
    {
        RM_D(RepoMan);
        return d->activeRepo;
    }

    Repo::List RepoMan::repositories() const
    {
        RM_CD(RepoMan);
        return d->repos;
    }

    //-- RepoManPrivate ----------------------------------------------------------------------------

    RepoManPrivate::RepoManPrivate(RepoMan* _pub)
        : BasePrivate(_pub)
        , activeRepo(NULL)
        , refresher(NULL)
    {
        setupActions(_pub);

        // only start the auto refresher if we're running a GUI
        if (MacGitver::self().isRunningGui()) {
            refresher = new AutoRefresher(_pub);
        }
    }

    bool RepoManPrivate::refreshSelf()
    {
        return true;
    }

    ObjTypes RepoManPrivate::objType() const
    {
        return RepoManagerObject;
    }

    void RepoManPrivate::dumpSelf(Internal::Dumper& dumper) const
    {
        dumper.addLine(QStringLiteral("Repository-Manager"));
    }

    void RepoManPrivate::preTerminate()
    {
        // Do we need to do smth?
    }

    QString RepoManPrivate::displayName() const
    {
        return QStringLiteral("RepoMan");
    }

    QString RepoManPrivate::objectTypeName() const
    {
        return QStringLiteral("RepoMan");
    }

    Heaven::Menu* RepoManPrivate::contextMenuFor(Base* object)
    {
        switch (object->objType()) {

        case BranchObject:      return menuCtxBranch;
        case TagObject:         return menuCtxTag;
        case RepoObject:        return menuCtxRepo;
        case SubmoduleObject:   return menuCtxSubmodule;
        case NamespaceObject:   return menuCtxNamespace;
        case RefLogObject:      return menuCtxRefLog;
        case RemoteObject:      return menuCtxRemote;

        //case RefObject:                 return menuCtxRef;
        //case RefTreeNodeObject:         return menuCtxRefTreeNode;

        case CollectionNodeObject:
            switch (static_cast<CollectionNode*>(object)->collectionType()) {

            case ctBranches:    return menuCtxBranches;
            case ctTags:        return menuCtxTags;
            case ctNotes:       return menuCtxNotes;
            case ctNamespaces:  return menuCtxNamespaces;

            default:            break;
            }
            break;

        default:
            break;
        }

        return NULL;
    }

}
