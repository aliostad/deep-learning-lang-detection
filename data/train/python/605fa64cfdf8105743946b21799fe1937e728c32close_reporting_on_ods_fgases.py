#this is meant to be run from instance debug
#>>> from Products.Reportek.updates import close_reporting_on_ods_fgases
#>>> close_reporting_on_ods_fgases.forwards(app)

import transaction

def cut_permissions(folder):
  folder.manage_permission('Access contents information',
                            roles=['Anonymous', 'Manager'])
  folder.manage_permission('Add Documents, Images, and Files',
                            roles=['Manager'])
  folder.manage_permission('Add Envelopes', roles=['Manager'])
  folder.manage_permission('Audit Envelopes',
                            roles=['ClientFG', 'ClientODS', 'Manager'])
  folder.manage_permission('Change Collections', roles=['Manager'])
  folder.manage_permission('Change Envelopes', roles=['Manager'])
  folder.manage_permission('Delete objects', roles=['Manager'])
  folder.manage_permission('Manage properties', roles=['Manager'])
  folder.manage_permission('Release Envelopes',
                            roles=['ClientFG', 'ClientODS', 'Manager'])
  folder.manage_permission('Take ownership', roles=['Manager'])
  folder.manage_permission('Use OpenFlow',
                            roles=['ClientFG', 'ClientODS', 'Manager'])
  folder.manage_permission('WebDAV Lock items', roles=['Manager'])
  folder.manage_permission('WebDAV Unlock items', roles=['Manager'])

def restore_permissions(folder):
  folder.manage_permission('Access contents information', acquire=1)
  folder.manage_permission('Add Documents, Images, and Files', acquire=1)
  folder.manage_permission('Add Envelopes', acquire=1)
  folder.manage_permission('Audit Envelopes', acquire=1)
  folder.manage_permission('Change Collections', acquire=1)
  folder.manage_permission('Change Envelopes', acquire=1)
  folder.manage_permission('Delete objects', acquire=1)
  folder.manage_permission('Manage properties', acquire=1)
  folder.manage_permission('Release Envelopes', acquire=1)
  folder.manage_permission('Take ownership', acquire=1)
  folder.manage_permission('Use OpenFlow', acquire=1)
  folder.manage_permission('WebDAV Lock items', acquire=1)
  folder.manage_permission('WebDAV Unlock items', acquire=1)


def forwards(app):
  ods = app.unrestrictedTraverse('ods')
  fgases = app.unrestrictedTraverse('fgases')

  cut_permissions(ods)
  cut_permissions(fgases)

  transaction.commit()


def backwards(app):
  ods = app.unrestrictedTraverse('ods')
  fgases = app.unrestrictedTraverse('fgases')

  restore_permissions(ods)
  restore_permissions(fgases)

  transaction.commit()
