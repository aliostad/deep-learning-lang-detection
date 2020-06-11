import pprint

from park_api.org_api import OrgAPI
from park_api.campsite_api import CampsiteAPI


def print_all_orgs():
  org_api = OrgAPI()
  response_dict = org_api.get_all_orgs()
  pprint.pprint(response_dict)


def print_all_sites():
  camp_api = CampsiteAPI()
  response_dict = camp_api.get_all_sites()
  pprint.pprint(response_dict)


def print_site(site_id):
  camp_api = CampsiteAPI()
  campsites = camp_api.get_all_sites()
  print ''
  print ''
  print ''
  print 'campsite locations: '
  for site in campsites:
    print site.get_location()


def main():
  print_site(48)


if __name__ == '__main__':

  main()
