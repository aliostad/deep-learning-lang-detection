import domain
import knot

# container bootstrap
container = knot.Container({
    'db.fqn': 'sqlite:///:memory:',
    'db.echo': False
})

domain.apply_to_container(container)


# Relational example
user_repository = container('models_user_repository')
company_repository = container('models_company_repository')
position_repository = container('models_position_repository')

# insert
company = company_repository.new(name='Tyba')
position = position_repository.new(title='Superb job', company=company)

users = (
    user_repository.new(email='maximo@tyba.com'),
    user_repository.new(email='miguel@tyba.com')
)

[position.candidates.append(u) for u in users]

position_repository.insert(position)

# find
query = position_repository.create_query().find_by_company(company)
found = position_repository.find(query).one()

print 'Position: %s @ %s, Candidate(s): %d' % (
    found.title,
    found.company.name,
    len(found.candidates)
)

for candidate in found.candidates:
    print '\tCandidate %s' % candidate.email
