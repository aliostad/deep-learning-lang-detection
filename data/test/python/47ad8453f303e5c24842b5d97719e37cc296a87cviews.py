# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from django.shortcuts import get_object_or_404, render
from django.views.decorators.cache import cache_page

from website.models import *
from website.shared import *

def path_cmp(a, b):
    if a.is_dir == b.is_dir:
        return cmp(a.name, b.name)
    return -1 if a.is_dir else 1

@cache_page(86400)
def index(request):
    repositories = Repository.objects.filter(hidden = False).order_by('name')
    context = { "repositories": repositories }
    return render(request, "index.html", context)

def path(request, repository_name, path_name):
    path = Path.get_by_path(path_name)
    repository = get_object_or_404(Repository, name = repository_name, paths = path, hidden = False)

    queryparams = {
        "pushes__push__repository": repository,
    }

    if path.parent is not None:
        queryparams["changes__path__ancestors__ancestor"] = path

    if "types" in request.GET:
        types = [TYPEMAP[t] for t in request.GET["types"].split(",")]
        queryparams["changes__type__in"] = types

    changesets = Changeset.objects.filter(**queryparams).distinct().order_by("-pushes__push__push_id", "-pushes__index")
    changesets = list(changesets[:200])
    if len(changesets):
        tag = "path:%s/%s:%s:%s" % (repository_name, path_name, changesets[0].hex, changesets[-1].hex)
    else:
        tag = "path:%s/%s::" % (repository_name, path_name)

    return tag_cached(render_path, tag, request, repository, path, changesets)

def render_path(request, repository, path, changesets):
    query = request.GET.urlencode()
    if query:
        query = "?" + query

    context = {
      "repository": repository,
      "path": path,
      "changesets": changesets,
      "paths": sorted(path.children.filter(repositories = repository), path_cmp),
      "query": query,
    }
    return render(request, "path.html", context)

@cache_page(86400)
def changeset(request, repository_name, changeset_id):
    repository = get_object_or_404(Repository, name = repository_name, hidden = False)
    changeset = get_object_or_404(Changeset, pushes__push__repository = repository, hex__startswith = changeset_id)
    return tag_cached(render_changeset, "changeset:%s" % changeset.hex, request, repository, changeset)

def render_changeset(request, repository, changeset):
    context = {
      "repository": repository,
      "changeset": changeset,
      "changes": sorted(changeset.changes.all(), cmp=lambda x,y: cmp(x.path.path, y.path.path)),
    }
    return render(request, "changeset.html", context)
