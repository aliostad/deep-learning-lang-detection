from webindex.domain.services.rdf_service import *
from infrastructure.mongo_repos.area_repository import AreaRepository
from infrastructure.mongo_repos.observation_repository import ObservationRepository
from infrastructure.mongo_repos.indicator_repository import IndicatorRepository

__author__ = 'Miguel'

def run():
    area_repo = AreaRepository("localhost")
    indicator_repo = IndicatorRepository("localhost")
    observations_repo = ObservationRepository("localhost")
    observations = observations_repo.find_observations()["data"]
    rdf_service = RDFService(area_repo, indicator_repo)
    rdf_service.generate_dataset(observations)


if __name__ == '__main__':
    run()