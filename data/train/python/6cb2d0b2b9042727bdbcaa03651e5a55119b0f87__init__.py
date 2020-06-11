from reader import db


class BaseManager:

    @staticmethod
    def save(model, *models):
        db.session.add(model)

        for model in models:
            db.session.add(model)

        db.session.commit()


from .category_unread_cache import CategoryUnreadCacheRepository
from .feed_unread_cache import FeedUnreadCacheRepository
from .category import CategoryRepository
from .entry import EntryRepository
from .feed import FeedRepository
from .user import UserRepository
from .user_entry import UserEntryRepository
from .user_feed import UserFeedRepository