#coding=utf-8
import os
import time
import hashlib
import urllib2
import cStringIO

from PIL import Image, ImageFilter

from lovewith.settings import FILE_UPLOAD_PATH


'''
使用方法
attach = request.FILES.get('files', None)
Upload().save_files(attach)
'''


class Upload:
    def __init__(self):
        self.base_path = FILE_UPLOAD_PATH
        self.save_folder = 'temp/'
        self.save_path = self.get_save_path()

    #获取文件保存路径
    def get_save_path(self):
        save_path = time.strftime('%Y/%m/%d', time.localtime(time.time()))
        try:
            os.makedirs('%s%s%s' % (self.base_path, self.save_folder, save_path))
        finally:
            return save_path

    #保存网络图片到本地
    def save_net_file(self, filepath):
        new_file_name = '%s.jpg' % hashlib.new('md5', filepath).hexdigest()
        new_save_path = '%s/%s' % (self.save_path, new_file_name)
        new_full_path = '%s%s%s' % (self.base_path, self.save_folder, new_save_path)

        http = urllib2.urlopen(filepath)
        img = Image.open(cStringIO.StringIO(http.read()))
        if img.mode != 'RGB':
            img = img.convert("RGB")
        img.save(new_full_path, 'jpeg', quality=100)

        return '%s%s' % (self.save_folder, new_save_path)

    #保存文件
    def save_files(self, att, blur=False):
        if hasattr(att, "name") and not att.name == "":
            new_file_name = '%s.jpg' % hashlib.new('md5', att.name + str(time.time())).hexdigest()
            new_save_path = '%s/%s' % (self.save_path, new_file_name)
            new_full_path = '%s%s%s' % (self.base_path, self.save_folder, new_save_path)

            #写文件
            img = Image.open(att.file)
            if img.mode != 'RGB':
                img = img.convert("RGB")

            img.save(new_full_path, 'jpeg', quality=100)

            #模糊图片
            if blur:
                img = img.filter(ImageFilter.GaussianBlur(radius=35))
                img.save(new_full_path.replace('.jpg', '_mask.jpg'), 'jpeg', quality=100)

            return '%s%s' % (self.save_folder, new_save_path)