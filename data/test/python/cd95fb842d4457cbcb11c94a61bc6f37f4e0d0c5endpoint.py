from enum import Enum

class EndPoint(Enum):
    static = "/s"
    aggregators = "/api/aggregators"
    annotation = "/api/annotation"
    config = "/api/config"
    dropcaches = "/api/dropcaches"
    put = "/api/put"
    query = "/api/query"
    search = "/api/search"
    lookup = "/api/search/lookup"
    serializers = "/api/serializers"
    stats = "/api/stats"
    suggest = "/api/suggest"
    tree = "/api/tree"
    uid = "/api/uid"
    version = "/api/version"

    def __str__(self):
        return self.value
