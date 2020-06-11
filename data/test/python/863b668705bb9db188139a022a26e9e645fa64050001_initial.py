# -*- coding: utf-8 -*-
import datetime
from south.db import db
from south.v2 import SchemaMigration
from django.db import models


class Migration(SchemaMigration):

    def forwards(self, orm):
        # Adding model 'ProxyRequest'
        db.create_table('broker_proxyrequest', (
            ('url', self.gf('django.db.models.fields.URLField')(max_length=200)),
            ('token', self.gf('django.db.models.fields.TextField')(unique=True, primary_key=True, db_index=True)),
        ))
        db.send_create_signal('broker', ['ProxyRequest'])

        # Adding model 'Proxy'
        db.create_table('broker_proxy', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('request', self.gf('django.db.models.fields.related.OneToOneField')(related_name='data', unique=True, to=orm['broker.ProxyRequest'])),
            ('manifest', self.gf('django.db.models.fields.TextField')()),
            ('mode_read', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
            ('mode_write', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
            ('mode_query', self.gf('django.db.models.fields.TextField')(null=True, blank=True)),
        ))
        db.send_create_signal('broker', ['Proxy'])

        # Adding model 'Metadata'
        db.create_table('broker_metadata', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('proxy', self.gf('django.db.models.fields.related.ForeignKey')(related_name='metadata', to=orm['broker.Proxy'])),
            ('BB_north', self.gf('django.db.models.fields.FloatField')()),
            ('BB_east', self.gf('django.db.models.fields.FloatField')()),
            ('BB_south', self.gf('django.db.models.fields.FloatField')()),
            ('BB_west', self.gf('django.db.models.fields.FloatField')()),
            ('meta', self.gf('django.db.models.fields.TextField')()),
            ('name', self.gf('django.db.models.fields.TextField')()),
        ))
        db.send_create_signal('broker', ['Metadata'])

        # Adding model 'MetadataRefreshTime'
        db.create_table('broker_metadatarefreshtime', (
            ('id', self.gf('django.db.models.fields.AutoField')(primary_key=True)),
            ('metadata', self.gf('django.db.models.fields.related.ForeignKey')(to=orm['broker.Metadata'])),
            ('crontab', self.gf('django.db.models.fields.TextField')(default='0 1 * * SAT')),
        ))
        db.send_create_signal('broker', ['MetadataRefreshTime'])


    def backwards(self, orm):
        # Deleting model 'ProxyRequest'
        db.delete_table('broker_proxyrequest')

        # Deleting model 'Proxy'
        db.delete_table('broker_proxy')

        # Deleting model 'Metadata'
        db.delete_table('broker_metadata')

        # Deleting model 'MetadataRefreshTime'
        db.delete_table('broker_metadatarefreshtime')


    models = {
        'broker.metadata': {
            'BB_east': ('django.db.models.fields.FloatField', [], {}),
            'BB_north': ('django.db.models.fields.FloatField', [], {}),
            'BB_south': ('django.db.models.fields.FloatField', [], {}),
            'BB_west': ('django.db.models.fields.FloatField', [], {}),
            'Meta': {'object_name': 'Metadata'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'meta': ('django.db.models.fields.TextField', [], {}),
            'name': ('django.db.models.fields.TextField', [], {}),
            'proxy': ('django.db.models.fields.related.ForeignKey', [], {'related_name': "'metadata'", 'to': "orm['broker.Proxy']"})
        },
        'broker.metadatarefreshtime': {
            'Meta': {'object_name': 'MetadataRefreshTime'},
            'crontab': ('django.db.models.fields.TextField', [], {'default': "'0 1 * * SAT'"}),
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'metadata': ('django.db.models.fields.related.ForeignKey', [], {'to': "orm['broker.Metadata']"})
        },
        'broker.proxy': {
            'Meta': {'object_name': 'Proxy'},
            'id': ('django.db.models.fields.AutoField', [], {'primary_key': 'True'}),
            'manifest': ('django.db.models.fields.TextField', [], {}),
            'mode_query': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'mode_read': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'mode_write': ('django.db.models.fields.TextField', [], {'null': 'True', 'blank': 'True'}),
            'request': ('django.db.models.fields.related.OneToOneField', [], {'related_name': "'data'", 'unique': 'True', 'to': "orm['broker.ProxyRequest']"})
        },
        'broker.proxyrequest': {
            'Meta': {'object_name': 'ProxyRequest'},
            'token': ('django.db.models.fields.TextField', [], {'unique': 'True', 'primary_key': 'True', 'db_index': 'True'}),
            'url': ('django.db.models.fields.URLField', [], {'max_length': '200'})
        }
    }

    complete_apps = ['broker']