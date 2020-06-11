from dmqs.repository import Repository

def model_mock(model_name):
    model = type(model_name, (object,), dict(id=lambda s: s.__dict__['id']))
    instance = model()
    instance.id = None
    return instance

def test_repository_shared_state():
    repository1 = Repository()
    repository2 = Repository()

    assert id(repository1.__dict__) == id(repository2.__dict__)

def test_repository_clean():
    repository = Repository()
    repository.clean()

    model_name = 'ModelName'
    instance = model_mock(model_name)
    update = repository.save(model_name, instance)

    assert update == False
    assert repository.__dict__['data'][model_name] == [instance]
    assert type(repository.__dict__['data'][model_name]) == list
    assert repository.__dict__['data'][model_name][0].id == 1

    repository.clean()

    assert repository.__dict__['data'] == {}

def test_repository_save():
    repository = Repository()
    repository.clean()

    model_name = 'ModelName'
    instance = model_mock(model_name)
    update = repository.save(model_name, instance)

    assert update == False
    assert repository.__dict__['data'][model_name] == [instance]
    assert type(repository.__dict__['data'][model_name]) == list
    assert repository.__dict__['data'][model_name][0].id == 1

def test_repository_save_more():
    repository = Repository()
    repository.clean()

    model_name = 'ModelName'
    instance = model_mock(model_name)
    update1 = repository.save(model_name, instance)

    instance2 = model_mock(model_name)
    update2 = repository.save(model_name, instance2)

    assert update1 == False
    assert update2 == False
    assert repository.__dict__['data'][model_name] == [instance, instance2]
    assert type(repository.__dict__['data'][model_name]) == list
    assert repository.__dict__['data'][model_name][0].id == 1
    assert repository.__dict__['data'][model_name][1].id == 2

def test_repository_save_update():
    repository = Repository()

    model_name = 'ModelName'
    instance = model_mock(model_name)
    update = repository.save(model_name, instance)

    assert update == False
    assert repository.__dict__['data'][model_name] == [instance]
    assert type(repository.__dict__['data'][model_name]) == list
    assert repository.__dict__['data'][model_name][0].id == 1

    instance.__dict__['id'] = 2
    update = repository.save(model_name, instance)

    assert repository.__dict__['data'][model_name][0].id == 2
    assert update == True

def test_repository_get_models():
    repository = Repository()
    repository.clean()

    model_name = 'ModelName'
    instance = model_mock(model_name)
    update1 = repository.save(model_name, instance)

    instance2 = model_mock(model_name)
    update2 = repository.save(model_name, instance2)

    assert update1 == False
    assert update2 == False
    assert repository.get_models(model_name) == [instance, instance2]

def test_repository_delete():
    repository = Repository()
    repository.clean()

    model_name = 'ModelName'
    instance = model_mock(model_name)
    update1 = repository.save(model_name, instance)

    instance2 = model_mock(model_name)
    update2 = repository.save(model_name, instance2)

    assert update1 == False
    assert update2 == False

    delete1 = repository.delete(model_name, [instance])
    delete2 = repository.delete(model_name, [instance2])

    assert len(repository.get_models(model_name)) == 0
