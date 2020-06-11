#ToDO: 

from models import Question

# def helper_get(model, **kwargs):
# 	try:
# 		res = model.objects.get(**kwargs)
# 	except:
# 		res = []
# 	return res

def get(**kwargs):
	'''
	return questions by parameters
	'''
	try:
		res = Question.objects.get(**kwargs)
	except Question.DoesNotExist:
		res = ['']
	return res

def save_scratch(kind='', subject='', theme='', text='', answers=[]):
	'''
	save question from scratch to database
	'''
	q = Question(kind=kind, subject=subject, theme=theme, text=text, answers=answers)
	q.save()
	return True

def save(q):
	'''
	save question to database
	'''
	q.save()
	return True