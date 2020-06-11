from mongoengine import *

connect('suloop')


from accounts.models import *
from interests.models import *
from events.models import *


#InterestCategories
prof = InterestCategory(name='Professional').save()
sport = InterestCategory(name='Sports & Recreation').save()
music = InterestCategory(name='Music, Arts & Theater').save()
social = InterestCategory(name='Social').save()
religious = InterestCategory(name='Religious').save()

#Interests
GSB = Interest(name='GSB')
GSB.interestcategory = prof
GSB.save()

GSC = Interest(name='GSC')
GSC.interestcategory = social
GSC.save()

Basketball = Interest(name='Basketball')
Basketball.interestcategory = sport
Basketball.save()

Rowing = Interest(name='Rowing')
Rowing.interestcategory = sport
Rowing.save()

Track = Interest(name='Track')
Track.interestcategory = sport
Track.save()

bYoga = Interest(name='Bhakti Yoga')
bYoga.interestcategory = religious
bYoga.save()

CCRMA = Interest(name='CCRMA')
CCRMA.interestcategory = music
CCRMA.save()

Art = Interest(name='Cantor Arts Center')
Art.interestcategory = music
Art.save()

#Events

tnp = Event(name='Tuck & Patti').save()
stor = Event(name='Storied Past: Four Centuries of French Drawings from the Blanton Museum of Art').save()
ncaa = Event(name='Ncaa Championships Second Day').save()
womrow = Event(name="Women's Rowing").save()


#EventInterest

tnpcc = InterestEvent(interest=CCRMA, event=tnp).save()
tnpa = InterestEvent(interest=Art, event=tnp).save()

stora = InterestEvent(interest=Art, event=stor).save()
storgc = InterestEvent(interest=GSC, event=stor).save()

womrowrow =InterestEvent(interest=Rowing, event=womrow).save()

ncaatr = InterestEvent(interest=Track, event=ncaa).save()

#Users

#Sally
sally = User(email='sally@example.com')
sally.first_name = 'sally'
sally.last_name = 'cooper'
sally.save()

#SallyInterest
sallyGSB = InterestUser(interest=GSB, user=sally).save()
sallyGSC = InterestUser(interest=GSC, user=sally).save()
sallyart = InterestUser(interest=Art, user=sally).save()
sallyBasketball = InterestUser(interest=Basketball, user=sally).save()
sallyRowing = InterestUser(interest=Rowing, user=sally).save()
sallyTrack = InterestUser(interest=Track, user=sally).save()

#SallyEvent
sallywomrow = EventUser(event=womrow, user=sally).save()
sallyncaa = EventUser(event=ncaa, user=sally).save()
sallystor = EventUser(event=stor, user=sally).save()

#Adam
adam = User(email='adam@example.com')
adam.first_name = 'adam'
adam.last_name = 'newell'
adam.save()

#AdamInterest
adamGSC = InterestUser(interest=GSC, user=adam).save()
adambYoga = InterestUser(interest=bYoga, user=adam).save()
adamCCRMA = InterestUser(interest=CCRMA, user=adam).save()

#AdamEvent
adamstor = EventUser(event=stor, user=adam).save()
adamtnp = EventUser(event=tnp, user=adam).save()


#Jake
jake = User(email='jake@example.com')
jake.first_name = 'jake'
jake.last_name = 'veloz'
jake.save()

#JakeInterest
jakeGSB = InterestUser(interest=GSB, user=jake).save()
jakeBasketball = InterestUser(interest=Basketball, user=jake).save()
jakeRowing = InterestUser(interest=Rowing, user=jake).save()
jakeTrack = InterestUser(interest=Track, user=jake).save()
jakeCCRMA = InterestUser(interest=CCRMA, user=jake).save()

#JakeEvent
jaketnp = EventUser(event=tnp, user=jake).save()
jakewomrow = EventUser(event=womrow, user=jake).save()
jakencaa = EventUser(event=ncaa, user=jake).save()

#EventMessages

#tnp
#adam
adamtnpmes = EventMessage(message='Hey, is this anything useful ?', 
							user=adam, event=tnp).save()
#jake
jaketnpmes = EventMessage(message='Am excited! See all of you there soon!', 
							user=jake, event=tnp).save()

#stor
#adam
adamstormes = EventMessage(message="Hey, this looks exciting, I'll be there surely", 
							user=adam, event=stor).save()
#sally
sallystormes = EventMessage(message="GSC in collaboration with Cantor Arts "+ 
									"organizing this amazing event..Be there all!!", 
									user=sally, event=stor).save()

#ncaa
#sally
sallyncaames = EventMessage(message="Seems like an interesting Track event..", 
							user=sally, event=ncaa).save()
#jake
jakencaames = EventMessage(message="Wow! Excited to see Stanford women run!", 
							user=jake, event=ncaa).save()

#womrow
#sally
sallywomrowmes = EventMessage(message="Excited for the Stanford women row team!", 
								user=sally, event=womrow).save()
#jake
jakewomrowmes = EventMessage(message="Hoping the best for Stan women row team this time!",
							 user=jake, event=womrow).save()