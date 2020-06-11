from github_status.extensions import db
from github_status.models.helpers import count
from github_status.models.repositories import Repository


def test_count():
    Repository.query.delete()
    db.session.commit()

    assert 0 == count(Repository.url, '')
    assert 0 == count(Repository.url, '%')
    assert 0 == count(Repository.url, '%', True)

    db.session.add(Repository(url='user1/projectA'))
    db.session.commit()

    assert 0 == count(Repository.url, '%')
    assert 1 == count(Repository.url, '%', True)

    db.session.add(Repository(url='user1/projectB'))
    db.session.commit()

    assert 0 == count(Repository.url, 'user1/project')
    assert 1 == count(Repository.url, 'user1/projecta')
    assert 0 == count(Repository.url, 'user1/project%')
    assert 2 == count(Repository.url, 'user1/project%', True)
