#==============================================================================
# provision.py
# This is API library for Exosite's One-Platform provision interface.
#==============================================================================
##
## Tested with python 2.6
##
## Copyright (c) 2011, Exosite LLC
## All rights reserved.
##

import urllib, urllib2, socket
from urllib2 import Request, urlopen, URLError, HTTPError
# timeout in seconds
timeout = 5
socket.setdefaulttimeout(timeout)
PROVISION_BASE = '/provision'
PROVISION_ACTIVATE         = PROVISION_BASE +  '/activate'
PROVISION_DOWNLOAD         = PROVISION_BASE + '/download'
PROVISION_MANAGE           = PROVISION_BASE + '/manage'
PROVISION_MANAGE_MODEL     = PROVISION_MANAGE + '/model/'
PROVISION_MANAGE_CONTENT   = PROVISION_MANAGE + '/content/'
PROVISION_REGISTER         = PROVISION_BASE + '/register'

class Provision(object):
  def __init__(self, host='http://m2.exosite.com', manage_by_cik=True):
    self._host = host
    self._manage_by_cik = manage_by_cik

  def _filter_options(self, aliases=True, comments= True, historical=True):
    options = []
    if not aliases: options.append('noaliases')
    if not comments: options.append('nocomments')
    if not historical: options.append('nohistorical')
    return options

  def _request(self, path, key, data, method, is_cik=True, extra_headers={}):
    if method == "GET":
      url = self._host + path + '?' + data
      req = urllib2.Request(url)
    else:
      url = self._host + path
      req = urllib2.Request(url, data)
    #print url
    if is_cik:
      req.add_header('X-Exosite-CIK',key)
    else:
      req.add_header('X-Exosite-Token',key)
    req.add_header('Accept',
                   'text/plain, text/csv, application/x-www-form-urlencoded')
    for name in extra_headers.keys():
      req.add_header(name, extra_headers[name])
    req.get_method = lambda : method
    try:
      resp = urllib2.urlopen(req)
      resp_data = resp.read()
      resp.close()
      return resp_data
    except HTTPError, e:
      print 'Http error code: ' + str(e.code)
    except URLError, e:
      print 'Failed to reach server! Reason: ' + str(e.reason)
    except Exception,e:
      print "Caught exception from provision:", e
    return None

  def content_create(self, key, model, contentid, description):
    data = urllib.urlencode({'id':contentid, 'description':description})
    path = PROVISION_MANAGE_CONTENT + model + '/'
    return self._request(path, key, data, 'POST', self._manage_by_cik) != None

  def content_download(self, cik, vendor, model, contentid):
    data = urllib.urlencode({'vendor':vendor, 'model': model, 'id':contentid})
    headers = {"Accept":"*"}
    return self._request(PROVISION_DOWNLOAD, cik, data, 'GET', True, headers)

  def content_info(self, key, model, contentid, vendor=None):
    if not vendor: ## if no vendor name, key should be the owner one
      path = PROVISION_MANAGE_CONTENT + model + '/' + contentid
      return self._request(path, key, '', 'GET', self._manage_by_cik)
    else: ## if provide vendor name, key can be the device one
      data = urllib.urlencode({'vendor':vendor, 'model': model, \
              'id':contentid, 'info':'true'})
      return self._request(PROVISION_DOWNLOAD, key, data, 'GET')

  def content_list(self, key, model):
    path = PROVISION_MANAGE_CONTENT + model + '/'
    return self._request(path, key, '', 'GET', self._manage_by_cik)

  def content_remove(self, key, model, contentid):
    path = PROVISION_MANAGE_CONTENT + model + '/' + contentid
    return self._request(path, key, '', 'DELETE', self._manage_by_cik) != None

  def content_upload(self, key, model, contentid, data, mimetype):
    headers = {"Content-Type":mimetype}
    path = PROVISION_MANAGE_CONTENT + model + '/' + contentid
    return self._request(path, key, data  , 'POST', self._manage_by_cik, headers) != None

  def model_create(self, key, model ,clonerid,
                   aliases=True, comments=True, historical=True):
    options = self._filter_options(aliases, comments, historical)
    data = urllib.urlencode({'model': model, 'rid': clonerid,
                            'options[]':options}, doseq=True)
    return self._request(PROVISION_MANAGE_MODEL, key, data, 'POST', self._manage_by_cik) != None

  def model_info(self, key, model):
    return self._request(PROVISION_MANAGE_MODEL + model, key, '', 'GET', self._manage_by_cik)

  def model_list(self, key):
    return self._request(PROVISION_MANAGE_MODEL, key, '', 'GET', self._manage_by_cik)

  def model_remove(self, key, model):
    data = urllib.urlencode({ 'delete':'true', 'model':model, 'confirm':'true'})
    path = PROVISION_MANAGE_MODEL + model
    return self._request(path, key, data, 'DELETE', self._manage_by_cik) != None

  def model_update(self, key, model, clonerid,
                   aliases=True, comments= True, historical=True):
    options = self._filter_options(aliases, comments, historical)
    data = urllib.urlencode({'rid':clonerid, 'options[]':options}, doseq=True)
    path = PROVISION_MANAGE_MODEL + model
    return self._request(path, key, data, 'PUT', self._manage_by_cik) != None

  def serialnumber_activate(self, model, serialnumber, vendor):
    data = urllib.urlencode({'vendor':vendor, 'model':model, 'sn':serialnumber})
    return self._request(PROVISION_ACTIVATE, '', data, 'POST')

  def serialnumber_add(self, key, model, sn):
    data = urllib.urlencode({'add':'true', 'sn':sn})
    path = PROVISION_MANAGE_MODEL + model + '/'
    return self._request(path, key, data, 'POST', self._manage_by_cik) != None

  def serialnumber_add_batch(self, key, model, sns=[]):
    data = urllib.urlencode({'add':'true', 'sn[]':sns}, doseq=True)
    path = PROVISION_MANAGE_MODEL + model + '/'
    return self._request(path, key, data, 'POST', self._manage_by_cik) != None

  def serialnumber_disable(self, key, model, serialnumber):
    data = urllib.urlencode({'disable':'true'})
    path = PROVISION_MANAGE_MODEL + model + '/' + serialnumber
    return self._request(path, key, data, 'POST', self._manage_by_cik)

  def serialnumber_enable(self, key, model, serialnumber, owner):
    data = urllib.urlencode({'enable':'true', 'owner':owner})
    path = PROVISION_MANAGE_MODEL + model + '/' + serialnumber
    return self._request(path, key, data, 'POST', self._manage_by_cik)

  def serialnumber_info(self, key, model, serialnumber):
    path = PROVISION_MANAGE_MODEL + model + '/' + serialnumber
    return self._request(path, key, '', 'GET', self._manage_by_cik)

  def serialnumber_list(self, key, model, offset=0, limit=1000):
    data = urllib.urlencode({'offset':offset, 'limit':limit})
    path = PROVISION_MANAGE_MODEL + model + '/'
    return self._request(path, key, data, 'GET', self._manage_by_cik)

  def serialnumber_reenable(self, key, model, serialnumber):
    data = urllib.urlencode({'enable':'true'})
    path = PROVISION_MANAGE_MODEL + model + '/' + serialnumber
    return self._request(path, key, data, 'POST', self._manage_by_cik)

  def serialnumber_remap(self, key, model, serialnumber, oldsn):
    data = urllib.urlencode({'enable':'true', 'oldsn':oldsn})
    path = PROVISION_MANAGE_MODEL + model + '/' + serialnumber
    return self._request(path, key, data, 'POST', self._manage_by_cik) != None

  def serialnumber_remove(self, key, model, serialnumber):
    path = PROVISION_MANAGE_MODEL + model + '/' + serialnumber
    return self._request(path, key, '', 'DELETE', self._manage_by_cik) != None

  def serialnumber_remove_batch(self, key, model, sns):
    path = PROVISION_MANAGE_MODEL + model + '/'
    data = urllib.urlencode({'remove':'true', 'sn[]':sns}, doseq=True)
    return self._request(path, key, data, 'POST', self._manage_by_cik) != None

  def vendor_register(self, key, vendor):
    data = urllib.urlencode({'vendor':vendor})
    return self._request(PROVISION_REGISTER, key, data, 'POST') != None

  def vendor_unregister(self, key, vendor):
    data = urllib.urlencode({'delete':'true','vendor':vendor})
    return self._request(PROVISION_REGISTER, key, data, 'POST') != None
