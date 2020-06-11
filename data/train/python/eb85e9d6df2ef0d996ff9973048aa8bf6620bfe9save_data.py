"""Saving some data to the demo application"""

from demo.models import *

def save_data():
    """Save test data for the demo application"""
    
    # keywords
    comfortable = Keyword(word="Comfortable")
    comfortable.save()
    
    trainers = Keyword(word="Trainers")
    trainers.save()
    
    sporty = Keyword(word="Sporty")
    sporty.save()
    
    cool = Keyword(word='Cool')
    cool.save()
    
    trendy = Keyword(word='Trendy')
    trendy.save()

    # cities
    hollywood = City(name="Hollywood", in_south=True)
    hollywood.save()
    
    helsinki = City(name="Helsinki", in_south=False)        
    helsinki.save()
    
    almaty = City(name="Almaty", in_south=False)
    almaty.save()
    
    bishkek = City(name="Bishkek", in_south=False)
    bishkek.save()
    
    # manufacturers    
    diesel = Manufacturer(name="Diesel", home_city=hollywood)
    diesel.save()
    
    lange = Manufacturer(name="Lange", home_city=helsinki)
    lange.save()
    
    # categories
    for_sports = ShoeCategory(name='For Sports')
    for_sports.save()
    
    casual = ShoeCategory(name='Casual')
    casual.save()
    
    # shoes
    sneakers = ShoePair(
        name="Sneakers",
        manufacturer=diesel,
        for_winter=False,
        image_path='/images/Trainers.gif',
        category=casual
    )
    sneakers.save()
    sneakers.keywords.add(comfortable,trainers, cool)
    sneakers.save()
    
    rubber_shoes = ShoePair(
        name="Rubber Shoes",
        manufacturer=diesel,
        for_winter=False,
        image_path='/images/Rubber_Boots.gif'
    )
    rubber_shoes.save()
    rubber_shoes.keywords.add(comfortable)
    rubber_shoes.save()
    
    ski_boots = ShoePair(
        name='RS 130',
        manufacturer=lange,
        for_winter=True,
        image_path='/images/ski-boot.jpg',
        category=for_sports       
    )
    ski_boots.save()
    ski_boots.keywords.add(sporty)
    ski_boots.save()
    
    design_shoes = ShoePair(
        name="Design Shoes",
        category=casual,
        for_winter=False
    )
    design_shoes.save()
    design_shoes.keywords.add(cool, trendy)
    sneakers.save()    
    
    octane_sl = ShoePair(
        name="Octane SL",
        category=for_sports,
        for_winter=False
    )
    octane_sl.save()
    
    # users    
    alice = User(
        name="Alice",
        age=19,
        home_city=hollywood
    )
    alice.save()
    alice.viewed_shoes.add(rubber_shoes)
    alice.likes_shoes.add(sneakers)
    alice.save()
    
    ShoeRating.objects.create(
        user=alice,
        shoe_pair=design_shoes,
        stars=4)
    
    bob = User(
        name="Bob",
        age=18,
        home_city=hollywood
    )
    bob.save()
    bob.viewed_shoes.add(sneakers)
    bob.words_searched.add(sporty, comfortable)
    bob.likes_shoes.add(sneakers)
    bob.save()
    
    ShoeRating.objects.create(
        user=bob,
        shoe_pair=design_shoes,
        stars=1)
    
    cindy = User(
        name="Cindy",
        age=25,
        home_city=helsinki
    )
    cindy.save()
    cindy.viewed_shoes.add(rubber_shoes)
    cindy.words_searched.add(comfortable, cool)
    cindy.save()
    
    # a user with usable demographic info
    daisy = User(
        name="Daisy",
        age=32,
        home_city=helsinki
    )
    daisy.save()
    
    # a user to test recommending similar shoes to liked
    edgar = User(
        name="Edgar",
        age=42,
        home_city=almaty
    )
    edgar.save()
    edgar.likes_shoes.add(rubber_shoes, ski_boots)
    edgar.save()
    
    # a user to test recommending by cf (shoes liked by a similar user)
    fionna = User(
        name="Fionna",
        age=42,
        home_city=bishkek,
    )
    fionna.save()
