# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

permissions = Permission.create([
	{ slug: 'manage_company', name: 'Manage company', description: 'Complete management of the company account' },

	{ slug: 'manage_permissions', name: 'Manage permissions', description: '' },
	{ slug: 'manage_categories', name: 'Manage categories', description: '' },
	{ slug: 'manage_implementation_states', name: 'Manage implementation states', description: '' },
	{ slug: 'manage_recommendation_states', name: 'Manage recommendation states', description: '' },

	{ slug: 'create_technologies', name: 'Create & edit technologies', description: '' },
	{ slug: 'delete_technologies', name: 'Delete/archive technologies', description: '' },
	{ slug: 'post_recommendations', name: '', description: 'Mark technology recommendations' },

	{ slug: 'create_products', name: 'Create & edit products', description: '' },
	{ slug: 'delete_products', name: 'Delete/archive technologies', description: '' },
	{ slug: 'post_implementations', name: 'Post implementation states', description: 'Link products to technologies' }
])