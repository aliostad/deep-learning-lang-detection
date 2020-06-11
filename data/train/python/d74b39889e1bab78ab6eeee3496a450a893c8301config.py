"""Build and check configuration for quattor documentation."""

import os
import ConfigParser
from vsc.utils import fancylogger

logger = fancylogger.getLogger()
cfgfile = ".docbuilder.cfg"


def check_repository_map(repository_map):
    """Check if a repository mapping is valid."""
    logger.info("Checking repository map.")
    if repository_map is None:
        logger.error("Repository map is None.")
        return False
    if len(repository_map) == 0:
        logger.error("Repository map is an empty list.")
        return False
    for repository in repository_map.keys():
        keys = repository_map[repository].keys()
        for opt in ['targets', 'sitesection']:
            if opt not in keys:
                logger.error("Respository %s does not have a '%s' in repository_map." % (repository, opt))
                return False
        if type(repository_map[repository]['targets']) is not list:
            logger.error("Repository %s targets is not a list." % repository)
            return False
    return True


def build_repository_map(location):
    """Build a repository mapping for repository_location."""
    logger.info("Building repository map in %s." % location)
    root_dirs = [f for f in os.listdir(location) if os.path.isdir(os.path.join(location, f))]
    repomap = {}
    for repo in root_dirs:
        logger.info("Checking %s." % repo)
        fullcfgfile = os.path.join(location, repo, cfgfile)
        if os.path.isfile(fullcfgfile):
            cfg = read_config(fullcfgfile)
            if cfg:
                repomap[repo] = cfg
            else:
                logger.warning("Invalid config file found in %s. Not using it." % repo)
        else:
            logger.warning("No config file found in %s. Not using it." % repo)

    if check_repository_map(repomap):
        return repomap
    else:
        return False


def read_config(configfile):
    """Read a given config file."""
    config = ConfigParser.ConfigParser()
    config.read(configfile)

    section = 'docbuilder'
    options = {}
    for option in ['sitesection', 'targets']:
        if config.has_option(section, option):
            options[option] = config.get(section, option)
        else:
            logger.error("Config %s does not have required option '%s'." % (configfile, option))
            return False
    # filter out empty strings from a list of strings
    options['targets'] = filter(None, options['targets'].split(','))

    if config.has_option(section, "subdir"):
        options["subdir"] = config.get(section, "subdir")
    else:
        options["subdir"] = None

    return options
