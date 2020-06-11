from .base import Base


class Changeset(Base):

    def __get__(self, repository_id=None, revision=None, is_diff=False, page=1, per_page=10):
        '''
        GET /api/changesets.json
        GET /api/changesets/repository.json?repository_id={REPOSITORY_ID}
        GET /api/changesets/{REVISION}.json?repository_id={REPOSITORY_ID}
        GET /api/changesets/{REVISION}/differences.json?repository_id={REPOSITORY_ID}
        Parameter {REVISION} uses revision number instead unique ID
        '''

        if repository_id is None:
            url = 'changesets.json?page=' + str(page) + '&per_page=' + str(per_page)
        elif revision is None:
            url = 'changesets/repository.json?repository_id=' + str(repository_id) + '&page=' + str(page) + '&per_page=' + str(per_page)
        elif is_diff is False:
            url = 'changesets/' + revision + '.json?repository_id=' + str(repository_id)
        else:
            url = 'changesets/' + revision + '/differences.json?repository_id=' + str(repository_id)

        return self._do_get(url)

    def find_all(self, page=1, per_page=10):
        return self.__get__(page=page, per_page=per_page)

    def find_from_repo(self, repository_id, page=1, per_page=10):
        return self.__get__(repository_id=repository_id, page=page, per_page=per_page)

    def get_revision(self, repository_id, revision):
        return self.__get__(repository_id=repository_id, revision=revision, is_diff=False)

    def get_diff(self, repository_id, revision):
        return self.__get__(repository_id=repository_id, revision=revision, is_diff=True)
