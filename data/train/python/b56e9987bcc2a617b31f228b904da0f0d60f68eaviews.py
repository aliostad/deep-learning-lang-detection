import json

from django.http import HttpResponse, HttpResponseServerError
from django.shortcuts import render, get_object_or_404, redirect
from django.core.urlresolvers import reverse

from linted.tasks import scan_repository
from linted.models import Repository, RepositoryKey, RepositoryScan, RepositoryScanner, Scanner
from linted.forms import RepositoryForm, RepositoryScannerForm
from scanners.settings import ScannerSettings

from Crypto.PublicKey import RSA


def index(request):
    return HttpResponse('ok')


def repository_list(request):
    repositories = Repository.objects.all()
    render_data = {
        'repo_colours': ['#90BD3C', '#F7E277', '#FD7D00'],
        'repository_list': repositories
    }
    return render(request, 'repository_list.html', render_data)


def view_repoository(request, uuid):
    repository = get_object_or_404(Repository, uuid=uuid)
    scan_url = request.build_absolute_uri(reverse('scan_repository', args=(repository.uuid,)))

    render_data = {
        'repository': repository,
        'scan_url': scan_url
    }

    return render(request, 'view_repository.html', render_data)


def view_scan(request, uuid):
    scan = get_object_or_404(RepositoryScan, uuid=uuid)

    return render(request, 'view_scan.html', {'scan': scan})


def run_scan(request, uuid):
    repository = get_object_or_404(Repository, uuid=uuid)

    scan_repository.delay(repository.id)

    return HttpResponse('Queued repo scan')


def create_repository(request):
    if request.method == 'POST':
        repository_form = RepositoryForm(request.POST)
        if repository_form.is_valid():
            repository = repository_form.save(commit=False)
            repository.owner = request.user
            repository.save()

            #Generate keypair for repo
            keypair = RSA.generate(2048)
            private_key = keypair.exportKey('PEM')
            public_key = keypair.publickey().exportKey('OpenSSH')

            repository_key = RepositoryKey()
            repository_key.repository = repository
            repository_key.private_key = private_key
            repository_key.public_key = public_key
            repository_key.save()

            return redirect(reverse('view_repository', args=(repository.uuid,)))
    else:
        repository_form = RepositoryForm()

    return render(request, 'create_repository.html', {
        'form': repository_form,
    })


def add_scanner(request, repo_uuid):
    repository = Repository.objects.get(uuid=repo_uuid)
    if request.method == 'POST':
        form = RepositoryScannerForm(request.POST)
        repo_scanner = form.save(commit=False)
        if form.is_valid():
            repo_scanner.repository = repository
            repo_scanner.save()

        return redirect(reverse('view_repository', args=(repository.uuid,)))
    else:
        form = RepositoryScannerForm()

    return render(request, 'add_scanner.html', {
        'form': form,
        'repository': repository
    })


def scanner_settings(request, uuid, scanner_name):
    repository = get_object_or_404(Repository, uuid=uuid)
    scanner = get_object_or_404(Scanner, short_name=scanner_name)
    repository_scanner = get_object_or_404(RepositoryScanner, repository=repository, scanner=scanner)

    try:
        settings = ScannerSettings(repository_scanner)

        if request.method == 'POST':
            settings.clear_settings()
            scanner_settings_form = scanner.scanner_class.settings_form(request.POST)

            if scanner_settings_form.is_valid():
                for field_name, value in request.POST.items():
                    if '/property/' in field_name:
                        ruleset, rule, _ , property = field_name.split('/')
                        settings.add_custom_rule(ruleset, rule, property, value)
                    elif '/' in field_name:
                        ruleset, rule, property = field_name.split('/')
                        if property == 'enabled':
                            enabled_value = (value == 'true')
                            settings.set_rule_enabled(ruleset, rule, enabled_value)


                settings.set_scanner_config(scanner_settings_form.cleaned_data)
                settings.save()
        else:
            scanner_settings_form = scanner.scanner_class.settings_form(initial=settings.get_scanner_config())

        return render(request, 'scanner_settings.html', {
            'repository': repository,
            'scanner': scanner,
            'settings_form': scanner_settings_form,
            'settings': settings
        })
    except IOError:
        return HttpResponseServerError("There was a problem loading your repository settings.")