from dbs.apis.dbsClient import DbsApi

class DBS3ApiFactory(object):
    def __init__(self, config):
        self.config = config

    def get_api(self):
        return DbsApi(url=self.config.get("url","https://cmsweb.cern.ch/dbs/int/global/DBSReader/"))

def create_api(api="DbsApi", config={}):
    known_factory = {'DbsApi': DBS3ApiFactory(config)}

    factory = known_factory.get(api,None)

    if not factory:
        raise NotImplementedError, "A factory for api %s has not yet been implemented." % (api)

    return factory.get_api()

if __name__ == "__main__":
    api = create_api(api="DbsApi",config=dict(url="https://cmsweb.cern.ch/dbs/int/global/DBSReader/"))
    print dir(api)
