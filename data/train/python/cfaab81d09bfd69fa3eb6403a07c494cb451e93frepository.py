# -*- coding: utf-8 -*-
"""
    clihub/repository.py
    ~~~~~~~~~~~~~~~~~~~~

    :copyright: (c) 2012 by Stephane Wirtel <stephane@wirtel.be>
    :license: BSD, see LICENSE for more details
"""
import requests
import json


class Repository(object):
    @classmethod
    def create(cls, account, repository_name, has_issues=True, has_wiki=True):
        values = {
            "name": repository_name,
            "private": False,
            "has_issues": has_issues,
            "has_wiki": has_wiki,
            "has_downloads": False      # XXX deprecated: https://github.com/blog/1302-goodbye-uploads
        }
        url = 'https://api.github.com/user/repos'

        query = requests.post(url,
                              auth=(account.username, account.password),
                              data=json.dumps(values))

        if query.status_code == 201:
            print query.json()['ssh_url']

            return Repository(account, repository_name)
        else:
            raise Exception("Can't create the repository")

    def __init__(self, account, repository_name):
        self.account = account
        self.repository_name = repository_name

    def delete(self):
        url = 'https://api.github.com/repos/{username}/{repository}'
        url = url.format(username=self.account.username,
                         repository=self.repository_name)

        requests.delete(url,
                        auth=(self.account.username, self.account.password))
