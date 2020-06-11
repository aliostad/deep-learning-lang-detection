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

#include <QObject>

class QTimer;

#include "libGitWrap/Repository.hpp"

#include "libMacGitverCore/RepoMan/Base.hpp"

namespace RM
{

    class RepoMan;
    class Head;

    namespace Internal
    {
        class RepoPrivate;
    }

    class MGV_CORE_API Repo : public QObject, public Base
    {
        friend class RepoMan;

        Q_OBJECT
    public:
        enum { StaticObjectType = RepoObject };
        typedef Internal::RepoPrivate Private;
        typedef QSet< Repo* > Set;
        typedef QVector< Repo* > List;

    protected:
        Repo(Internal::RepoPrivate& _d);

    public:
        Repo(const Git::Repository& repo, Base* parent);
        ~Repo();

    public:
        GW_DEPRECATED Git::Repository gitRepo();
        GW_DEPRECATED Git::Repository gitLoadedRepo() const;

        bool isSubModule() const;
        bool isBare() const;
        bool isLoaded() const;
        bool isActive() const;
        bool isInitializing() const;

        Repo* parentRepository();
        Set submodules() const;

        QString path() const;

        QString displayAlias() const;
        void setDisplayAlias( const QString& alias );

        QString branchDisplay() const;

        void close();

        Ref*        findReference(  const Git::Reference&   ref);
        Ref*        findReference(  const QString&          fqrn);
        Remote*     findRemote(     const Git::Remote&      remote);
        Remote*     findRemote(     const QString&          remoteName);
        Namespace*  findNamespace(  const QStringList&      namespaces);
        Namespace*  findNamespace(  const QString&          nsFullName);

        CollectionNode* branches();
        CollectionNode* namespaces();
        CollectionNode* notes();
        CollectionNode* tags();
        Head*           head() const;

    private:
        void activated();
        void deactivated();

    private slots:
        void unloadTimer();

    signals:
        void aboutToClose   (RM::Repo* repo);
        void aboutToUnload  (RM::Repo* repo);
        void unloaded       (RM::Repo* repo);
        void loaded         (RM::Repo* repo);
        void childAdded     (RM::Repo* parent, RM::Repo* child);
        void aliasChanged   (const QString& newAlias);
    };

}
