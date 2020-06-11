#-*- encoding:utf-8 -*-
#
#create date: 2015-03-17
#author: roy
#git repository manager view
#
import os

from django.shortcuts import render
from django.http import HttpResponseRedirect, HttpResponse
from git import *

from ..models import Repository
from gms.settings import GIT_REPOSITORIES
from gms.utils import get_current_time
from repository.lib.repo_options import RepoOptions
from repository.lib.utils import path_to_url


def repository_list(request):
    """all repository list"""

    repositories = [(index+1, item) for index, item in enumerate(Repository.objects.filter(active=True).order_by('-created_date'))]
    return render(request, 'repository/repository_page.html',
        {'repositories': repositories})


def repository_main(request, repo_id):
    """显示仓库目录信息"""

    reference_name = request.GET.get('reference_name', '')
    file_path = request.GET.get('file_path', '')

    repository = Repository.objects.get(id=repo_id)
    repo_option = RepoOptions(repository.path)
    repo = repo_option.repo

    last_commit = ''

    if not reference_name and repo.references:
        reference_name = repo.references[0].name
    #print "file_path:%s" % file_path
    if reference_name:
        last_commit = repo.commit(reference_name)

    result = repo_option.ls_tree(reference_name, file_path)

    request.session['repository_id'] = repo_id
    request.session['repository_name'] = repository.name

    href = '/repository/repository_main/%s?reference_name=%s' % (repo_id, reference_name)
    current_path = path_to_url(file_path, href)
    if current_path:
        current_path = '/' + current_path
    current_path = '<a href="/repository/repository_main/%s">%s</a>' % (repository.id, repository.name) + current_path

    commit_count = repo_option.reference_commit_count(reference_name)

    return render(request, 'repository/repository.html', {'repository': repository, 'references': repo.references,
        'current_reference': reference_name, 'last_commit': last_commit, 'file_list': result,
        'current_path': current_path, 'commit_count': commit_count})


def add_repository(request):
    """create new repository"""

    repository_name = request.POST.get('repository_name', '')
    repository_description = request.POST.get('repository_description', '')

    repository_path = os.path.join(GIT_REPOSITORIES, repository_name)
    if not repository_path.endswith('.git'):
        repository_path = ''.join([repository_path, '.git'])
    os.makedirs(repository_path)
    repo = Repo.init(repository_path, bare=True)

    repository = Repository(name=repository_name, path=repository_path, created_date=get_current_time(), description=repository_description)
    repository.save()

    return HttpResponseRedirect('/repository/repository_list/')


def repository_file_content(request, repo_id):
    """show repository file content"""

    revision = request.GET.get('revision', '')
    file_path = request.GET.get('file_path', '')
    repository = Repository.objects.get(id=repo_id)

    repo_option = RepoOptions(repository.path)
    file_content = repo_option.show_file_content(revision, file_path).replace('\n', '<br>')

    return render(request, 'repository/file_content.html', {'repository':repository, 'file_path': file_path,'file_content': file_content})


def reference_log(request, repo_id):
    """show refernce all log"""

    reference_name = request.GET.get('reference_name', '')

    repository = Repository.objects.get(id=repo_id)

    repo_option = RepoOptions(repository.path)
    status, all_commit = repo_option.commits(reference_name)

    commit_list = []
    if status:
        commit_date_list = []
        for commit in all_commit:
            if commit.committered_date not in commit_date_list:
                commit_date_list.append(commit.committered_date)

        for commit_date in commit_date_list:
            commit_obj = []
            for commit in all_commit:
                if commit.committered_date == commit_date:
                    commit_obj.append(commit)

            commit_list.append((commit_date, commit_obj))


    return render(request, 'repository/repository_log.html', {'repository': repository, 'all_commit': commit_list})


def show_commit(request, repo_id):
    """show commit detail info"""

    short_commit_id = request.GET.get('commit_id', '')
    repository = Repository.objects.get(id=repo_id)

    repo_option = RepoOptions(repository.path)

    lines = repo_option.show_object(short_commit_id).split('\n')

    is_merge = False
    commit_info =[]
    for line in lines:

        if line.startswith('+++'):
             commit_info.append(line+'<br><br>')
        elif line.startswith('+'):
             line = '<span style="background-color: #dbffdb;border-color: #c1e9c1;">%s</span>' % line
             commit_info.append(line)
        elif line.startswith('-'):
             line = '<span style=" background-color: #ffdddd;border-color: #f1c0c0;">%s</span>' % line
             commit_info.append(line)
        else:
            commit_info.append(line)

        if line.strip().startswith('Merge'):
            is_merge = True
    if is_merge:
        commit_info.append('<h4>合并Commit</h4>')

    return render(request, 'repository/commit.html', {'repository': repository, 'commit_info': commit_info})






