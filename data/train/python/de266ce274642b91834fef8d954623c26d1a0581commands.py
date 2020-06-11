from bookie_api.api import AdminApi
from bookie_api.api import BmarkApi
from bookie_api.api import UserApi


# #############
# User Commands
# #############
def ping(cfg, args):
    """Perform a ping to check config."""
    api = UserApi(cfg.api_url, cfg.username, cfg.api_key)
    api.ping()


# ###############
# Admin Commands
# ###############
def applog(cfg, args):
    """Load the applog entries."""
    api = AdminApi(cfg.api_url, cfg.username, cfg.api_key)
    api.applog(
       args.days,
       args.status,
       args.filter)

def to_readable(cfg, args):
    """Check the list of urls we need to readable parse still."""
    api = AdminApi(cfg.api_url, cfg.username, cfg.api_key)
    api.to_readable()

def readable_reindex(cfg, args):
    """Reindex all the bookmarks in the system."""
    api = AdminApi(cfg.api_url, cfg.username, cfg.api_key)
    api.readable_reindex()


def invite_list(cfg, args):
    """Handle the invite list call."""
    api = AdminApi(cfg.api_url, cfg.username, cfg.api_key)
    api.invite_status()


def invite_set(cfg, args):
    """Handle the invite set call to add invites to a user."""
    api = AdminApi(cfg.api_url, cfg.username, cfg.api_key)
    api.invite_set(args.username, args.invite_ct)


def import_list(cfg, args):
    """Fetch some data """
    api = AdminApi(cfg.api_url, cfg.username, cfg.api_key)
    api.import_list()


def import_reset(cfg, args):
    """Reset an import back to reprocess"""
    api = AdminApi(cfg.api_url, cfg.username, cfg.api_key)
    api.import_reset(args.id)


def user_list(cfg, args):
    """List the users in the system."""
    api = AdminApi(cfg.api_url, cfg.username, cfg.api_key)
    api.user_list()


def user_add(cfg, args):
    """Add a new user to the system."""
    api = AdminApi(cfg.api_url, cfg.username, cfg.api_key)
    api.new_user(args.username, args.email)


def del_user(cfg, args):
    """Remove a user from the system."""
    api = AdminApi(cfg.api_url, cfg.username, cfg.api_key)
    api.del_user(args.username)


def del_bookmark(cfg, args):
    """Delete a bookmark from the system.

    Admins can specify a username with --username flag.

    """
    api = BmarkApi(cfg.api_url, cfg.username, cfg.api_key)
    username = cfg.username
    is_admin = False
    if args.username:
        username = args.username
        is_admin = True

    api.delete(username, args.hash_id, is_admin=is_admin)
