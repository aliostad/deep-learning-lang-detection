import domain
import knot


# container bootstrap
container = knot.Container({
    'db.fqn': 'sqlite:///:memory:',
    'db.echo': False
})

domain.apply_to_container(container)

# Plain case
user_repository = container('models_user_repository')

# insert
user = user_repository.new(email='maximo@tyba.com')
user.first_name = 'Maximo'
user.password = '123456'
user_repository.insert(user)
print 'User created with id %d' % user.id


# find
query = user_repository.create_query().\
    find_by_email('maximo@tyba.com').\
    find_active()

found = user_repository.find(query).one()
print 'User %s was created at %s' % (found.email, found.created_at)

# delete
user_repository.delete(found)
found = user_repository.find(query).all()
if len(found) == 0:
    print 'Deleted success!'
