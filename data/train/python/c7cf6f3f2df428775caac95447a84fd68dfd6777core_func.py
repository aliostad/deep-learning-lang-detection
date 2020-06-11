#!/usr/bin/python3
# -*- coding: utf-8 -*- 

'''
几个核心功能：
1.文章点赞（Vote）		2.文章分享（Share）
3.文章保存（Save）		4.文章评论（Remark）
5.邮件反馈（Email）

'''

def articleVote(D):
	print(D['TITLE']+'\t喜欢+1')

def articleShare(D, blabla=''):
	pass

def articleRemark(D, comment):
	pass

def sendEmail():
	pass

class Saver(object):
	"""docstring for Saver"""
	def __init__(self, data, path=''):
		super(Saver, self).__init__()
		self.__content_to_save = data
		self.__path_to_save = path

	def setPath(self):
		pass

	def saveHTML(self):
		pass

	def savePDF(self):
		pass

	def savePlainText(self):
		pass
		