import logging
import os

from django.conf import settings
from django.template.context import RequestContext
from django.http import Http404
from django.shortcuts import render_to_response

from .utils import human_filesize, pygmentize
from .models import Repository

def repository_list(request, template_name='gitweb/repository_list.html'):
    template_context = {
        'repository_list': Repository.objects.visible_repositories_for_user(request.user),
    }
    
    return render_to_response(
        template_name,
        template_context,
        RequestContext(request)
    )

def repository_summary(request, slug, template_name='gitweb/repository_summary.html'):
    try:
        repository = Repository.objects.visible_repositories_for_user(request.user).get(slug=slug)
    except Repository.DoesNotExist:
        raise Http404
    
    clone_url = settings.GIT_CLONE_URL % os.path.split(repository.path)[1]
    
    template_context = {
        'repository': repository,
        'clone_url': clone_url,
    }

    return render_to_response(
        template_name,
        template_context,
        RequestContext(request)
    )

def repository_log(request, slug, branch=None, template_name='gitweb/repository_log.html'):
    try:
        repository = Repository.objects.visible_repositories_for_user(request.user).get(slug=slug)
    except Repository. Repository.DoesNotExist:
        raise Http404
    
    if branch == None:
        logs = repository.repo().log()
        branch = "All"
    else:
        logs = repository.repo().log(branch)
    
    template_context = {
        'repository': repository,
        'branch':branch,
        'logs': logs
    }

    return render_to_response(
        template_name,
        template_context,
        RequestContext(request)
    )

def repository_tree(request, slug, branch, path, template_name='gitweb/repository_tree.html'):
    try:
        repository = Repository.objects.visible_repositories_for_user(request.user).get(slug=slug)
    except Repository.DoesNotExist:
        raise Http404

    tree = repository.repo().tree(branch)

    for element in path.split('/'):
        if len(element):
            tree = tree/element

    if hasattr(tree, 'mime_type'):
        is_blob = True
    else:
        is_blob = False
        tree = [{'path': os.path.join(path, e.name), 'e': e, 'human_size': human_filesize(getattr(e, 'size', 0))} for e in tree.values()]

    template_context = {
        'repository': repository,
        'branch': branch,
        'path': os.path.join('/', path),
        'prev_path': '/'.join(path.split('/')[0:-1]),
        'tree': tree,
        'is_blob': is_blob,
    }
    if is_blob:
        template_context.update({
            'blob_human_size': human_filesize(tree.size),
            'blob_lines': range(len(tree.data.splitlines())),
            'blob_pygmentized': pygmentize(tree.mime_type, tree.data),
        })

    return render_to_response(
        template_name,
        template_context,
        RequestContext(request)
    )

def repository_commit(request, slug, commit, template_name='gitweb/repository_commit.html'):
    try:
        repository = Repository.objects.visible_repositories_for_user(request.user).get(slug=slug)
    except Repository.DoesNotExist:
        raise Http404

    try:
        commit = repository.repo().commit(commit)
    except:
        raise Http404
    
    template_context = {
        'repository': repository,
        'commit': commit,
    }

    return render_to_response(
        template_name,
        template_context,
        RequestContext(request)
    )
