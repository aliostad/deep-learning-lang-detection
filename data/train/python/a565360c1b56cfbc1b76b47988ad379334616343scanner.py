#Задача 1 - скачать страницу и вытащить из неё все ссылки
#Задача 2 - вытащить все ссылки со страницы
import http.cookiejar, urllib.request
from html.parser import HTMLParser

host = "http://epubs.siam.org"
jl = {}

class SIAM_I_Parser(HTMLParser):
	save_data = False
	save_link = ""
	save_citation = False
	save_authors = False
	save_doi = False
	marker = ""
	articles = {}
	def handle_starttag(self, tag, attrs):
		dAttrs = dict(attrs)
		if (tag=='a'):
			if ('class' in dAttrs):
				if ((dAttrs['class']=='ref nowrap')&(not('/doi/ref/' in dAttrs['href']))):
					self.save_link = dAttrs['href']
					self.articles[self.save_link] = {'doi':"",'title':"",'authors':"","citation":""}
				elif (dAttrs['class']=='entryAuthor'):
					self.save_authors = True
				elif (dAttrs['class']=='ref doi'):				
				    self.articles[self.save_link]['doi']=dAttrs['href']
		elif (tag =='div'):
			if ('class' in dAttrs):
				if (dAttrs['class']=='art_title'):
					
					self.save_data = True
				if (dAttrs['class']=='citation tocCitation'):
					self.save_citation = True
		elif (tag == 'span'):
			if ('class' in dAttrs):
				if (dAttrs['class']=='ciationPageRange'):
					self.save_citation = True
	def handle_data(self, data):
		if (self.save_data):
			self.articles[self.save_link]['title'] = data
			self.save_data = False	
		elif (self.save_authors):
			if ('authors' in self.articles[self.save_link]):
				authors = self.articles[self.save_link]['authors']
			else:
				authors = ""
			self.articles[self.save_link]['authors'] = authors + "," + data
			self.save_authors = False
		elif (self.save_citation):
			if ('citation' in self.articles[self.save_link]):
				cit = self.articles[self.save_link]['citation']
			else:
				cit = ""
			self.articles[self.save_link]['citation'] = cit + " " + data.strip()
			self.save_citation = False
			
class SIAM_J_Parser(HTMLParser):
	issues = {}
	save_data = False
	marker = ""
	def handle_starttag(self, tag, attrs):
		if (tag=='a'):
			for attr in attrs:
				if attr[0]=='href':
					if attr[1][0:len(self.marker)]==self.marker:
						self.save_data = True
						self.save_link = attr[1]
	def handle_data(self, data):
		if (self.save_data):
			self.issues[self.save_link]={'name':data}
			self.save_data = False	

class SIAM_JL_Parser(HTMLParser):
	save_data = False
	save_link = ""
	save_link_browse = ""
	save_browse = False
	def handle_starttag(self, tag, attrs):
		if (tag=='a'):
			for attr in attrs:
				if attr[0]=='href':
					if attr[1][0:9]=='/journal/':
						self.save_data = True
						self.save_link = attr[1]
					elif attr[1][0:5]=='/toc/':
						self.save_browse = True
						self.save_link_browse = attr[1]
	def handle_data(self, data):
		if (self.save_data):
			jl[self.save_link]={'name':data}
			self.save_data = False	
		elif (self.save_browse):
			jl[self.save_link]['browse']=self.save_link_browse
			self.save_browse = False
        #print("Encountered some data  :", data)

#подготавливаем контейнер для куков
cj = http.cookiejar.CookieJar()
#получаем первую страницу для анализа
opener = urllib.request.build_opener(urllib.request.HTTPCookieProcessor(cj))

#for j_link in jl:
#	short_name = j_link.split('/')[2]

#print(jl)