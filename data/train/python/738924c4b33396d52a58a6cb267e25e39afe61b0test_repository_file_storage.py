from bbpgsql.repository_storage_filesystem import FilesystemCommitStorage
from tests.repository_test.repository_test_skeleton import (
    Skeleton_Repository_Operations_With_SpecificCommitStorage
    )


class Test_Repository_Operations_With_FileSystemCommitStore(
    Skeleton_Repository_Operations_With_SpecificCommitStorage):
    __test__ = True

    def setUp(self):
        self.setup_tempdir()
        self.repo_path = self.tempdir.makedir('repo')
        self.store = FilesystemCommitStorage(self.repo_path)
        self.setup_repository()

    def tearDown(self):
        self.teardown_tempdir()
