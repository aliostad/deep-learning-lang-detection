from be_local_server.models import *
from datetime import *
from django.core.files import File 
import urllib
from taggit.models import Tag

# CATEGORIES & TAGS

# Create Categories
c1 = Category(
	name="Uncategorized",
	slug="uncategorized"
)

c2 = Category(
	name="Fruits",
	slug="fruits"
)
c3 = Category(
	name="Vegetables",
	slug="vegetables"
)

c4 = Category(
	name="Eggs & Dairy",
	slug="egg-dairy"
)

c5 = Category(
	name="Meat & Fish",
	slug="meat-fish"
)

c6 = Category(
	name="Baked Goods",
	slug="baked-goods"
)

c7 = Category(
	name="Prepared Foods",
	slug="prepared-foods"
)

c8 = Category(
	name="Preserves",
	slug="preserves"
)

# Save it
c1.save()
c2.save()
c3.save()
c4.save()
c5.save()
c6.save()
c7.save()
c8.save()

# Create Tags
t1 = Tag(
	name="Certified Organic",
	slug="organic"
)
t2 = Tag(
	name="Dairy Free",
	slug="dairy-free"
)
t3 = Tag(
	name="Gluten Free",
	slug="gluten-free"
)
t4 = Tag(
	name="Kosher Certified",
	slug="kosher"
)
t5 = Tag(
	name="Non-GMO",
	slug="non-gmo"
)
t6 = Tag(
	name="Nut Free",
	slug="nut-free"
)
t7 = Tag(
	name="Vegan",
	slug="vegan"
)
t8 = Tag(
	name="Vegetarian",
	slug="vegetarian"
)
t9 = Tag(
	name="Free Range",
	slug="free-range"
)

# Save it
t1.save()
t2.save()
t3.save()
t4.save()
t5.save()
t6.save()
t7.save()
t8.save()
t9.save()
