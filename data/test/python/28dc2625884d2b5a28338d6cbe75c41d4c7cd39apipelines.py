#! /usr/bin/env python
#coding=utf-8
# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/topics/item-pipeline.html
try:
    import json
except ImportError:
    try:
        import simplejson as json
    except ImportError:
        raise DirectException("No JSON library available. Please install"
                              " simplejson or upgrade to Python 2.6.")

from pymongo import Connection
conn = Connection('192.168.100.253',27017)
bcdb = conn.brokercrawl
anjuke = bcdb.anjuke
soufun = bcdb.soufun
focus = bcdb.focus

class BrokercrawlPipeline(object):
    def process_item(self, item, spider):
        itemdict = dict(item)
        if spider.name in ('anjuke_list',):
            broker = anjuke.find_one({"uid" : itemdict['uid']})
            if broker:
                for key,value in item._values.items():
                    broker[key] = value                
                anjuke.save(broker)
            else:
                anjuke.save(itemdict)
        if spider.name in ('soufun_list',):
            broker = soufun.find_one({"uid" : itemdict['uid']})
            if broker:
                for key,value in item._values.items():
                    broker[key] = value                
                soufun.save(broker)
            else:
                soufun.save(itemdict)        
        if spider.name in ('focus_list',):
            broker = focus.find_one({"uid" : itemdict['uid']})
            if broker:
                for key,value in item._values.items():
                    broker[key] = value                
                focus.save(broker)
            else:
                focus.save(itemdict)                
        return item
