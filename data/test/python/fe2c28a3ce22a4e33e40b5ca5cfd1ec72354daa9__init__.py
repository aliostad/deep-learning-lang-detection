import loaders
loader = loaders.Lazy(
    '%s.models' % __name__,
    ('Upload',)
)

import extensions
from .functions import (
    delete,
    save,
    save_file,
    save_images,
)
from .models import Upload


def init(db, Storage, resizer=None):
    if 'upload' in db.metadata.tables:
        return  # Already registered the model.

    extensions.db = db
    extensions.resizer = resizer
    extensions.Storage = Storage
    loader.ready()

__all__ = (
    delete,
    init,
    save,
    save_file,
    save_images,
    Upload,
)
