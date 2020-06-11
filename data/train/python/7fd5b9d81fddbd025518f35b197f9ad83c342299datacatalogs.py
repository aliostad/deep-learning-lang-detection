from ckan.application import CkanApplication
from ckanclient import CkanClient
from config import config
from ckan.package import Package

class DataCatalogs():
    def __init__(self):
        self.ckan_app = CkanApplication()

    def get_ckan_packages(self):
        package_list = self.ckan_app.get_full_package_list()
        packages = []
        for package in package_list:
            if('ckan' in package.groups):
                packages.append(package)
        return packages

    def get_ckan_api_list(self):
        return [
                'http://it.ckan.net/api',
                'http://datospublicos.org/api',
                'http://dati.trentino.it/api',
                'http://dadosabertos.senado.gov.br/api',
                'http://thedatahub.org/api',
                'http://publicdata.eu/api',
                'http://opengov.es/api',
                'http://ie.ckan.net/api',
                'http://rs.ckan.net/api',
                'http://open-data.europa.eu/en/data/api',
                'http://hub.healthdata.gov/api',
                'http://data.buenosaires.gob.ar/api',
                'http://opendata.aragon.es/api',
                'http://dati.toscana.it/api',
                'http://www.datagm.org.uk/api',
                'http://www.opendata-hro.de/api',
                'http://datakilder.no/api',
                'http://fi.thedatahub.org/api',
                #'http://www.opendatahub.it/api', - a lot of RDF sent a e-mail to them
                'http://data.gov.uk/api',
                'http://data.openpolice.ru/api',
                'http://www.daten.rlp.de/api',
                'http://data.cityofsantacruz.com/api',
                'http://br.ckan.net/api',
                'http://data.qld.gov.au/api',
                'http://cz.ckan.net/api',
                'http://ckan.emap.fgv.br/api',
                'http://data.opencolorado.org/api',
                'http://www.opendata.provincia.roma.it/api',
                'http://offenedaten.de/api',
                'http://www.data.gv.at/katalog/api',
                'http://iatiregistry.org/api',
                'http://www.nosdonnees.fr/api',
                'http://dados.novohamburgo.rs.gov.br/api',
                'http://thedatahub.kr/api',
                'http://dados.gov.br/api',
               ]

    def get_package_list_for_all(self):
        api_list = self.get_ckan_api_list()
        for api in api_list:
            ckan = CkanClient(base_location=api,
                              api_key=config.ckan_api_key)
            for package in ckan.package_list():
                break



if __name__ == "__main__":
    dc = DataCatalogs()
    dc.get_package_list_for_all()
