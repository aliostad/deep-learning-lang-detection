import posixpath
from cStringIO import StringIO

from django import http, shortcuts, template
from django.conf import settings
from django.core.servers import basehttp
from django.core.urlresolvers import reverse
from django.views.generic import list_detail

from svnlit import models, forms, decorators, exceptions
from svnlit.markup.hightlighter import get_lexer
from svnlit.utils import diff


def repository_list(request):
    """A view listing the available repositories."""
    repository_list = models.Repository.objects.all()

    if not request.user.is_authenticated():
        repository_list = repository_list.filter(is_private=False)

    return shortcuts.render_to_response(
        'svnlit/repository_list.html', locals(),
        context_instance=template.RequestContext(request))

repository_list = decorators.autosync_repositories(repository_list)


def changeset_list(request, repository_label):
    """A view listing the changesets for the given repository."""
    repository_lookup = {'label': repository_label}
    if not request.user.is_authenticated():
        repository_lookup['is_private'] = False
    repository = shortcuts.get_object_or_404(
        models.Repository, **repository_lookup)

    if request.GET.get('results', '').isdigit():
        results = int(request.GET.get('results'))
    else:
        results = settings.SVNLIT_CHANGESETS_PER_PAGE

    qs = http.QueryDict('', mutable=True)
    qs.update(request.GET)
    if 'page' in qs:
        del qs['page']
    qs = qs.urlencode()

    return list_detail.object_list(
        request, repository.changesets.all(), paginate_by=results,
        extra_context={'repository': repository, 'qs': qs},
        template_object_name='changeset')

changeset_list = decorators.autosync_repositories(changeset_list)


def changeset(request, repository_label, revision):
    """A view showing a given changeset."""
    repository_lookup = {'label': repository_label}
    if not request.user.is_authenticated():
        repository_lookup['is_private'] = False
    repository = shortcuts.get_object_or_404(
        models.Repository, **repository_lookup)
    if not revision:
        revision = repository.get_latest_revision()
    changeset = shortcuts.get_object_or_404(
        models.Changeset, repository=repository, revision=revision)

    return shortcuts.render_to_response(
        'svnlit/changeset.html', locals(),
        context_instance=template.RequestContext(request))


def node(request, repository_label, revision, path):
    """A view for displaying a given path at a given revision."""
    if request.method == 'POST':
        r = request.POST.get('revision', '').lower()
        if r.startswith('r'):
            r = r[1:]
        if r.isdigit():
            return http.HttpResponseRedirect(reverse(
                'svnlit_node_revision', args=(repository_label, r, path)))
    
    repository_lookup = {'label': repository_label}
    if not request.user.is_authenticated():
        repository_lookup['is_private'] = False
    repository = shortcuts.get_object_or_404(
        models.Repository, **repository_lookup)
    if not revision:
        revision = repository.get_latest_revision()
    changeset = shortcuts.get_object_or_404(
        models.Changeset, repository=repository, revision=revision)

    if not path:
        path = posixpath.sep

    try:
        node = repository.get_node(path, revision)
    except exceptions.InvalidNode:
        return shortcuts.render_to_response(
            'svnlit/node_invalid.html', locals(),
            context_instance=template.RequestContext(request))

    if node.is_directory():
        return shortcuts.render_to_response(
            'svnlit/node_directory.html', locals(),
            context_instance=template.RequestContext(request))
    else:
        return shortcuts.render_to_response(
            'svnlit/node_file.html', locals(),
            context_instance=template.RequestContext(request))

node = decorators.autosync_repositories(node)


def content(request, repository_label, content_id, path):
    """
    A view for fetching a node's content.

    This is for serving images and other binary content stored in the
    repository.
    """
    repository_lookup = {'label': repository_label}
    if not request.user.is_authenticated():
        repository_lookup['is_private'] = False
    repository = shortcuts.get_object_or_404(
        models.Repository, **repository_lookup)
    content = shortcuts.get_object_or_404(
        models.Content, pk=content_id)

    response = http.HttpResponse(
        basehttp.FileWrapper(StringIO(content.get_data())),
        content_type=content.get_mimetype())
    response['content-length'] = content.size
    return response


