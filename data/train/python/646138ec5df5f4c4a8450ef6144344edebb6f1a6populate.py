from restaurant.models import *

c = Category(name='home')
c.save()
Page(category=c, title='Home - Property Search', url='http://www.home.co.uk', views=0).save()
Page(category=c, title='Right Move', url='http://www.rightmove.co.uk', views=0).save()
c = Category(name='sport')
c.save()
Page(category=c, title='BBC Sport', url='http://www.bbc.co.uk/sport/0/', views=0).save()
Page(category=c, title='Sky Sports', url='http://www.skysports.com/', views=0).save()
Page(category=c, title='Sports News', url='http://www.sport.co.uk/', views=0).save()
c = Category(name='fun')
c.save()
Page(category=c, title='The Fun Theory', url='http://www.thefuntheory.com/', views=0).save()
Page(category=c, title='Comp. Sci. for Fun', url='http://www.cs4fn.org/', views=0).save()


user_name = User.objects.get(username='4')
r = Restaurant(user=user_name,name='1234',table_number=10)
r.save()

Food(restaurant=r, name='red curry', description='a popular Thai dish consisting of curry paste to which coconut milk is added.', price=100).save()
Food(restaurant=r, name='green curry', description='a popular Thai dish consisting of curry paste to which coconut milk is added.', price=125).save()
Food(restaurant=r, name='fire rice', description='a popular Thai dish consisting of curry paste to which coconut milk is added.', price=50).save()
Food(restaurant=r, name='noodles', description='a popular Thai dish consisting of curry paste to which coconut milk is added.', price=200).save()

Drink(restaurant=r,name="Coke").save()
Drink(restaurant=r,name="sprite").save()
Drink(restaurant=r,name="irn bru").save()
Drink(restaurant=r,name="fanta").save()
Drink(restaurant=r,name="7up").save()
Drink(restaurant=r,name="red bull").save()
Drink(restaurant=r,name="pepsi").save()
Drink(restaurant=r,name="whiskey").save()
Drink(restaurant=r,name="Beer").save()



Ingredient(restaurant=r,name="chicken", category="protein").save()
Ingredient(restaurant=r,name="beef", category="protein").save()
Ingredient(restaurant=r,name="pork", category="protein").save()
Ingredient(restaurant=r,name="fish", category="protein").save()
Ingredient(restaurant=r,name="egg", category="protein").save()
Ingredient(restaurant=r,name="ham", category="protein").save()
Ingredient(restaurant=r,name="shell", category="protein").save()



Ingredient(restaurant=r,name="rice", category="carbohydrate").save()
Ingredient(restaurant=r,name="bread", category="carbohydrate").save()
Ingredient(restaurant=r,name="sugar", category="carbohydrate").save()
Ingredient(restaurant=r,name="noodles", category="carbohydrate").save()
Ingredient(restaurant=r,name="sticky rice", category="carbohydrate").save()
Ingredient(restaurant=r,name="potato", category="carbohydrate").save()

Ingredient(restaurant=r,name="cucumber", category="vegetable").save()
Ingredient(restaurant=r,name="onions", category="vegetable").save()
Ingredient(restaurant=r,name="cabbage", category="vegetable").save()
Ingredient(restaurant=r,name="carrot", category="vegetable").save()
Ingredient(restaurant=r,name="brocoli", category="vegetable").save()
Ingredient(restaurant=r,name="spinach", category="vegetable").save()
Ingredient(restaurant=r,name="pickle", category="vegetable").save()



Ingredient(restaurant=r,name="Banana", category="fruit").save()
Ingredient(restaurant=r,name="Orange", category="fruit").save()
Ingredient(restaurant=r,name="Apple", category="fruit").save()
Ingredient(restaurant=r,name="tomato", category="fruit").save()



Ingredient(restaurant=r,name="oil", category="other").save()
Ingredient(restaurant=r,name="buter", category="other").save()
Ingredient(restaurant=r,name="garlic", category="other").save()
Ingredient(restaurant=r,name="soi sauce", category="other").save()
Ingredient(restaurant=r,name="gravy", category="other").save()
Ingredient(restaurant=r,name="lemon", category="other").save()
Ingredient(restaurant=r,name="pepper", category="other").save()
Ingredient(restaurant=r,name="salt", category="other").save()

