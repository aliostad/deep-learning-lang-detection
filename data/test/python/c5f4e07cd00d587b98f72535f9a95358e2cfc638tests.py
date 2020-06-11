from django.test import TestCase
from storeApi.models import *
from storeApi.serializers import *
from rest_framework.renderers import JSONRenderer
from rest_framework.parsers import JSONParser

class TestProduct(TestCase):
        def test_Create(self):
                c = Category(name="oil")
                c.save()
                p = Product(name="oil", description="Oil 4 u", category=c)
                p.save()
                p = Product(name="oil", description="Balm 4 U", category=c)
                p.save()
                p = Product(name="Balm", description="Balm 4 U", category=c)
                p.save()
                p = Product(name="oil", description="Balm 4 U", category=c)
                p.save()
                p = Product(name="Balm", description="Balm 4 U", category=c)
                p.save()
                oil  = Product.objects.filter(name = "oil")
                balm = Product.objects.filter(name = "balm")
        def test_Serializer(self):
                c = Category(name="oil")
                c.save()
                p = Product(name="oil", description="Oil 4 u", category=c)
                p.save()
                x = Product(name="oil", description="Balm 4 U", category=c)
                x.save()
                i = Product(name="Balm", description="Balm 4 U", category=c)
                i.save()
                serializer = ProductSerializer(Product.objects.all(), many=True)
                print(serializer.data)

class TestProductImages(TestCase):
        def test_Create(self):
                c = Category(name="oil")
                c.save()
                p = Product(name="oil", description="Oil 4 u", category=c)
                p.save()
                pi = ProductImages(product=p,name="image")
                pi.save()
        def test_Get(self):
                c = Category(name="oil")
                c.save()
                p = Product(name="oil", description="Oil 4 u",category=c)
                p.save()
                pi = ProductImages(product=p,name="image")
                pi.save()
                image = ProductImages.objects.filter(name="image")
        def test_Serializer(self):
                c = Category(name="oil")
                c.save()
                p = Product(name="oil", description="Oil 4 u", category=c)
                p.save()
                pi = ProductImages(product=p,name="image")
                pi.save()
                serializer = ProductImageSerializer(ProductImages.objects.all(), many=True)
                print("\n______________________\n")
                print(serializer.data)

class TestAdress(TestCase):
        def test_Create(self):
                u = User(username="test")
                u.save()
                c = Client(user=u)
                c.save()
                a = Adress(client=c, name="test adress", default=False)
                a.save()

class TestOrder(TestCase):
        def test_Create(self):
                u = User(username="test")
                u.save()
                c = Client(user=u)
                c.save()
                a = Adress(client=c, name="test adress", default=False)
                a.save()
                p = Order(client=c, billingAdress=a,shippingAdress=a)
                p.save()
        def test_Serializer(self):
                u = User(username="test")
                u.save()
                c = Client(user=u)
                c.save()
                a = Adress(client=c, name="test adress", default=False)
                a.save()
                p = Order(client=c, billingAdress=a,shippingAdress=a)
                p.save()
                serializer = OrderSerializer(Order.objects.all(), many=True)
                print("\n______________________\n")
                print(serializer.data)