def node_diff(request, repository_label, from_revision, to_revision, path):
    """View a diff of two revisions at a node."""
    repository_lookup = {'label': repository_label}
    if not request.user.is_authenticated():
        repository_lookup['is_private'] = False
    repository = shortcuts.get_object_or_404(
        models.Repository, **repository_lookup)

    from_changeset = shortcuts.get_object_or_404(
        models.Changeset, repository=repository, revision=from_revision)
    to_changeset = shortcuts.get_object_or_404(
        models.Changeset, repository=repository, revision=to_revision)

    try:
        from_node = repository.get_node(path, from_revision)
    except exceptions.InvalidNode:
        revision = from_revision
        return shortcuts.render_to_response(
            'svnlit/node_invalid.html', locals(),
            context_instance=template.RequestContext(request))
    try:
        to_node = repository.get_node(path, to_revision)
    except exceptions.InvalidNode:
        revision = to_revision
        return shortcuts.render_to_response(
            'svnlit/node_invalid.html', locals(),
            context_instance=template.RequestContext(request))

    if not (from_node.is_file() and to_node.is_file()):
        raise http.Http404('Invalid node type for diff.')

    if from_node.content.is_binary() or to_node.content.is_binary():
        raise http.Http404('Cannot diff binary nodes.')

    form = forms.RepositoryDiffForm({
        'from_path': from_node.path, 'from_revision': from_node.revision,
        'to_path': to_node.path, 'to_revision': to_node.revision}, repository=repository)

    try:
        content_from = from_node.content.get_data().decode('utf-8')
    except UnicodeDecodeError:
        content_from = from_node.content.get_data().decode('gbk')

    try:
        content_to = to_node.content.get_data().decode('utf-8')
    except UnicodeDecodeError:
        content_to = to_node.content.get_data().decode('gbk')

    lexer = get_lexer(from_node.get_basename(), from_node.content.get_data())

    diff_data = diff.diff_lines(
        content_from,
        content_to, lexer.name)

    return shortcuts.render_to_response(
        'svnlit/node_diff.html', locals(),
        context_instance=template.RequestContext(request))


def repository_diff(request, repository_label):
    """View a diff of any two nodes in the repository."""
    repository_lookup = {'label': repository_label}
    if not request.user.is_authenticated():
        repository_lookup['is_private'] = False
    repository = shortcuts.get_object_or_404(
        models.Repository, **repository_lookup)

    form = forms.RepositoryDiffForm(repository=repository)

    # data posted by the diff form
    if request.method == 'POST':
        form = forms.RepositoryDiffForm(request.POST, repository=repository)
        if form.is_valid():
            from_node = form.cleaned_data['from_node']
            to_node = form.cleaned_data['to_node']

            if from_node.path == to_node.path:
                # if the path matches, redirect to the sugary url
                return http.HttpResponseRedirect(reverse(
                    'svnlit_node_diff', args=(
                     repository_label, from_node.revision,
                     to_node.revision, to_node.path)))
            else:
                # redirect to self with the nodes in the query string
                # to expose the copy+pastable url
                url = reverse(
                    'svnlit_repository_diff', args=(repository_label,))
                qs = 'from=%s&to=%s' % (
                    '%s:r%s' % (from_node.path, from_node.revision),
                    '%s:r%s' % (to_node.path, to_node.revision))
                url = '%s?%s' % (url, qs)
                return http.HttpResponseRedirect(url)

    # display the diff
    elif request.method == 'GET' and request.GET:
        if not (request.GET.get('from') and request.GET.get('to')):
            return http.HttpResponseRedirect(reverse(
                'svnlit_repository_diff', args=(repository_label,)))

        from_path, from_revision = (
            request.GET.get('from').split(':r', 1) + [''])[:2]
        to_path, to_revision = (
            request.GET.get('to').split(':r', 1) + [''])[:2]

        form = forms.RepositoryDiffForm({
                'from_path': from_path, 'from_revision': from_revision,
                'to_path': to_path, 'to_revision': to_revision}, repository=repository)

        if form.is_valid():
            from_node = form.cleaned_data['from_node']
            to_node = form.cleaned_data['to_node']

            diff_data = diff.diff(
                from_node.content.get_data(),
                to_node.content.get_data())

    return shortcuts.render_to_response(
        'svnlit/repository_diff.html', locals(),
        context_instance=template.RequestContext(request))
