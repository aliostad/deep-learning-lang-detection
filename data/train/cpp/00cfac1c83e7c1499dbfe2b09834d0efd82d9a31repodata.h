/*
    YUMRepoManager, a manager for the configuration files of YUM and his repositories.
    Copyright (C) 2011-2012  Josué V. Herrera

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef REPODATA_H
#define REPODATA_H

#include <QObject>

class RepoData
{

public:

    explicit RepoData();

    enum RepoLabel {
        Name,
        Comment,
        FailoverMethod,
        SkipIfUnavailable,
        BaseURL,
        MetaLink,
        Proxy,
        ProxyUsername,
        ProxyPassword,
        Speed,
        Include,
        Exclude,
        Enabled,
        MetadataExpire,
        GPGCheck,
        GPGKey,
        FileName,
        ParallelDownload
    };

    QString repoFileName;
    QString repoName;
    QString repoComment[2];
    QString repoFailoverMethod[3];
    QString repoSkipIfUnavailable[3];
    QString repoBaseURL[3];
    QString repoMetaLink[3];
    QString repoProxy[3];
    QString repoProxyUsername[3];
    QString repoProxyPassword[3];
    QString repoBandwidth[3];
    QString repoInclude[3];
    QString repoExclude[3];
    QString repoEnabled[2];
    QString repoMetadataExpire[3];
    QString repoGPGCheck[3];
    QString repoGPGKey[3];
    QString repoParallelDownload[3];

    bool operator ==(const RepoData &repoDataRight);
    bool operator !=(const RepoData &repoDataRight);

};

#endif // REPODATA_H
