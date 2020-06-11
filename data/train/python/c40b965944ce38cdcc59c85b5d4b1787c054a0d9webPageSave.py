#!/usr/bin/python
# -*- coding: utf-8 -*-
# author : pengxiangxiong
# email  : pengxiangxiong@baidu.com

import urllib
import urllib2
import os

class WebPageSave(object):
    def __init__(self):
        pass

    def save(self, url, outputDir):
        if not os.path.isdir(outputDir):
            os.makedirs(outputDir)
        filename = outputDir + '/' + urllib2.quote(url.strip(), safe = '')
        urllib.urlretrieve(url, filename)


if __name__ == '__main__':
    webPageSave = WebPageSave()
    webPageSave.save('http://www.baidu.com', './output')


# vim: set expandtab ts=4 sw=4 sts=4 tw=100:

