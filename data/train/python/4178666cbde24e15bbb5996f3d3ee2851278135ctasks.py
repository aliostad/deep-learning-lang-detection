#!/usr/bin/env python

if __name__ == "__main__":
    import dev_appserver
    dev_appserver.fix_sys_path()

import os, webapp2, logging, datetime
from xml.dom.minidom import Text, Element, Document

from models import SharkAttack, Country, Country, Area
from utils import StringUtils
from repositories import SharkAttackRepository, CountryRepository, AreaRepository, PlaceSummary

class SummaryGenerator():
    def __init__(self):
        self._sharkAttackRepository = SharkAttackRepository()
        self._countryRepository = CountryRepository()
        self._areaRepository = AreaRepository()

    def generateCountrySummaries(self):
        for country in self._countryRepository.getCountries():
            attacksForCountry = self._sharkAttackRepository.getDescendantAttacksForCountry(country.urlPart)
            ps = PlaceSummary(attacksForCountry)
            self._countryRepository.updatePlaceSummary(country, ps)
            message = "Generated place summary for %s.\n%s\n" % (country.name, ps)
            logging.info(message)
            yield message

class GenerateSummaries(webapp2.RequestHandler):
    def __init__(self, request, response):
        self.initialize(request, response)
        self._sg = SummaryGenerator()

    def get(self):
        for message in self._sg.generateCountrySummaries():
            self.response.out.write(message)


if __name__ == "__main__":
    from mocks.repositories import SharkAttackRepository, CountryRepository, AreaRepository

    sg = SummaryGenerator()
    sg.generateCountrySummaries()
    for country in sg._countryRepository.getCountries():
        print "%s: %s" % (country.name, country.place_summary)
