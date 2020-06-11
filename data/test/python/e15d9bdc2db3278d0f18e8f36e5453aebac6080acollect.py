import sys
import os.path
from urlparse import urljoin
import time
import urllib2

from bs4 import BeautifulSoup

class Collector:
    def __init__(self):
        pass
    
    def download_2015_excel(self, local_save_dir_base):
        uri = 'http://ontario.ca/sites/default/files/pssd_compendium_2014.xlsx'
        response = urllib2.urlopen(uri)
        excel_file = response.read()
        save_file_path = local_save_dir_base + 'pssd_compendium_2014.xlsx'

        print "Saving... " + uri + " to " + save_file_path

        with open(save_file_path, 'w') as text_file:
                text_file.write(excel_file)

    def get_relevant_links(self, html, sourceuri):
        relevant_links = []
        
        soup = BeautifulSoup(html)
        for link in soup.findAll('a'):
            href = link.get('href')
                   
            if href is not None:            
                href = urljoin(sourceuri, href)
                if (href[:7] != 'mailto:'):
                    if not any(x in href for x in ['#', '.pdf', '.xls', '.doc']):                            
                        if 'http://www.fin.gov.on.ca/en/publications/salarydisclosure/' in href:
                            relevant_links.extend([href])
        
        return relevant_links
    
    def run(self, local_save_dir_base):
        self.download_2015_excel(local_save_dir_base)

        local_save_dir_base = local_save_dir_base + 'scrape/'
        
        scraped_links = []
        
        # Seed the scraper with a good set of what we really care about
        unscraped_links = ['http://www.fin.gov.on.ca/en/publications/salarydisclosure/pssd/',
            'http://www.ontario.ca/government/public-sector-salary-disclosure/']

        for i in range(1997,2014):
            unscraped_links.extend(['http://www.fin.gov.on.ca/en/publications/salarydisclosure/' + str(i) + '/'])
    
        root_remote_dir = 'http://www.fin.gov.on.ca/en/publications/salarydisclosure/'
    
        while len(unscraped_links) > 0:
            uri = unscraped_links.pop(0)
            
            scraped_links.extend([uri])
            
            save_name = uri[len(root_remote_dir):]
            save_name = save_name.replace('?','&')
            if uri[-1:] == '/':
                save_name = save_name + "index.html"       
            
            
            
            
            if os.path.isfile(local_save_dir_base + save_name):
                with open(local_save_dir_base + save_name, "r") as text_file:
                    html = text_file.read()
            else:
                time.sleep(5)
                try:
                    print "Getting... " + uri
                    response = urllib2.urlopen(uri)
                    html = response.read()
                    uri_new = response.geturl()
                except urllib2.HTTPError:
                    print "Swallowing error: " + str(sys.exc_info()[0])
                    uri_new = uri
                    html = str(sys.exc_info()[0])
        
                if uri_new != uri:
                    save_name = uri_new[len(root_remote_dir):]
                    if uri_new[-1:] == '/':
                        save_name = save_name + "index.html"
                    save_name = save_name.replace('?','&')
                    scraped_links.extend([uri_new])
                    print "Redirects to... " + uri_new
                    uri = uri_new
                
                save_dir = save_name[:save_name.rfind('/')]
                if not os.path.exists(local_save_dir_base + save_dir):
                    os.makedirs(local_save_dir_base + save_dir)
                
                print "Saving... " + local_save_dir_base + save_name
                with open(local_save_dir_base + save_name, "w") as text_file:
                    text_file.write(html)
                
            links = self.get_relevant_links(html, uri)
            for link in links:
                if link not in scraped_links:
                    if link not in unscraped_links:
                        unscraped_links.extend([link])

        