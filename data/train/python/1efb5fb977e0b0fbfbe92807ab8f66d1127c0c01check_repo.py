"""Script that checks if a repository has the required files."""

from pjohansson.session3 import CourseRepo, RepositoryDirectory
import os
import sys

relative_path = sys.argv[1]

# Guard against errors from not being able to split one-directory paths
with RepositoryDirectory(relative_path):
    full_path = os.getcwd()

# Split into repository and surname directories, check structure
(repository, surname) = full_path.rstrip('/').rsplit('/', 1)

with RepositoryDirectory(repository):
    repo = CourseRepo(surname)
    if repo.check():
        print "TRUE"
    else:
        print "FALSE"
