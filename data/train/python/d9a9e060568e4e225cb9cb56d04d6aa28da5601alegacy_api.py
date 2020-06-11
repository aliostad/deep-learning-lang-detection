from . import api


# For backword compatibility
handlers = [
    ('/api/nodes', api.NodesHandler),
    ('/api/nodes/query', api.NodesQueryHandler),  # new node query api
    ('/api/nodes/(\d+)', api.NodesItemHandler),  # for legacy usage
    ('/api/user_nodes', api.UserNodesHandler),
    ('/api/nodes/(\d+)', api.NodesItemHandler),
    ('/api/nodes/domains', api.NodeDomainsAllHandler),
    ('/api/nodes/(\d+)/domains', api.NodeDomainsHandler),
    ('/api/nodes/(\d+)/domains/(\d+)', api.NodeDomainsItemHandler),
    ('/api/nodes/(\d+)/servers', api.NodeServersHandler),
    ('/api/server_search', api.ServerSearchHandler),
]
