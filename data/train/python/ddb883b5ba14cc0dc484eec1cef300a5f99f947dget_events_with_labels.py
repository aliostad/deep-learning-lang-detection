__author__ = 'snipe'

import csv, glob, sys, gzip, json, ijson, datetime, codecs
from pymongo import MongoClient
from itertools import izip_longest, permutations

class EventsGetter():
    db = None
    csv_files = None
    csv_data = None
    first_row = None

    def open_mongo_db(self):
        self.db = MongoClient(host='localhost', port=27017)

    def print_to_csv(self, data):
        with codecs.open('csv/export_labels.csv', 'a+', 'utf-8-sig') as f:
            f.write(u"repository_owner;repository_url;repository_name;issue;label")

            for item in data:
                try:
                    f.write(u"\r\n"+'u"%(repository_owner)s";"%(repository_url)s";"%(repository_name)s";"%(issue)s";"%(label)s"' % item)
                except Exception, e:
                    print e, item

    def get_data(self):
        issues = self.db.wikiteams.labels.find()

        ev = []

        for issue in issues:
            print '.',
            for label in issue['labels']:
                tmp = {'repository_owner': issue['repository_owner'], 'repository_url': issue['repository_url'], 'repository_name': issue['repository_name'], 'issue': issue['issue'], 'label': label}
                ev.append(tmp)

        print "save to csv"
        self.print_to_csv(ev)

if __name__ == "__main__":
    importer = EventsGetter()
    importer.open_mongo_db()
    importer.get_data()
