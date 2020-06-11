from .core import sudo
from .decorator import dispatch


@dispatch('package')
def ensure(repository):
    """
    Tests if the given repository is installed, and installs it in case it's not
    already there.
    """


# -----------------------------------------------------------------------------
# APT REPOSITORY (DEBIAN/UBUNTU)
# -----------------------------------------------------------------------------


def ensure_apt(repository):
    sudo("add-apt-repository {0}".format(repository))


# -----------------------------------------------------------------------------
# YUM REPOSITORY (RedHat, CentOS)
# added by Prune - 20120408 - v1.0
# -----------------------------------------------------------------------------


def ensure_yum(repository):
    raise NotImplementedError("Not implemented for yum")


# -----------------------------------------------------------------------------
# ZYPPER REPOSITORY (openSUSE)
# -----------------------------------------------------------------------------


def ensure_zypper(repository):
    repository_uri = repository
    if repository[-1] != '/':
        repository_uri = repository.rpartition("/")[0]
    status = run("zypper --non-interactive --gpg-auto-import-keys repos -d")
    if status.find(repository_uri) == -1:
        sudo(("zypper --non-interactive --gpg-auto-import-keys "
              "addrepo {0}").format(repository))
        sudo(("zypper --non-interactive --gpg-auto-import-keys "
              "modifyrepo --refresh {0}").format(repository_uri))
