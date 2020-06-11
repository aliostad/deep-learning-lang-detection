from google.appengine.api.labs import taskqueue

def dispatchBookAdded(book, reader):
	dispatchBookEvent(book, reader, '/tasks/bookadded', 'bookadded')

def dispatchBookFinished(book, reader):
	dispatchBookEvent(book, reader, '/tasks/bookfinished', 'bookfinished')
	
def dispatchBookInprogress(book, reader):
	dispatchBookEvent(book, reader, '/tasks/bookinprogress', 'bookinprogress')

def dispatchBookEvent(book, reader, url, queue_name):

	task = taskqueue.Task(url=url, params={'book' : book.identifier(), 'reader' : reader.identifier()})
	queue = taskqueue.Queue(queue_name)
	
	queue.add(task)