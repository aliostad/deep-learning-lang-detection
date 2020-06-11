from . import api
from server.controllers.external_resources import CompanyScraperAPI, PeopleScraperAPI, GetJobsAPI
from server.controllers.companies import CompaniesAPI, CompanyAPI
from server.controllers.jobs import JobsAPI, JobAPI
from server.controllers.people import PeopleAPI, PersonAPI
from server.controllers.users import UsersAPI
from server.controllers.sessions import SessionsAPI
from server.controllers.applications import ApplicationsAPI
from server.controllers.events import EventsAPI
from server.controllers.notes import NotesAPI

api.add_resource(CompanyScraperAPI, '/web/companies')

api.add_resource(PeopleScraperAPI, '/web/people')

api.add_resource(GetJobsAPI, '/web/jobs')

api.add_resource(CompaniesAPI, '/api/companies')

api.add_resource(CompanyAPI, '/api/companies/<int:id>')

api.add_resource(JobsAPI, '/api/companies/<int:company_id>/jobs')

api.add_resource(JobAPI, '/api/companies/<int:company_id>/jobs/<int:id>')

api.add_resource(PeopleAPI, '/api/companies/<int:company_id>/people')

api.add_resource(PersonAPI, '/api/companies/<int:company_id>/people/<int:id>')

api.add_resource(UsersAPI, '/api/users')

api.add_resource(SessionsAPI, '/api/sessions')

api.add_resource(ApplicationsAPI, '/api/applications')

api.add_resource(EventsAPI, '/api/applications/<int:application_id>/events')

api.add_resource(NotesAPI, '/api/applications/<int:application_id>/notes')
