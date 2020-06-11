from views.main import MainPage
from views.about import AboutPage
from views.contact import ContactPage
from views.projects import ProjectsPage
from views.contributors import ContributorsPage
from views.api.project import ProjectApi
from views.api.commit import CommitApi
from views.api.contributor import ContributorApi
from views.login import Success

routes = [
    ('/', MainPage),
    ('/success', Success),
    ('/about', AboutPage),
    ('/contact', ContactPage),
    ('/projects', ProjectsPage),
    ('/projects/(\d+)', ProjectsPage),
    ('/contributors', ContributorsPage),
    ('/contributors/(\d+)', ContributorsPage),
    ('/api/project', ProjectApi),
    ('/api/project/(\d+)', ProjectApi),
    ('/api/commit', CommitApi),
    ('/api/commit/(.*)', CommitApi),
    ('/api/contributor', ContributorApi),
    ('/api/contributor/(\d+)', ContributorApi),
]