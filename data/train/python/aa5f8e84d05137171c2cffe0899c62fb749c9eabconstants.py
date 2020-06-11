#!/usr/bin/env python
# -*- coding: utf-8 -*-

REPOSITORY_GROUP="""
    <repositoryGroups>
        <repositoryGroup>
            <id>$ID</id>
            <mergedIndexPath>.indexer</mergedIndexPath>
            <repositories>
                <repository>internal</repository>
                <repository>snapshots</repository>
            </repositories>
        </repositoryGroup>
    </repositoryGroups>
"""

REMOTE_REPOSITORIES="""
        <remoteRepository>
            <url>$URL</url>
            <downloadRemoteIndex>false</downloadRemoteIndex>
            <downloadRemoteIndexOnStartup>false</downloadRemoteIndexOnStartup>
            <id>$REPO_ID</id>
            <name>$REPO_NAME</name>
        </remoteRepository>
"""

PROXY_CONNECTORS="""
        <proxyConnector>
            <order>$ORDER</order>
            <sourceRepoId>internal</sourceRepoId>
            <targetRepoId>$TARGET_REPO_ID</targetRepoId>
            <policies>
                <releases>hourly</releases>
                <propagate-errors>queue error</propagate-errors>
                <checksum>fix</checksum>
                <propagate-errors-on-update>artifact not already present</propagate-errors-on-update>
                <snapshots>hourly</snapshots>
                <cache-failures>no</cache-failures>
            </policies>
            <disabled>false</disabled>
        </proxyConnector>
"""
