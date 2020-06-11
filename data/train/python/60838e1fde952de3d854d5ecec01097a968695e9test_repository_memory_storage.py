from bbpgsql.repository_storage_memory import MemoryCommitStorage
from tests.repository_test.repository_test_skeleton import (
    Skeleton_Repository_Operations_With_SpecificCommitStorage
    )


class Test_Repository_Operations_With_MemoryCommitStorage(
    Skeleton_Repository_Operations_With_SpecificCommitStorage):
    __test__ = True

    def setUp(self):
        self.setup_tempdir()
        self.store = MemoryCommitStorage()
        self.setup_repository()

    def tearDown(self):
        self.teardown_tempdir()
