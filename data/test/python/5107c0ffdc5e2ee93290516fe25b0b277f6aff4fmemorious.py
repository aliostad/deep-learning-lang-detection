import django_memorious

import datetime
from django import template
from django.conf import settings
from django.core import urlresolvers

from mercurial.node import hex


register = template.Library()


def memoize(function):
    memo = {}
    def decorated_function(*args):
        result = memo.get(args, None)
        if result is None:
            result = function(*args)
            memo[args] = result
        return result
    return decorated_function


@memoize
def get_url(repository_name, path):
    repository = django_memorious.get_repository(repository_name)
    if getattr(settings, "MEMORIOUS_DEBUG", False):
        revision = None
    else:
        revision = repository.current_revision

    url = urlresolvers.reverse(
        'memorious', 
        kwargs={"repository": repository_name,
                "revision": revision,
                "name": path})
    return url


class MemoriousNode(template.Node):

    def __init__(self, repository, path):
        self.repository = repository
        self.path = path

    def render(self, context):
        return get_url(self.repository, self.path)


@register.tag(name="memorious")
def parse_memorious(parser, token):
    try:
        args = token.contents.split()
        tag_name = args[0]
        path = args[1]
        if len(args)>=3:
            repository = args[2]
        else:
            repository = "'default'"
    except ValueError:
        raise template.TemplateSyntaxError(
            "%r tag requires a single argument" % tag_name)
    if repository[0] == repository[-1] and repository[0] in ('"', "'"):
        repository = repository[1:-1]
    else:
        raise template.TemplateSyntaxError(
            "%r tag's arguments should be in quotes" % tag_name)
    if path[0] == path[-1] and path[0] in ('"', "'"):
        path = path[1:-1]
    else:
        raise template.TemplateSyntaxError(
            "%r tag's argument should be in quotes" % tag_name)
    return MemoriousNode(repository, path)
