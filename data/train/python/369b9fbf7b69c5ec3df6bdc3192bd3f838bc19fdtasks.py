from __future__ import absolute_import
from cStringIO import StringIO
from celery import shared_task
from linted.models import Repository, RepositoryScan
from django.conf import settings

import os
import tempfile
import shutil
import paramiko
import dulwich.client
import dulwich.repo
import datetime


def clone_repository(clone_url, path, private_key_file):
    dulwich.client.get_ssh_vendor = dulwich.client.ParamikoSSHVendor
    client, host_path = dulwich.client.get_transport_and_path(clone_url)
    client.ssh_kwargs = {
        "pkey": private_key_file
    }

    r = dulwich.repo.Repo.init(path, mkdir=True)
    remote_refs = client.fetch(host_path, r, determine_wants=r.object_store.determine_wants_all)
    r["HEAD"] = remote_refs["HEAD"]
    r._build_tree()


@shared_task(bind=True)
def scan_repository(self, repository_id):
    repository = Repository.objects.get(pk=repository_id)
    if repository is not None:
        repository_keys = repository.repositorykey_set.all()

        auth_success = False
        for key_pair in repository_keys:
            try:
                working_dir = os.path.join(tempfile.gettempdir(), self.request.id)

                private_key_file = StringIO(key_pair.private_key)
                clone_repository(repository.clone_url, working_dir, private_key_file)
                auth_success = True

                #Start repository scan
                repository_scan = RepositoryScan(repository=repository)
                repository_scan.created_at = datetime.datetime.now()
                repository_scan.save()

                for repo_scanner in repository.repositoryscanner_set.all():
                    scanner_class = repo_scanner.scanner.scanner_class
                    if scanner_class is not None:
                        scanner = scanner_class(repository_scan, working_dir, '', repo_scanner.get_settings())
                        scanner.run()

                shutil.rmtree(working_dir)

                repository_scan.completed_at = datetime.datetime.now()
                repository_scan.save()
            except paramiko.AuthenticationException:
                pass

        return auth_success