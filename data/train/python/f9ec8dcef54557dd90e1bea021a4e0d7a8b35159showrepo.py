# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

from django.core.management.base import BaseCommand, CommandError

from website.models import *
from website.management.command import UICommand

from optparse import make_option
import re

class Command(UICommand):
    help = "Shows details about existing repositories."
    args = "[name]"

    def handle(self, *args, **kwargs):
        if len(args) == 0:
            for repository in Repository.objects.all():
                state = "*"
                if repository.hidden:
                    state = " "
                print("%s %s %s" % (state, repository.name, repository.url))
        else:
            for name in args:
                repository = Repository.objects.get(name = name)
                print("Name: %s" % repository.name)
                print("URL: %s" % repository.url)
                print("Range: %s" % repository.range)
                pushes = Push.objects.filter(repository = repository)
                print("Indexed pushes: %d" % len(pushes))
                print("Indexed changesets: %d" % Changeset.objects.filter(pushes__push__repository = repository).count())
