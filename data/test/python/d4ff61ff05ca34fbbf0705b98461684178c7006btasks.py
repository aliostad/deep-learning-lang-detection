from mc2 import the_celery_app


@the_celery_app.task(serializer='json')
def start_new_controller(project_id):
    from mc2.controllers.base.models import Controller

    controller = Controller.objects.get(pk=project_id)
    controller.get_builder().build()


@the_celery_app.task(serializer='json')
def update_marathon_app(project_id):
    from mc2.controllers.base.models import Controller

    controller = Controller.objects.get(pk=project_id)
    controller.update_marathon_app()


@the_celery_app.task(serializer='json')
def marathon_restart_app(project_id):
    from mc2.controllers.base.models import Controller

    controller = Controller.objects.get(pk=project_id)
    controller.marathon_restart_app()


@the_celery_app.task(serializer='json')
def marathon_destroy_app(project_id):
    from mc2.controllers.base.models import Controller

    controller = Controller.objects.get(pk=project_id)
    controller.marathon_destroy_app()
    controller.delete()
