#!/usr/bin/python
# encoding=utf8

'''
USAGE

    python manage.py init : clean up all database records, create db schemes accordingly

    python manage.py collect : collect links for crawler to use
    python manage.py crawl --link=/xxx/xxx/xx : crawl specific link and output, no db writeback
    python manage.py crawl : continue to crawl this website

    python manage.py update : continue to update/verify corresponding database entries
    python manage.py dump : dump the whole database to *.sql file
'''
