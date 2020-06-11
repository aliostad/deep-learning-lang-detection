# Ensure no clash with future
from __future__ import absolute_import
# Celery Imports
from celery import shared_task
from celery.utils.log import get_task_logger
# Python Imports
from logging import getLogger
# Local Imports
from ava_core.evaluate.models import EvaluateController

# Logging
logger = get_task_logger(__name__)


# Implementation
@shared_task
def task_ava_evaluate_controller_run(controller_id):
    logger.debug('Task triggered'
                 ' - evaluate::task_ava_evaluate_controller_run')

    # Attempt to get the controller using passed id
    # Returning from function if failed
    try:
        controller = EvaluateController.objects.get(id=controller_id)
    except EvaluateController.DoesNotExist:
        logger.debug('Task error'
                     ' - evaluate::task_ava_evaluate_controller_run'
                     ' - EvaluateController.DoesNotExist')
        return

    controller.run_evaluate()


@shared_task
def task_ava_evaluate_controller_expire(controller_id):
    logger.debug('Task triggered'
                 ' - evaluate::task_ava_evaluate_controller_expire')

    # Attempt to get the controller using passed id
    # Returning from function if failed
    try:
        controller = EvaluateController.objects.get(id=controller_id)
    except EvaluateController.DoesNotExist:
        logger.debug('Task error'
                     ' - evaluate::task_ava_evaluate_controller_expire'
                     ' - EvaluateController.DoesNotExist')
        return

    controller.expire_evaluate()