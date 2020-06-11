from django.core.paginator import Paginator
from django.http import HttpResponse, HttpResponseRedirect
from django.shortcuts import get_object_or_404

import repo_browser.models
from repo_browser.decorators import template


@template("repo_browser/list_repositories.html")
def list_repositories(request):
    "List the available repositories"

    repositories = repo_browser.models.Repository.objects.filter(
        show_on_index=True)

    return {"repositories": repositories}


@template("repo_browser/repository_details.html")
def repository_details(request, repository_slug, allow_sync=True):
    "Summary detail page for a repository"

    repository = get_object_or_404(
        repo_browser.models.Repository,
        slug=str(repository_slug))

    if request.method == "POST":
        # Allow a button to force re-sync from the on-disk repository
        if 'force_sync' in request.POST and allow_sync:
            repository.incremental_sync()
            # Avoid POST-on-refresh
            return HttpResponseRedirect("")

    return {"repository": repository}


@template("repo_browser/commit_list.html")
def commitlist(request, repository_slug):
    "View a set of commits in a repo"

    repository = get_object_or_404(
        repo_browser.models.Repository,
        slug=str(repository_slug))
    commit_paginator = Paginator(
        repository.commits.all(),
        int(request.GET.get("per_page", 50)))
    commits = commit_paginator.page(int(request.GET.get("page", 1)))

    return {"repository": repository,
            "commits": commits}


@template("repo_browser/commit_details.html")
def view_commit(request, repository_slug, commit_identifier):
    "View a single commit"

    repository = get_object_or_404(
        repo_browser.models.Repository,
        slug=str(repository_slug))
    commit = get_object_or_404(
        repository.commits.all(),
        identifier=str(commit_identifier))

    if request.GET.get("format") == "diff":
        res = HttpResponse(commit.diff, content_type="text/x-diff")
        res["Content-Disposition"] = 'attachment; filename="%s.diff"' % commit.identifier
        return res

    return {"repository": repository,
            "commit": commit}


@template("repo_browser/manifest.html")
def manifest(request, repository_slug, commit_identifier, directory=None):
    "View a single commit"
    # TODO: Handle directory to only show particular sub-directories

    repository = get_object_or_404(
        repo_browser.models.Repository,
        slug=str(repository_slug))
    commit = get_object_or_404(
        repository.commits.all(),
        identifier=str(commit_identifier))

    return {"repository": repository,
            "commit": commit, }

