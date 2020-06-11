# 3RD PARTY
from django.db import models

# DJANGAE
from djangae.contrib.consistency.consistency import (
    handle_post_save,
    handle_post_delete,
)


POST_SAVE_UID = "consistency_post_save"
POST_DELETE_UID = "consistency_post_delete"


def connect_signals():
    models.signals.post_save.connect(handle_post_save, dispatch_uid=POST_SAVE_UID)
    models.signals.post_save.connect(handle_post_delete, dispatch_uid=POST_DELETE_UID)


def disconnect_signals():
    models.signals.post_save.disconnect(dispatch_uid=POST_SAVE_UID)
    models.signals.post_save.disconnect(dispatch_uid=POST_DELETE_UID)
