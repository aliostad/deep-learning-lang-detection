import os

from nose.tools import istest, assert_equal

from mayo.repositories import repository_at, find_repository
from mayo.files import mkdir_p, temporary_directory

@istest
def none_is_returned_if_there_is_no_repository():
    with temporary_directory() as directory:
        assert_equal(None, repository_at(working_directory=directory))
        
@istest
def git_repository_is_returned_if_path_is_working_directory_of_git_repository():
    with temporary_directory() as directory:
        mkdir_p(os.path.join(directory, ".git"))
        repository = repository_at(directory)
        assert_equal("git", repository.type)
        
@istest
def hg_repository_is_returned_if_path_is_root_of_hg_repository():
    with temporary_directory() as directory:
        mkdir_p(os.path.join(directory, ".hg"))
        repository = repository_at(directory)
        assert_equal("hg", repository.type)
        
@istest
def working_directory_of_git_repository_is_directory_above_hidden_directory():
    with temporary_directory() as directory:
        mkdir_p(os.path.join(directory, ".git"))
        repository = repository_at(directory)
        assert_equal(directory, repository.working_directory)


@istest
def find_repository_returns_none_if_there_is_no_repository():
    with temporary_directory() as directory:
        assert_equal(None, find_repository(directory))
        
@istest
def find_repository_returns_git_repository_if_path_is_root_of_git_repository():
    with temporary_directory() as directory:
        mkdir_p(os.path.join(directory, ".git"))
        repository = find_repository(directory)
        assert_equal("git", repository.type)
        
@istest
def find_repository_searches_ancestors_for_working_directory():
    with temporary_directory() as directory:
        repository_path = os.path.join(directory, ".git")
        search_path = os.path.join(directory, "one/two/three")
        mkdir_p(repository_path)
        mkdir_p(search_path)
        repository = find_repository(search_path)
        assert_equal(directory, repository.working_directory)
