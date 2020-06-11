from mongoengine import connect
from models import Todo

def main():
  connect('todo', host='mongodb://localhost:27017/test')
  Todo.objects.delete()
  Todo(task= 'This is task 1').save()
  Todo(task= 'This is task 2').save()
  Todo(task= 'This is task 3').save()
  Todo(task= 'This is task 4').save()
  Todo(task= 'This is task 5').save()
  Todo(task= 'This is task 6').save()
  Todo(task= 'This is task 7').save()
  Todo(task= 'This is task 8').save()
  Todo(task= 'This is task 9').save()
  Todo(task='This is task 10').save()


if __name__ == '__main__':
  main()
