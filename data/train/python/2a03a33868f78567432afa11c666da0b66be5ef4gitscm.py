import re
import time
import logging
import datetime
import shutil
import tempfile
from django.db import transaction
from django.utils.encoding import smart_unicode
from jellybaby.models import Item, CodeRepository, CodeCommit
from jellybaby.providers import utils

try:
    import git
except ImportError:
    git = None

log = logging.getLogger("jellybaby.providers.gitscm")

#
# Public API
#
def enabled():
    ok = git is not None
    if not ok:
        log.warn("The GIT provider is not available because the GitPython module "
                 "isn't installed.")
    return ok

def update():
    for repository in CodeRepository.objects.filter(type="git"):
        _update_repository(repository)
        
#
# Private API
#

def _update_repository(repository):
    source_identifier = "%s:%s" % (__name__, repository.url)
    last_update_date = Item.objects.get_last_update_of_model(CodeCommit, source=source_identifier)
    log.info("Updating changes from %s since %s", repository.url, last_update_date)

    # Git chokes on the 1969-12-31 sentinal returned by 
    # get_last_update_of_model, so fix that up.
    if last_update_date.date() == datetime.date(1969, 12, 31):
        last_update_date = datetime.datetime(1970, 1, 1)

    working_dir, repo = _create_local_repo(repository)
    commits = repo.commits_since(since=last_update_date.strftime("%Y-%m-%d"))
    for commit in reversed(commits):
        if commit.author.email == repository.username:
            _handle_revision(repository, commit)
            
    log.debug("Removing working dir %s.", working_dir)
    shutil.rmtree(working_dir)

def _create_local_repo(repository):
    working_dir = tempfile.mkdtemp()
    g = git.Git(working_dir)

    log.debug("Cloning %s into %s", repository.url, working_dir)
    res = g.clone(repository.url)
    
    # This is pretty nasty.
    m = re.match('^Initialized empty Git repository in (.*)', res)
    repo_location = m.group(1).rstrip('/')
    
    return working_dir, git.Repo(repo_location)

@transaction.commit_on_success
def _handle_revision(repository, commit):
    log.debug("Handling [%s] from %s", commit.id[:7], repository.url)
    ci, created = CodeCommit.objects.get_or_create(
        revision = commit.id,
        repository = repository,
        defaults = {"message": smart_unicode(commit.message)}
    )
    if created:
        timestamp = datetime.datetime.fromtimestamp(time.mktime(commit.committed_date))
        return Item.objects.create_or_update(
            instance = ci, 
            timestamp = timestamp,
            source = "%s:%s" % (__name__, repository.url),
        )
