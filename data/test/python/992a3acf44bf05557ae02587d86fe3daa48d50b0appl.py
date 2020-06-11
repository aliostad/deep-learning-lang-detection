#!/usr/bin/env python
# -*- coding: utf-8 -*-

import falcon

from objectstore.api import service 
from objectstore.api import buckets 
from objectstore.api import objects 

api = application = falcon.API()

storage_path='/data/objectstore/'

api.add_route('/service', service.ServiceAPI(storage_path=storage_path))
api.add_route('/bucket', buckets.BucketCollectionAPI(storage_path=storage_path))
api.add_route('/bucket/{bucket_name}', buckets.BucketAPI(storage_path=storage_path))
api.add_route('/bucket/{bucket_name}/object/{object_id}', objects.ObjectAPI(storage_path=storage_path))


