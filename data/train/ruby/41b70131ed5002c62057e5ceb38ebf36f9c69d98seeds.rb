# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Subscription Types
subscription_types = SubscriptionType.create([
	{
		title: 'Lite',
		description: 'This account type is free and allows you basic features to manage your events.',
		price: 0.00,
		feature_list: 'Create and Manage Adult Events (Up to 5 Active Events)|Create and Manage Kids and Youth Events|Accept and Manage Attendee Registrations for Adult Events|Accept and Manage Attendee Registrations for Kid and Youth Events|Create and Manage Classrooms|Assign Kids to Classrooms|View and Manage Attendance Rolls'
	},
	{
		title: 'Standard',
		description: 'This account type includes many great features to help you manage your events.',
		price: 9.00,
		feature_list: 'Create and Manage Adult Events|Create and Manage Kids and Youth Events|Accept and Manage Attendee Registrations for Adult Events|Accept and Manage Attendee Registrations for Kid and Youth Events|Accept and Manage Volunteer Registrations|Create and Manage Classrooms|Create and Manage Event Roles|Assign Volunteers To Classrooms Per Event|Assign Kids to Classrooms|Assign Volunteers To Event Roles|View and Print Nametags|View and Print Roll Sheets|View and Manage Attendance Rolls|Upload and Share Event Documents (release and medical forms) with Attendees|Accept and Keep Record of Payment for Event Registrations'
	},
	{
		title: 'Pro',
		description: 'The pro version includes all of our great features to automate so many of those repetitive tasks when managing events.',
		price: 25.00,
		feature_list: 'Create and Manage Adult Events|Create and Manage Kids and Youth Events|Create and Manage Event Registration Websites|Accept and Manage Attendee Registrations for Adult Events|Accept and Manage Attendee Registrations for Kid and Youth Events|Accept and Manage Volunteer Registrations|Create and Manage Classrooms|Create and Manage Event Roles|Assign Volunteers To Classrooms Per Event|Assign Kids to Classrooms|Assign Volunteers To Event Roles|View and Print Nametags|View and Print Roll Sheets|View and Manage Attendance Rolls|Upload and Share Event Documents (release and medical forms) with Attendees|Send Texts and Emails to Event Volunteers|Send Texts and Emails to Event Attendees|Record and Send Voice Messages to Event Volunteers|Record and Send Voice Messages to Event Attendees|Accept and Keep Record of Payment for Event Registrations|Import Existing Database Contacts'
	}
])

# Default Organization (for setup wizard, must have an organization to assign to AdminUser)
Organization.create(title: 'Light Post Events', contact_phone: '(214) 810-6399', contact_email: 'info@lightpostevents.com', description: 'Light Post Events', subdomain: 'default')