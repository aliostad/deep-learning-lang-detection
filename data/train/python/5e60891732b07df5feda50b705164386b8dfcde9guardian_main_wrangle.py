"""
Takes raw data pulled from main guardian crawl (guardian_main_crawl.py).
Puts this data into dictionary format, with keys as 'id'.
This dict is itself saved as a pickle.
"""

import pickle
import options
reload(options)
from general_functions import *
import general_functions
reload(general_functions)
from bs4 import BeautifulSoup


def extract_internal_links(HTML):
	"""
	Looks through HTML and extracts internal hyperlinks
	"""
	from bs4 import BeautifulSoup
	soup = BeautifulSoup(HTML)
	link_list = [link.get('href') for link in soup.find_all('a')]
	return link_list
	

# Load data, in the format of a big list
raw_data = load_pickle(options.raw_pickle_path)
articles = load_pickle(options.current_articles_path)


# Loop through requests, and create dict by article ID. Can rewrite or not rewrite (set in options.py)
for request in raw_data:
	article_list = request['response']['results']
	
	# Loop through articles in each request
	for a in article_list:
		
		# Key
		save_key = a['id']
		print "Article: %s" %(save_key)
		
		# Delete key from articles if we want to overwrite all of this info
		if options.overwrite_articles:
			articles.pop(save_key, None)
			print "Deleting previous data (i.e. we will overwrite with new data)."
		
		# If we are not overwriting and we have already saved this key, we will break here (i.e. continue)
		if save_key in articles:
			print "We have already covered this article, skipping..."
			continue

		# List of tags
		tags = a['tags']
		save_tags = []
		for t in tags:
			save_tags.append(t['webTitle'])
		
		# Core info
		save_sectionName = a['sectionName']
		save_sectionId = a['sectionId']
		save_webPublicationDate = a['webPublicationDate']
		save_date = general_functions.convert_str_to_date(a['webPublicationDate'])  
		save_webUrl = a['webUrl']
		
		# Article body etc.
		try:
			save_headline = a['fields']['headline']
		except:
			save_headline = ""
		try:
			save_standfirst = a['fields']['standfirst']
		except:
			save_standfirst = ""
		try:
			save_byline = a['fields']['byline']
		except:
			save_byline = ""
		try:
			save_body = a['fields']['body']
		except:
			save_body = ""
		try:
			save_thumbnail = a['fields']['thumbnail']
		except:
			save_thumbnail = ""

		# Extract internal links
		save_internal_links = ""
		if options.find_internal_links:
			try:
				#internal_links = extract_internal_links(save_body)
				soup = BeautifulSoup(save_body)
				save_internal_links = [link.get('href') for link in soup.find_all('a') if 'theguardian.com' in link.get('href')]
			except:
				None

		# If we have got this far, we want to save all to the articles dict
		print "Adding data to articles store."
		articles[save_key] = 	{
									'id' : save_key,
									'sectionName' : save_sectionName,
									'sectionId' : save_sectionId,
									'date_string' : save_webPublicationDate,
									'date' : save_date,
									'url' : save_webUrl,
									'tags' : save_tags,
									'headline' : save_headline,
									'standfirst' : save_standfirst,
									'byline' : save_byline,
									'body' : save_body,
									'thumbnail' : save_thumbnail,
									'internal_links':save_internal_links
								}
		
print "Overall we have %s articles in the collection" %(len(articles))
save_pickle (articles, "data/articles.p")




