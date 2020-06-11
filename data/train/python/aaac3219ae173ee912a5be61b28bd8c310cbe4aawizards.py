from django.shortcuts import render
from django.contrib.formtools.wizard.views import SessionWizardView

from pumpkin import forms


NEW_PROJECT_FORMS = [('project', forms.NewProjectForm),
                     ('repository', forms.NewRepositoryForm),
                     ('server', forms.NewServerForm)]
NEW_PROJECT_TEMPLATE = {
    'project': 'project/create/project.html',
    'repository': 'project/create/repository.html',
    'server': 'project/create/server.html',
}

class NewProjectWizard(SessionWizardView):


    def get_template_names(self):
        return [NEW_PROJECT_TEMPLATE[self.steps.current]]

    def done(self, form_list, **kwargs):
        project_form, repository_form, server_form = form_list
        project = project_form.save(commit=False)
        repository = repository_form.save(commit=False)
        repository.name = '%s Repository' % project.name
        repository.save()
        server = server_form.save(commit=False)
        server.name = '%s Server Test' % project.name
        server.superuser_login = 'root'
        server.save()
        project.server = server
        project.repository = repository
        project.save()
        project.managers.add(self.request.user)
        return render(self.request, 'project/create/done.html', {
            'project': project,
        })
