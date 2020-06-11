import requests
class ApiIdol:
	API_URL = "http://api.idolondemand.com/1/api/sync/{}/v1"
	API_KEY = "81996ad0-12b9-43cc-8832-a008f8e64696"
	
	def call_api(self, api, text):
		url = self.API_URL.format(api)
		data= {"apikey":self.API_KEY, "text":text}
		
		return requests.post(url, data=data)

	def highlight_text(self, text, highlight_terms, span_class):
		url = self.API_URL.format("highlighttext")
		data= {"apikey":self.API_KEY, "text":text, 
			"highlight_expression":highlight_terms, "start_tag":span_class }
		
		return requests.post(url, data=data)